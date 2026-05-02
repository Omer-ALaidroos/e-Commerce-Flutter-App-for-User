import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemWidget extends StatelessWidget {
  final String title;
  final int id;
  final String price;
  final String image;
  final Function()? onTap;
  const ProductItemWidget(
      {super.key,
      required this.title,
      required this.price,
      this.onTap,
      required this.image, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Hero(
                  tag: id,
                  child: CachedNetworkImage(
                    width: 150.w,
                    height: 190.h,
                    fit: BoxFit.cover,
                    imageUrl:"${ApiEndpoints.baseUrl}/$image",
                  ),
                )),
            const HeightSpace(8),
            Text(title, maxLines: 1, style: AppStyles.black15BoldStyle),
            const HeightSpace(8),
            Text(price,
                style: AppStyles.grey12MediumStyle
                    .copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
