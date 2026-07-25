import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: cartItem.imageUrl != null
                    ? "${ApiEndpoints.baseUrl}/${cartItem.imageUrl}"
                    : "https://via.placeholder.com/150",
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            const WidthSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.productName ?? "Product Name",
                          style: AppStyles.black15BoldStyle.copyWith(fontSize: 15.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (cartItem.cartItemId != null) {
                            context.read<CartCubit>().removeCartItem(cartItem.cartItemId!);
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$${cartItem.price?.toStringAsFixed(2)}",
                        style: AppStyles.black15BoldStyle.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildQuantityButton(
                            context,
                            icon: Icons.remove,
                            onTap: () {
                              if (cartItem.cartItemId != null && (cartItem.quantity ?? 0) > 1) {
                                context.read<CartCubit>().decrementQuantity(cartItem.cartItemId!);
                              }
                            },
                          ),
                          const WidthSpace(12),
                          Text(
                            cartItem.quantity.toString(),
                            style: AppStyles.black15BoldStyle.copyWith(fontSize: 16.sp),
                          ),
                          const WidthSpace(12),
                          _buildQuantityButton(
                            context,
                            icon: Icons.add,
                            onTap: () {
                              if (cartItem.cartItemId != null) {
                                context.read<CartCubit>().incrementQuantity(cartItem.cartItemId!);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.blackColor),
      ),
    );
  }
}
