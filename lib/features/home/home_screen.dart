import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/home/cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/categories_state.dart';
import 'package:e_commerce_app/features/home/cubit/favorite_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/favorite_state.dart';
import 'package:e_commerce_app/features/home/cubit/product_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/product_state.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:e_commerce_app/features/home/widgets/category_item_widget%20.dart';
import 'package:e_commerce_app/features/home/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _searchController = TextEditingController();

  void _triggerSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      context.read<ProductCubit>().fetchProducts();
      return;
    }

    context.read<ProductCubit>().searchProducts(query);
  }

  @override
  void initState() {
    context.read<ProductCubit>().fetchProducts();
    context.read<CategoriesCubit>().fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoriteCubit>(),
      child: BlocListener<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteSuccess) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.success,
            ).show(context); 
            context.read<ProductCubit>().fetchProducts();
          }
          if (state is FavoriteError) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.error,
            ).show(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeightSpace(28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find Your Style",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const HeightSpace(4),
                      Text(
                        "Discover the latest trends.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                     const CircleAvatar(child: Icon(Icons.notifications_none)),
                     const WidthSpace(8),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRoutes.myCartScreen);
                        },
                        child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            int itemCount = 0;
                            if (state is SuccessGettingCarts) {
                              itemCount = state.cartItems.length;
                            }
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const CircleAvatar(
                                    child: Icon(Icons.shopping_cart_outlined)),
                                if (itemCount > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 18.r,
                                        minHeight: 18.r,
                                      ),
                                      child: Center(
                                        child: Text(
                                          itemCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],)
                ]
              ),
              const HeightSpace(16),
              TextField(
                controller: _searchController,
                onSubmitted: (_) => _triggerSearch(),
                decoration: InputDecoration(
                  hintText: "Search for products...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 26.sp,
                    ),
                    onPressed: _triggerSearch,
                    splashRadius: 24.r,
                  ),
                ),
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
                              setState(() => selectedCat = cat.name);
                              if (cat.name.toLowerCase() == "all") {
                                context.read<ProductCubit>().fetchProducts();
                              } else {
                                context
                                    .read<ProductCubit>()
                                    .fetchProductCategories(cat.id);
                              }
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
                          setState(() {
                            selectedCat = "All";
                            _searchController.clear();
                          });
                          context.read<ProductCubit>().fetchProducts();
                        },
                        child: AnimationLimiter(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      image:
                                          products[index].PrimaryImageUrl ?? "",
                                      title: products[index].name ?? "",
                                      price: products[index].price.toString(),
                                      isFavorite:
                                          products[index].isFavorite ?? false,
                                      averageRating:
                                          products[index].AverageRating ?? 0.0,
                                      onTap: () {
                                        GoRouter.of(context).pushNamed(
                                            AppRoutes.productDetailsScreen,
                                            extra: products[index].id);
                                      },
                                      onFavoriteToggle: () { 
                                        context
                                            .read<FavoriteCubit>()
                                            .toggleFavorite(
                                                products[index].id!,
                                                products[index].isFavorite ??
                                                    false);
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

                  if (state is ProductError) {
                    return Expanded(
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  }

                  return const Text("there is an error");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
