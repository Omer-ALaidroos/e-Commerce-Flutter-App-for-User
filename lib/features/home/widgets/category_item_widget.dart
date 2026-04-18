
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItemWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onPress;
  final bool isSelected;
  const CategoryItemWidget(
      {super.key,
      required this.categoryName,
      this.onPress,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 8.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            border:
                isSelected ? null : Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(categoryName,
              style: AppStyles.black15BoldStyle
                  .copyWith(color: isSelected ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
