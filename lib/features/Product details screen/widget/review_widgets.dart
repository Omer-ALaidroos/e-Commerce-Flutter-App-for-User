import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/model/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProductRatingSummary extends StatelessWidget {
  final double averageRating;
  final int reviewsCount;

  const ProductRatingSummary({
    super.key,
    required this.averageRating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 48.sp),
        const WidthSpace(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: AppStyles.black16w500Style.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              reviewsCount == 0
                  ? 'No reviews yet'
                  : 'Based on $reviewsCount reviews',
              style: AppStyles.black16w500Style.copyWith(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ProductReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: review.user.profilePicture != null
                    ? NetworkImage(review.user.profilePicture!)
                    : null,
                child: review.user.profilePicture == null
                    ? Icon(Icons.person, size: 20.r)
                    : null,
              ),
              const WidthSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.user.fullName,
                        style: AppStyles.black16w500Style),
                    Text(
                      DateFormat.yMMMd().format(review.createdAt),
                      style: AppStyles.black16w500Style.copyWith(
                          fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              RatingStars(rating: review.rating),
            ],
          ),
          if (review.review.isNotEmpty) ...[
            const HeightSpace(8),
            Text(
              review.review,
              style: AppStyles.black16w500Style
                  .copyWith(fontSize: 14.sp, fontWeight: FontWeight.normal),
            ),
          ],
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final int rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16.sp,
        );
      }),
    );
  }
}

class EmptyReviewsWidget extends StatelessWidget {
  const EmptyReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.star_outline, size: 48.sp, color: Colors.grey),
            const HeightSpace(16),
            Text('No reviews yet', style: AppStyles.black16w500Style),
            const HeightSpace(4),
            Text(
              'Be the first customer to rate this product.',
              style: AppStyles.black16w500Style.copyWith(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class WriteReviewCard extends StatefulWidget {
  final int productId;
  final bool isSubmitting;
  final Function({required int rating, String? reviewText}) onSubmit;

  const WriteReviewCard({
    super.key,
    required this.productId,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<WriteReviewCard> createState() => _WriteReviewCardState();
}

class _WriteReviewCardState extends State<WriteReviewCard> {
  int _rating = 0;
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      color: Colors.grey.shade300,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate this product', style: AppStyles.black16w500Style),
            const HeightSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32.sp,
                  ),
                );
              }),
            ),
            const HeightSpace(16),
            TextField(
              controller: _reviewController,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: 'Tell us what you think (optional)',
                
              ),
            ),
            const HeightSpace(16),
            PrimayButtonWidget(
              buttonText: 'Submit Review',
              onPress: (_rating == 0 || widget.isSubmitting)
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      widget.onSubmit(
                        rating: _rating,
                        reviewText: _reviewController.text,
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewPermissionMessageCard extends StatelessWidget {
  final String message;
  final IconData icon;

  const ReviewPermissionMessageCard({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey.shade700),
            const WidthSpace(12),
            Expanded(
              child: Text(
                message,
                style: AppStyles.black16w500Style.copyWith(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}