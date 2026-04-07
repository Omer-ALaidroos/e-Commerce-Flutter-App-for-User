import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressItemWidget extends StatelessWidget {
  final bool isDefault ;
  final String address;
  final String addressDetails;
  const AddressItemWidget(
      {super.key, required this.address, required this.addressDetails,this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.place_outlined,
              color: Colors.grey,
              size: 32.sp,
            ),
            const WidthSpace(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address, style: AppStyles.black15BoldStyle),
                    const WidthSpace(8),
                    if(isDefault)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text("Default", style: AppStyles.black18BoldStyle.copyWith(fontSize: 10.sp, color: Colors.white)),
                    )
                  ],
                ),
                const HeightSpace(8),
                Text(addressDetails, style: AppStyles.grey12MediumStyle.copyWith(fontSize: 12.sp)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
