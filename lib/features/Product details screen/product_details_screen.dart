import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, this.title, this.price, this.imageUrl, this.description, this.rating, this.reviewsCount});
  final String? title;
  final String? price;
  final String? imageUrl;
  final String? description;
  final String? rating;
  final String? reviewsCount;

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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
             
            children: [
             
         
              Image.asset(
                AppAssets.tShirt,
                 height: 365.h,
                  width: 341.w,),
              HeightSpace(  50.h),
              Text(title?? "T-Shirt",
                style: AppStyles.black18BoldStyle,
              ),
              HeightSpace(  10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon( Icons.star,
                  color: Colors.amber,
                  size: 20.sp,
                  ),
                  Text(rating?? "4.5  ",
                    style: AppStyles.black15BoldStyle,
                  ),
                  Text("(${reviewsCount?? "120"}) Reviews",
                    style: AppStyles.grey12MediumStyle,
                  ), 
                ]                   
              ),
              HeightSpace(  20.h),
        
              Text(description?? "T shirt for men, made of high quality cotton, comfortable to wear and stylish design.",
                style: AppStyles.grey12MediumStyle,
                textAlign: TextAlign.center,
              ),
               HeightSpace(  40.h), 
             
               
              
            ],
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
                  HeightSpace(10.h),
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
                            "1120 \$",
                            style: AppStyles.black16w500Style.copyWith(
                                fontSize: 24.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const WidthSpace(16),
                      PrimayButtonWidget(
                        width: MediaQuery.of(context).size.width * 0.5,
                        buttonText: "Add To Cart",
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        onPress: () {},
                      ),
                    ],
                  ),
                  const HeightSpace(8.0),
                ],
              ),
            ),
          )],
      ),
    );
  }
}