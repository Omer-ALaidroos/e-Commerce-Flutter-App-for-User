
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

import '../home/widgets/title_price_widget.dart' show TotalPriceWidget;

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
        
      ),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            AnimatedSnackBar.material(
              "Checkout initialized. Complete payment to confirm your order.",
              type: AnimatedSnackBarType.success,
            ).show(context);
          } else if (state is PaymentCompleted) {
            AnimatedSnackBar.material(
              "Payment completed. Your order is now being confirmed.",
              type: AnimatedSnackBarType.success,
            ).show(context);
          
            context.read<CartCubit>().clearLocalCart();
            context.read<CartCubit>().fetchCarts();
          } else if (state is PaymentCancelled) {
            AnimatedSnackBar.material(
              "Payment cancelled.",
              type: AnimatedSnackBarType.info,
            ).show(context);
          } else if (state is PaymentFailed) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.error,
            ).show(context);
          } else if (state is PaymentTimeout) {
            AnimatedSnackBar.material(
              "Payment confirmation timed out. Please check your order status.",
              type: AnimatedSnackBarType.warning,
            ).show(context);
          } else if (state is ErrorCheckout) {
            AnimatedSnackBar.material(
              state.message,
              type: AnimatedSnackBarType.error,
            ).show(context);
            context.read<CartCubit>().fetchCarts();
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
                child: Image.asset( 
                  'assets/icons/cart.png',
                  width: 200.w,
                  height: 200.h,
                ),
              );
            }

           
            double totalPrice = state.cartItems.fold(
                0, (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 1)));

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeightSpace(20),
                          ...state.cartItems.map((cartItem) {
                            return CartItemWidget(cartItem: cartItem);
                          }), // Ensure map returns a List
                          const HeightSpace(20),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
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
                      state is CheckoutLoading ||
                              state is InitializingPaymentSheet ||
                              state is PresentingPaymentSheet ||
                              state is WaitingForPaymentConfirmation
                          ? const Center(child: CircularProgressIndicator())
                          : PrimayButtonWidget(
                              buttonText: "Checkout",
                              trailingIcon: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              onPress: () {
                                // Creating order with placeholder values for now
                                context.read<CartCubit>().checkout(
                                      
                                      payment: 1,
                                    );
                              },
                            ),
                    ],
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
            child:Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 100.sp,
              )
          );
        },
        )
        
      ),
       
    );
    
  }
}