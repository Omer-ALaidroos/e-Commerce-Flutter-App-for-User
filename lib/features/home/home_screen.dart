import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/home/cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/categories_state.dart';
import 'package:e_commerce_app/features/home/cubit/product_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/product_state.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:e_commerce_app/features/home/widgets/category_item_widget.dart';
import 'package:e_commerce_app/features/home/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCat = "All";
  @override
  void initState() {
    context.read<ProductCubit>().fetchProducts();
    context.read<CategoriesCubit>().fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeightSpace(28),
          SizedBox(
            width: 335.w,
            child: Text(
              "Discover",
              style: AppStyles.primaryHeadLinesStyle,
            ),
          ),
          const HeightSpace(16),
          Row(
            children: [
              CustomTextField(
                width: 270.w,
                hintText: "Search For Clothes",
              ),
              const WidthSpace(8),
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const HeightSpace(16),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.categories.map((cat) {
                      return CategoryItemWidget(
                        categoryName: cat.name,
                        isSelected: selectedCat == cat.name ? true : false,
                        onPress: () {
                          setState(() {
                            selectedCat = cat.name;

                            if (selectedCat == "all") {
                              context.read<ProductCubit>().fetchProducts();
                            } else {
                              context
                                  .read<ProductCubit>()
                                  .fetchProductCategories(cat.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
          const HeightSpace(16),
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.sp,
                        crossAxisSpacing: 16.sp,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                          width: 150.w,
                          height: 120.h,
                        );
                      },
                    ),
                  ),
                );
              }
              if (state is ProductLoaded) {
                List<ProductModel> products = state.products;

                if (products.isEmpty) {
                  return const Center(
                    child: Text("No products found"),
                  );
                }
                return Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      selectedCat = "All";
                      setState(() {});
                      context.read<ProductCubit>().fetchProducts();
                    },
                    child: AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.sp,
                          crossAxisSpacing: 16.sp,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 200.0,
                              child: FadeInAnimation(
                                child: ProductItemWidget(
                                      id: products[index].id ?? 0,
                                  image: products[index].imageUrl ?? "",
                                  title: products[index].name ?? "",
                                  price: products[index].price.toString(),
                                  onTap: () {
                                    GoRouter.of(context).pushNamed(
                                        AppRoutes.productDetailsScreen,
                                        extra: products[index]);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }

              return Text("there is an error");
            },
          )
        ],
      ),
    );
  }
}
