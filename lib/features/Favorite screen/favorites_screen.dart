import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Favorite%20screen/cubit/my_favorites_cubit.dart';
import 'package:e_commerce_app/features/Favorite%20screen/cubit/my_favorites_state.dart';
import 'package:e_commerce_app/features/home/cubit/favorite_cubit.dart';
import 'package:e_commerce_app/features/home/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MyFavoritesCubit>()..fetchFavoriteProducts(),
        ),
        BlocProvider(
          create: (context) => sl<FavoriteCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites', style: AppStyles.primaryHeadLinesStyle),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w, bottom: 16.h),
          child: BlocBuilder<MyFavoritesCubit, MyFavoritesState>(
            builder: (context, state) {
              if (state is MyFavoritesLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.sp,
                      crossAxisSpacing: 16.sp,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => Container(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (state is MyFavoritesLoaded) {
                if (state.products.isEmpty) {
                  return const Center(child: Text('No favorite products found.'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MyFavoritesCubit>().fetchFavoriteProducts();
                  },
                  color: AppColors.primaryColor,
                  child: AnimationLimiter(
                    child: GridView.builder(
                      itemCount: state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.sp,
                        crossAxisSpacing: 16.sp,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: ProductItemWidget(
                                id: product.id ?? 0,
                                image: product.PrimaryImageUrl ?? '',
                                title: product.name ?? '',
                                price: product.price.toString(),
                                isFavorite: product.isFavorite ?? true,
                                averageRating: product.AverageRating ?? 0.0,
                                onTap: () => GoRouter.of(context).pushNamed(
                                    AppRoutes.productDetailsScreen,
                                    extra: product.id),
                                onFavoriteToggle: () => context
                                    .read<FavoriteCubit>()
                                    .toggleFavorite(product.id!, true)
                                    .then((_) => context
                                        .read<MyFavoritesCubit>()
                                        .fetchFavoriteProducts()),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (state is MyFavoritesError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}