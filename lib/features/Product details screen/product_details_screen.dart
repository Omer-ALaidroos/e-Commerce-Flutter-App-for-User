import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/cubit/review_cubit.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/cubit/review_state.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/model/product_details_model.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/widget/review_widgets.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/cubit/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'cubit/product_details_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  bool _showReviewForm = false;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    // Assuming a user must be logged in to see review permissions.
    // You can add your auth check logic here.
    context.read<ReviewCubit>().checkCanReview(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          "Details",
          style: AppStyles.primaryHeadLinesStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.blackColor, size: 24.sp),
      ),
      body: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSubmitSuccess) {
            setState(() {
              _showReviewForm = false;
            });
            showAnimatedSnackDialog(context,
                message: "Review submitted successfully!",
                type: AnimatedSnackBarType.success);
            // Refresh product details and review permissions
            context
                .read<ProductDetailsCubit>()
                .fetchProductDetails(widget.productId);
            context.read<ReviewCubit>().checkCanReview(widget.productId);
          } else if (state is ReviewSubmitError) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.error);
          }
        },
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductDetailsError) {
              return Center(child: Text(state.message));
            }
            if (state is ProductDetailsLoaded) {
              final product = state.productDetails;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.images.isNotEmpty) ...[
                            Hero(
                              tag: widget.productId,
                              child: CarouselSlider.builder(
                                itemCount: product.images.length,
                                carouselController: _carouselController,
                                itemBuilder: (context, index, realIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${ApiEndpoints.baseUrl}/${product.images[index].imageUrl}",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    height: 200.h,
                                    autoPlay: product.images.length > 1
                                        ? true
                                        : false,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentImageIndex = index;
                                      });
                                    }),
                              ),
                            ),
                            if (product.images.length > 1) ...[
                              const HeightSpace(16),
                              Center(
                                child: DotsIndicator(
                                  dotsCount: product.images.length,
                                  position: _currentImageIndex.toDouble(),
                                  decorator: DotsDecorator(
                                    color:
                                        AppColors.greyColor, // Inactive color
                                    activeColor: AppColors.primaryColor,
                                    size: const Size.square(9.0),
                                    activeSize: const Size(18.0, 9.0),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                ),
                              ),
                            ],
                            const HeightSpace(16),
                            if (product.images.length > 1)
                              SizedBox(
                                height: 80.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: product.images.length,
                                  itemBuilder: (context, index) {
                                    final image = product.images[index];
                                    return GestureDetector(
                                      onTap: () {
                                        _carouselController
                                            .animateToPage(index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: _currentImageIndex == index
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: CachedNetworkImage(
                                            width: 80.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${ApiEndpoints.baseUrl}/${image.imageUrl}",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ] else
                            Hero(
                              tag: widget.productId,
                              child: Image.asset(
                                "assets/images/placeholder.png",
                                width: double.infinity,
                                height: 300.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const HeightSpace(24),
                          Text(
                            product.name,
                            style: AppStyles.black18BoldStyle
                                .copyWith(fontSize: 24.sp),
                          ),
                          const HeightSpace(10),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.blackColor,
                                size: 20.sp,
                              ),
                              const WidthSpace(4),
                              Text(
                                '${product.quantity} in stock',
                                style: AppStyles.black15BoldStyle,
                              ),
                            ],
                          ),
                          const HeightSpace(20),
                          Text(
                            product.description,
                            style: AppStyles.grey12MediumStyle,
                          ),
                          const HeightSpace(24),
                          const Divider(),
                          const HeightSpace(16),
                          _buildCustomerReviewsSection(product),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(product),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCustomerReviewsSection(ProductDetailsModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: AppStyles.black18BoldStyle,
        ),
        const HeightSpace(16),
        ProductRatingSummary(
          averageRating: product.averageRating,
          reviewsCount: product.reviewsCount,
        ),
        const HeightSpace(16),
        _buildReviewForm(),
        const HeightSpace(16),
        if (product.reviews.isEmpty)
          const EmptyReviewsWidget()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.reviews.length,
            itemBuilder: (context, index) {
              return ReviewCard(review: product.reviews[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        if (state is CanReviewLoaded) {
          final model = state.canReviewModel;
          if (model.alreadyReviewed) {
            return const ReviewPermissionMessageCard(
              message: 'You have already reviewed this product.',
              icon: Icons.check_circle_outline,
            );
          } else if (model.canReview || model.hasPurchased) {
            return Column(
              children: [
              
                if (!_showReviewForm) ...[
                  const HeightSpace(12),
                  WriteReviewCard(
                    productId: widget.productId,
                    isSubmitting:
                        context.watch<ReviewCubit>().state is ReviewSubmitting,
                    onSubmit: ({required int rating, String? reviewText}) {
                      context.read<ReviewCubit>().submitReview(
                        productId: widget.productId,
                        rating: rating,
                        reviewText: reviewText,
                      );
                    },
                  ),
                ],
              ],
            );
          } else {
            return const ReviewPermissionMessageCard(
              message: 'Only customers who purchased this product can leave a review.',
              icon: Icons.info_outline,
            );
          }
        }
        if (state is CanReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Handle error or initial state if needed
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomBar(ProductDetailsModel product) {
    return Container(
      color: AppColors.whiteColor,
      padding:
          EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          const HeightSpace(5),
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
                  const HeightSpace(4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: AppStyles.black16w500Style.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const WidthSpace(16),
              Expanded(
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is SuccessAddingToCarts) {
                      showAnimatedSnackDialog(context,
                          message:
                              "Product Added Successfully To Our Cart",
                          type: AnimatedSnackBarType.success);
                    }
                  },
                  builder: (context, state) {
                    return PrimayButtonWidget(
                      isLoading: state is AddingToCart,
                      buttonText: "Add To Cart",
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      onPress: () {
                        context.read<CartCubit>().addingToCart(
                            productId: product.id, quantity: 1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}