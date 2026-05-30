import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final UserDetails userDetails;
  const Header({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          const HeightSpace(20),
          CircleAvatar(
            radius: 54.w,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: CircleAvatar(
              radius: 50.w,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                userDetails.fullName.isNotEmpty ? userDetails.fullName[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const HeightSpace(16),
          Text(
            userDetails.fullName,
            style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 20.sp),
          ),
          const HeightSpace(4),
          Text(
            "Verified Account",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}