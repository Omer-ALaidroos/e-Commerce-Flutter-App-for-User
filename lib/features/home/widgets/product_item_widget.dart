import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemWidget extends StatelessWidget {
  final int id;
  final String image;
  final String title;
  final String price;
  final bool isFavorite;
  final double averageRating;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ProductItemWidget({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.onTap,
    required this.averageRating,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: "${ApiEndpoints.baseUrl}/$image",
                  width: 164.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: CircleAvatar(
                    radius: 15.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const HeightSpace(8),
          SizedBox(
            width: 164.w,
            child: Text(
              title,
              style: AppStyles.black15BoldStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const HeightSpace(4),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16.sp,
              ),
              const WidthSpace(4),
              Text(averageRating.toStringAsFixed(1),
                  style: AppStyles.black15BoldStyle.copyWith(fontSize: 14.sp)),
            ],
          ),
          Text(
            "\$ $price",
            style: AppStyles.black15BoldStyle,
          ),
        ],
      ),
    );
  }
}