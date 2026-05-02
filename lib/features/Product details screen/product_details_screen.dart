import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key,required this.product});
   final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details",
          style: AppStyles.primaryHeadLinesStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
            size: 24.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
               
              children: [
               
                       
               CachedNetworkImage(
               imageUrl: "${ApiEndpoints.baseUrl}/${product.imageUrl}",
               width: double.infinity,
               height: 300.h,
               fit: BoxFit.cover,
               ),
                HeightSpace(  50.h),
                Text(product.name ?? "",
                  style: AppStyles.black18BoldStyle.copyWith(fontSize: 24.sp),
                ),
                HeightSpace(  10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.production_quantity_limits, // Icon for quantity
                      color: AppColors.blackColor,
                      size: 20.sp,
                    ),
                    WidthSpace(4.w), // Add spacing between the quantity icon and text
                    Text(
                      product.quantity.toString(),
                      style: AppStyles.black15BoldStyle,
                    ),
                  ],
                ),
                HeightSpace(  20.h),
                      
                Text(product.description ?? "T shirt for men, made of high quality cotton, comfortable to wear and stylish design.",
                  style: AppStyles.grey12MediumStyle,
                  textAlign: TextAlign.center,
                ),
                 HeightSpace(  200.h), 
               
                 
                
              ],
                        ),
            ),
        ),
      
    Positioned(
            bottom: 20.h,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Divider(),
                  HeightSpace(5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: AppStyles.grey12MediumStyle
                                .copyWith(fontSize: 16.sp),
                          ),
                          HeightSpace(4),
                          Text(
                            "\$${product.price}",
                            style: AppStyles.black16w500Style.copyWith(
                                fontSize: 24.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const WidthSpace(16),
                      BlocConsumer<CartCubit, CartState>(
                        listener: (context, state) {
                          if (state is SuccessAddingToCarts) {
                            showAnimatedSnackDialog(context,
                                message:
                                    "Product Added Successfully To Our Cart",
                                type: AnimatedSnackBarType.success);
                          }
                        },
                        builder: (context, state) {
                          if (state is AddingToCart) {
                            return PrimayButtonWidget(
                              width: MediaQuery.of(context).size.width * 0.5,
                              isLoading: true,
                              buttonText: "Add To Cart",
                              onPress: () {},
                            );
                          }
                          return PrimayButtonWidget(
                            width: MediaQuery.of(context).size.width * 0.5,
                            buttonText: "Add To Cart",
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            onPress: () {
                              context
                                  .read<CartCubit>()
                                  .addingToCart(product: product, quantity: 1);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                 
                ],
              ),
            ),
          )],
      ),
    );
  }
}