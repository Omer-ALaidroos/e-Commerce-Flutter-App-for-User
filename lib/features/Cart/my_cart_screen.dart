
import 'package:animated_snack_bar/animated_snack_bar.dart';
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
    context.read<CartCubit>().fetchCarts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: BlocBuilder<CartCubit, CartState>(
  builder: (context, state) {
    return IconButton(
      onPressed: state is Checkout ? null : () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  },
),
      ),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is SuccessCheckout) {
            AnimatedSnackBar.material(
              "Order Created Successfully!",
              type: AnimatedSnackBarType.success,
            ).show(context);
           
          } else if (state is ErrorCheckout) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.error,
            ).show(context);
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
          if (state is LoadingCarts || state is InitialCartState) {
            return LoadingWidget(
              height: MediaQuery.of(context).size.height * 0.65,
            );
          }

          if (state is SuccessGettingCarts) {
            
            if (state.cartItems.isEmpty) {
              return Center(
                child: Text(
                  'Your cart is empty.',
                  style: AppStyles.black16w500Style,
                ),
              );
            }

            // Calculate total price dynamically
            double totalPrice = state.cartItems.fold(
                0, (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 1)));

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 180.h), // Add padding to prevent content from being hidden by the bottom bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeightSpace(20),
                        ...state.cartItems.map((cartItem) {
                          return CartItemWidget(cartItem: cartItem);
                        }).toList(), // Ensure map returns a List
                        const HeightSpace(20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white, // Background color for the bottom section
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        const HeightSpace(10),
                        TotalPriceWidget(
                            title: "Total", 
                            price: "\$${totalPrice.toStringAsFixed(2)}"),
                        const HeightSpace(20),
                        state is Checkout 
                        ? const Center(child: CircularProgressIndicator())
                        : PrimayButtonWidget(
                            buttonText: "Confirm Order",
                            trailingIcon: Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            onPress: () {
                              // Creating order with placeholder values for now
                              context.read<CartCubit>().checkout(
                                    shippingAddressId: 2, 
                                    payment: 1, 
                                  );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
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
        )
        
      ),
       
    );
    
  }
}