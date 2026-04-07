import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/home/widgets/custome_category_item.dart';
import 'package:e_commerce_app/features/home/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
         
          children: [
           
            Text("Dicover",
            style: AppStyles.primaryHeadLinesStyle,
            ),
           
            HeightSpace( 10.h),
            Row(
              children: [
                CustomTextField(
                  hintText: "Search for clothes...",
                  prefixIcon: Icon(Icons.search_rounded,),
                  width: 250.w,
                ),
                WidthSpace(10.w),
                Container(
                  width: 65.w,
                  height: 65.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r)
                  ),

                  child: IconButton(
                    onPressed: () {},
                     icon: Icon(Icons.tune,
                     color: AppColors.whiteColor,
                     size: 25.sp,)),
                )
              ],
            ),
            HeightSpace( 20.h),
            SizedBox(
                        height: 40.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            CustomeCategoryItem(categoryName:  "All",
                             onTap: () => GoRouter.of(context).pushNamed(AppRoutes.loginScreen, extra: "travel")
                            ),
                            CustomeCategoryItem(categoryName: "T-shirts",
                            onTap: () => GoRouter.of(context).pushNamed(AppRoutes.loginScreen, extra: "technology")
                            ),
                            CustomeCategoryItem(categoryName: "jeans",
                            onTap: () => GoRouter.of(context).pushNamed(AppRoutes.loginScreen, extra: "business")
                            ),
                            CustomeCategoryItem(categoryName: "shoes",
                            onTap: () => GoRouter.of(context).pushNamed(AppRoutes.loginScreen, extra: "entertainment")
                            ),
                             CustomeCategoryItem(categoryName: "jackets",
                            onTap: () => GoRouter.of(context).pushNamed(AppRoutes.loginScreen, extra: "entertainment")
                            ),
                          ],
                        ),
                      ),
                      HeightSpace( 20.h),
 Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.sp,
                crossAxisSpacing: 16.sp,
                childAspectRatio: 0.8,
              ),
              children: [
                ProductItemWidget(
                  title: "Shoes",
                  price: "1190 \$",
                  onTap: () {
                    GoRouter.of(context).pushNamed(AppRoutes.productDetailsScreen);
                  },
                ),
                ProductItemWidget(title: "Shoes", price: "1190 \$",imageUrl: AppAssets.tShirt,),
                ProductItemWidget(title: "Shoes", price: "1190 \$"),
                ProductItemWidget(title: "Shoes", price: "1190 \$",imageUrl: AppAssets.tShirt,),
                ProductItemWidget(title: "Shoes", price: "1190 \$"),
                ProductItemWidget(title: "Shoes", price: "1190 \$",imageUrl: AppAssets.tShirt,),
                ProductItemWidget(title: "Shoes", price: "1190 \$"),
                ProductItemWidget(title: "Shoes", price: "1190 \$",imageUrl: AppAssets.tShirt,),
                ProductItemWidget(title: "Shoes", price: "1190 \$"),
                ProductItemWidget(title: "Shoes", price: "1190 \$",imageUrl: AppAssets.tShirt,),
              ],
            ),
          )
                   

            
          ],
        ),
      ),
    );  
  }
}