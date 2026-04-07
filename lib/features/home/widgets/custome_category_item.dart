import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeCategoryItem extends StatelessWidget {
  const CustomeCategoryItem({super.key, required this.categoryName, required this.onTap});
  final String categoryName;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical:   6.h),
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE9EEFA), width: 1),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Text(
          categoryName,
          style: AppStyles.black15BoldStyle,
        ),
      ),
    );
  }
}