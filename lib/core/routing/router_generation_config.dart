
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/features/Cart/my_cart_screen.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/product_details_screen.dart';
import 'package:e_commerce_app/features/address/address_screen.dart';
import 'package:e_commerce_app/features/auth/login_screen.dart';
import 'package:e_commerce_app/features/auth/register_screen.dart';
import 'package:e_commerce_app/features/home/home_screen.dart';
import 'package:e_commerce_app/features/main%20screen/main_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RouterGenerationConfig {
  static GoRouter goRouter =
      GoRouter(initialLocation: AppRoutes.loginScreen, routes: [
    GoRoute(
      name: AppRoutes.loginScreen,
      path: AppRoutes.loginScreen,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.registerScreen,
      path: AppRoutes.registerScreen,
      builder: (context, state) =>  RegisterScreen(),
    ),
    GoRoute(
      name: AppRoutes.mainScreen,
      path: AppRoutes.mainScreen,
      builder: (context, state) =>  MainScreen(),
    ),
    GoRoute(
      name: AppRoutes.productDetailsScreen,
      path: AppRoutes.productDetailsScreen,
      builder: (context, state) => ProductDetailsScreen(),
    ),
    GoRoute(
      name: AppRoutes.addressScreen,
      path: AppRoutes.addressScreen,
      builder: (context, state) => AddressScreen(),
    ),
    GoRoute(
      name: AppRoutes.myCartScreen,
      path: AppRoutes.myCartScreen,
      builder: (context, state) => MyCartScreen(),
    ),
  ]);
}
