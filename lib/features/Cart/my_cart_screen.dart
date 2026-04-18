import 'dart:math';

import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_state.dart';
import 'package:e_commerce_app/features/Cart/widget/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/widgets/title_price_widget.dart' show TitlePriceWidget, TotalPriceWidget;

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  bool _hasFetchedCarts = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedCarts) {
      _hasFetchedCarts = true;
      context.read<CartCubit>().fecthCarts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading:IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is LoadingCarts || state is InitialCartState) {
            return LoadingWidget(
              height: MediaQuery.of(context).size.height * 0.65,
            );
          }

          if (state is SuccessGettingCarts) {
            
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(20),
                    ...state.cart.products!.map((p) {
                      return CartItemWidget(product: p);
                    }).toList(),
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
            );
          }

          if (state is ErrorGettingCarts) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppStyles.black16w500Style,
                ),
              ),
            );
          }

          return Center(
            child: Text(
              'Your cart is empty.',
              style: AppStyles.black16w500Style,
            ),
          );
        },
      ),
    );
  }
}