import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        "question": "How can I track my order?",
        "answer": "You can track your order by navigating to the 'My Orders' section in your profile and selecting the specific order you wish to track."
      },
      {
        "question": "What is the return policy?",
        "answer": "We offer a 30-day return policy for most items. The product must be in its original packaging and unused condition."
      },
      {
        "question": "How do I change my shipping address?",
        "answer": "You can manage your addresses in the 'Address' section of your account. If an order has already been placed, please contact support immediately."
      },
      {
        "question": "What payment methods are accepted?",
        "answer": "We accept major credit/debit cards, PayPal, and Apple Pay. Some regions may also support cash on delivery."
      },
      {
        "question": "How long does shipping take?",
        "answer": "Standard shipping usually takes 3-5 business days. Express shipping options are available at checkout."
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text("FAQ"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeightSpace(20),
            Text("How can we help you?", style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 22.sp)),
            const HeightSpace(16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for questions...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppColors.primaryColor, size: 20.sp),
                ),
              ),
            ),
            const HeightSpace(24),
            Expanded(
              child: ListView.separated(
                itemCount: faqs.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const HeightSpace(12),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                      textColor: AppColors.primaryColor,
                      iconColor: AppColors.primaryColor,
                      title: Text(
                        faqs[index]["question"]!,
                        style: AppStyles.black15BoldStyle.copyWith(fontSize: 14.sp),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          child: Text(
                            faqs[index]["answer"]!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13.sp,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}