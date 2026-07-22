import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text("Help Center"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Us",
                style: AppStyles.black15BoldStyle.copyWith(fontSize: 18.sp),
              ),
              const HeightSpace(20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHelpItem(
                      icon: Icons.headset_mic_outlined,
                      title: "Customer Service",
                      subtitle: "Available 24/7",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildHelpItem(
                      icon: Icons.chat_outlined,
                      title: "WhatsApp",
                      subtitle: "+1 234 567 890",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildHelpItem(
                      icon: Icons.language_outlined,
                      title: "Website",
                      subtitle: "www.ecommerce-app.com",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildHelpItem(
                      icon: Icons.facebook_outlined,
                      title: "Facebook",
                      subtitle: "@ecommerce_official",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildHelpItem(
                      icon: Icons.camera_alt_outlined,
                      title: "Instagram",
                      subtitle: "@ecommerce_store",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const HeightSpace(30),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryColor, size: 24.sp),
                    const WidthSpace(12),
                    Expanded(
                      child: Text(
                        "Our support team usually responds within 2 hours during business days.",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 22.sp),
      ),
      title: Text(title, style: AppStyles.black15BoldStyle.copyWith(fontSize: 14.sp)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14.sp),
      onTap: onTap,
    );
  }
}