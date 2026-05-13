import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
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
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CachedNetworkImage(
              imageUrl:cartItem.imageUrl != null ? "${ApiEndpoints.baseUrl}/${cartItem.imageUrl}" : "https://via.placeholder.com/150",
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
            WidthSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartItem.productName ?? "Product Name ",
                        style: AppStyles.black15BoldStyle,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          context.read<CartCubit>().removeCartItem(cartItem.cartItemId!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(30),
                  Row(
                    children: [
                      Text(
                        "${cartItem.price} \$",
                        style: AppStyles.black15BoldStyle,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (cartItem.cartItemId != null) {
                                context.read<CartCubit>().incrementQuantity(cartItem.cartItemId!);
                              }
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 16.sp,
                              ),
                            ),
                          ),
                          WidthSpace(8),
                          Text(
                            cartItem.quantity.toString(),
                            style: AppStyles.black15BoldStyle,
                          ),
                          WidthSpace(8),
                          InkWell(
                            onTap: () {
                              
                              if (cartItem.cartItemId != null && cartItem.quantity! > 1) {
                                context.read<CartCubit>().decrementQuantity(cartItem.cartItemId!);
                              }
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
