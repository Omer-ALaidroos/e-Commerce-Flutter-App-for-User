import 'package:e_commerce_app/core/styling/app_assets.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Cart/widget/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/widgets/title_price_widget.dart' show TitlePriceWidget, TotalPriceWidget;

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart",
          style: AppStyles.primaryHeadLinesStyle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
            size: 24.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeightSpace(20),
              CartItemWidget(),
              CartItemWidget(),
              CartItemWidget(),
              HeightSpace(20),
              TitlePriceWidget(title: "Sub Total", price: "1190 \$"),
              TitlePriceWidget(title: "VAT (16 %)", price: "1190 \$"),
              TitlePriceWidget(title: "Shipping Fees", price: "1190 \$"),
              const HeightSpace(20),
              Divider(),
              const HeightSpace(20),
              TotalPriceWidget(title: "Total", price: "1190 \$"),
              const HeightSpace(20),
              PrimayButtonWidget(
                buttonText: "Go To Checkout",
                trailingIcon: Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 16.sp,
                ),
                onPress: () {},
              ),
              const HeightSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}