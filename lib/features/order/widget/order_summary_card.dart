import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/order/models/order_summary_model.dart';
import 'package:e_commerce_app/features/order/models/order_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.order});
  final OrderSummaryModel order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.orderDetailesScreen,
          extra: order.id,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(order.status),
                    color: _getStatusColor(order.status),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order.id}',
                        style: AppStyles.black15BoldStyle.copyWith(fontSize: 16.sp),
                      ),
                      const HeightSpace(4),
                      Text(
                        'Placed on ${_formatDate(order.createdAt)}',
                        style: AppStyles.subtitlesStyles.copyWith(fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    order.status.displayName(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Amount', '\$${order.totalPrice.toStringAsFixed(2)}', isBold: true),
                _buildInfoColumn('Order date', _formatDate(order.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value,
      {Color? color, bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PendingPayment:
        return Colors.orange;
      case OrderStatus.Paid:
      case OrderStatus.Delivered:
        return Colors.green;
      case OrderStatus.Cancelled:
      case OrderStatus.PaymentFailed:
        return Colors.red;
      case OrderStatus.Shipped:
        return Colors.blue;
      case OrderStatus.Processing:
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.PendingPayment:
        return Icons.hourglass_top;
      case OrderStatus.Paid:
        return Icons.check_circle_outline;
      case OrderStatus.Delivered:
        return Icons.local_shipping_outlined;
      case OrderStatus.Cancelled:
      case OrderStatus.PaymentFailed:
        return Icons.cancel_outlined;
      case OrderStatus.Shipped:
        return Icons.local_shipping;
      case OrderStatus.Processing:
        return Icons.autorenew;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}