
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/my_cart_screen.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/product_details_screen.dart';
import 'package:e_commerce_app/features/address/address_screen.dart';
import 'package:e_commerce_app/features/my_Details/details_screen.dart';
import 'package:e_commerce_app/features/my_Details/cubit/user_details_cubit.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:e_commerce_app/features/my_Details/cubit/edit_cubit.dart';
import 'package:e_commerce_app/features/auth/cubit/register/register_cubit.dart';
import 'package:e_commerce_app/features/auth/cubit/auth/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/login_screen.dart';
import 'package:e_commerce_app/features/auth/register_screen.dart';
import 'package:e_commerce_app/features/order/cubit/order_cubit.dart';
import 'package:e_commerce_app/features/order/cubit/order_details_cubit.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';
import 'package:e_commerce_app/features/order/models/order_model.dart';
import 'package:e_commerce_app/features/order/my_order_screen.dart';
import 'package:e_commerce_app/features/order/order_detailes_screen.dart';
import 'package:e_commerce_app/features/main%20screen/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouterGenerationConfig {
  static GoRouter goRouter =
      GoRouter(initialLocation: AppRoutes.loginScreen, routes: [
      GoRoute(
      name: AppRoutes.loginScreen,
      path: AppRoutes.loginScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(sl()),
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.registerScreen,
      path: AppRoutes.registerScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => RegisterCubit(sl()),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.mainScreen,
      path: AppRoutes.mainScreen,
      builder: (context, state) =>  BlocProvider(
        create: (context) => CartCubit(sl()),
        child: const MainScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.productDetailsScreen,
      path: AppRoutes.productDetailsScreen,
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return BlocProvider(
        create: (context) => CartCubit(sl()),
        child: ProductDetailsScreen(product: product),
        ) ;
      } 
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
      GoRoute(
        name: AppRoutes.orderDetailesScreen,
        path: AppRoutes.orderDetailesScreen,
        builder: (context, state) {
          final orderID = state.extra as int;
          return BlocProvider(
            create: (context) => OrderDetailsCubit(sl())..fetchOrderDetails(orderID),
            child: OrderDetailesScreen(orderId: orderID),
          );
        },
      ),
        GoRoute(
          name: AppRoutes.myOrderScreen,
          path: AppRoutes.myOrderScreen,
          builder: (context, state) => BlocProvider(
            create: (context) => OrderCubit(sl()),
            child:  MyOrderScreen(),
          ),
        ),

      GoRoute(
        name: AppRoutes.myDetailsScreen,
        path: AppRoutes.myDetailsScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => UserDetailsCubit(sl())),
              BlocProvider(create: (context) => EditCubit(sl())),
            ],
            child: const DetailsScreen(),
          );
        },
      ),
  ]);
}
