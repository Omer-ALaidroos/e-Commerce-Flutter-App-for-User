import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItemWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onPress;
  final bool isSelected;
  const CategoryItemWidget({
    super.key,
    required this.categoryName,
    this.onPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () {},
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 12.w, bottom: 8.h, top: 4.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.3)
                    : Colors.black.withOpacity(0.07),
                blurRadius: isSelected ? 8 : 5,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                _iconFromCategoryTitle(categoryName),
                size: 18.sp,
                color:
                    isSelected ? AppColors.whiteColor : AppColors.primaryColor,
              ),
              const WidthSpace(8),
              Text(
                categoryName,
                style: AppStyles.black16w500Style.copyWith(
                  fontSize: 14.sp,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


_iconFromCategoryTitle(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'electronics':
      return Icons.electrical_services;
    case 'clothes':
      return Icons.checkroom;
    case 'shoes':
      return Icons.directions_run;
    case 'toys':
      return Icons.toys;
    case 'sports':
      return Icons.sports_soccer;
    default:
      return Icons.category; // Default icon for unknown categories
  }
}
