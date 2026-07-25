import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/features/order/cubit/order_details_cubit.dart';
import 'package:e_commerce_app/features/order/cubit/order_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/order/models/order_status.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailesScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailesScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FF),
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listener: (context, state) {
          if (state is PaymentCompletedForOrder) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment completed')),
            );
          } else if (state is PaymentFailedForOrder) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment failed: ${state.message}')),
            );
          } else if (state is PaymentCancelledForOrder) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment cancelled')),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingOrderDetails) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SuccessOrderDetails) {
            final order = state.order;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(context, order, state),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Shipping Address'),
                  _buildShippingCard(order),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Order Items'),
                  ...order.items.map((item) => _buildOrderItemCard(item)).toList(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          } else if (state is ErrorOrderDetails) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, dynamic order, OrderDetailsState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  _getStatusIcon(order.status),
                  color: _getStatusColor(order.status),
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: AppStyles.black18BoldStyle,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Placed on ${_formatDate(order.orderDate)}',
                      style: AppStyles.subtitlesStyles.copyWith(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildSummaryChip('Date', _formatDate(order.orderDate)),
              SizedBox(width: 12.w),
              _buildSummaryChip('Total', '\$${order.totalAmount.toStringAsFixed(2)}'),
              SizedBox(width: 12.w),
              _buildSummaryChip('Items', '${order.items.length}'),
            ],
          ),
          if (order.status == OrderStatus.PendingPayment || order.status == OrderStatus.PaymentFailed) ...[
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                onPressed: state is PaymentProcessing || state is InitializingPaymentSheetForOrder || state is PresentingPaymentSheetForOrder
                    ? null
                    : () {
                        context.read<OrderDetailsCubit>().pay(order.id);
                      },
                child: state is PaymentProcessing
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Pay Now',
                        style: AppStyles.black16w500Style.copyWith(color: Colors.white),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingCard(dynamic order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xffE8ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Address', style: AppStyles.black16w500Style),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.shippingAddress.street, style: AppStyles.black16w500Style),
                    SizedBox(height: 6.h),
                    Text(
                      '${order.shippingAddress.city}, ${order.shippingAddress.country}',
                      style: AppStyles.subtitlesStyles.copyWith(color: AppColors.secondaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(dynamic item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              width: 78.w,
              height: 78.w,
              fit: BoxFit.cover,
              imageUrl: '${ApiEndpoints.baseUrl}/${item.product.primaryImageUrl}',
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: AppStyles.black16w500Style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  item.product.description,
                  style: AppStyles.subtitlesStyles.copyWith(fontSize: 12.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'x${item.quantity}',
                      style: AppStyles.black15BoldStyle.copyWith(fontSize: 13.sp, color: AppColors.secondaryColor),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: AppStyles.black15BoldStyle.copyWith(fontSize: 14.sp, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF7F8FF),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: AppColors.secondaryColor),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    String label = status.displayName();
    Color color;
    switch (status) {
      case OrderStatus.PendingPayment:
        color = Colors.orange;
        break;
      case OrderStatus.Paid:
        color = Colors.green;
        break;
      case OrderStatus.Processing:
        color = Colors.orangeAccent;
        break;
      case OrderStatus.Shipped:
        color = Colors.blue;
        break;
      case OrderStatus.Delivered:
        color = Colors.green;
        break;
      case OrderStatus.Cancelled:
        color = Colors.red;
        break;
      case OrderStatus.PaymentFailed:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.PendingPayment:
        return Icons.hourglass_top;
      case OrderStatus.Paid:
        return Icons.check_circle_outline;
      case OrderStatus.Processing:
        return Icons.autorenew;
      case OrderStatus.Shipped:
        return Icons.local_shipping;
      case OrderStatus.Delivered:
        return Icons.home_filled;
      case OrderStatus.Cancelled:
        return Icons.cancel_outlined;
      case OrderStatus.PaymentFailed:
        return Icons.payment;
      default:
        return Icons.info_outline;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PendingPayment:
        return Colors.orange;
      case OrderStatus.Paid:
      case OrderStatus.Delivered:
        return Colors.green;
      case OrderStatus.Processing:
        return Colors.orangeAccent;
      case OrderStatus.Shipped:
        return Colors.blue;
      case OrderStatus.Cancelled:
      case OrderStatus.PaymentFailed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: AppStyles.black18BoldStyle,
      ),
    );
  }
}
