import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountItemWidget extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final VoidCallback? onTap;
  const AccountItemWidget(
      {super.key, this.title, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w, vertical: 16.h),
        child: Row(
          children: [
            Row(
              children: [
                iconPath == null
                    ? const SizedBox.shrink()
                    : Image.asset(
                        iconPath!,
                        width: 25.sp,
                        height: 25.sp,
                      ),
                const WidthSpace(8),
                Text(
                  title ?? "",
                  style:
                      AppStyles.subtitlesStyles.copyWith(color: Colors.black),
                )
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
