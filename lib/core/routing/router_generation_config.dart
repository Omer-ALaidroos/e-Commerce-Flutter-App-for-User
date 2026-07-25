
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/my_cart_screen.dart';
import 'package:e_commerce_app/features/FAQ/faq_screen.dart';
import 'package:e_commerce_app/features/Favorite%20screen/favorites_screen.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/cubit/review_cubit.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/product_details_screen.dart';
import 'package:e_commerce_app/features/address/address_cubit.dart';
import 'package:e_commerce_app/features/address/address_screen.dart';
import 'package:e_commerce_app/features/forgetPassword/forget_password_new_password_screen.dart';
import 'package:e_commerce_app/features/helpCenter/help_center_screen.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/cubit/product_details_cubit.dart';
import 'package:e_commerce_app/features/my_Details/details_screen.dart';
import 'package:e_commerce_app/features/my_Details/cubit/user_details_cubit.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:e_commerce_app/features/my_Details/cubit/edit_cubit.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_cubit.dart';
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
import 'package:e_commerce_app/features/forgetPassword/forget_password_email_screen.dart';
import 'package:e_commerce_app/features/forgetPassword/forget_password_otp_screen.dart';
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
        final productId = state.extra as int;
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider(
                create: (context) =>
                    sl<ProductDetailsCubit>()..fetchProductDetails(productId)),
            BlocProvider(
                create: (context) => sl<ReviewCubit>()..checkCanReview(productId)),
          ],
          child: ProductDetailsScreen(productId: productId),
        );
      } 
    ),
    GoRoute(
      name: AppRoutes.addressScreen,
      path: AppRoutes.addressScreen,
      builder: (context, state) => BlocProvider(
        create: (context) => AddressCubit(sl()),
        child: const AddressScreen(),
      ),
    ),
     
      GoRoute(
        name: AppRoutes.favoritesScreen,
        path: AppRoutes.favoritesScreen,
        builder: (context, state) => const FavoritesScreen(),
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

        GoRoute(
          name: AppRoutes.forgetPasswordEmailRoute,
          path: AppRoutes.forgetPasswordEmailRoute,
          builder: (context, state) => BlocProvider(
            create: (context) => ForgetPasswordCubit(sl()),
            child: const ForgetPasswordEmailScreen(),
          ),
        ),
        GoRoute(
          name: AppRoutes.forgetPasswordOtpRoute,
          path: AppRoutes.forgetPasswordOtpRoute,
          builder: (context, state) {
            final email = state.extra as String?;
            return BlocProvider(
              create: (context) => ForgetPasswordCubit(sl()),
              child: ForgetPasswordOTPScreen(email: email),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.forgetPasswordNewPasswordRoute,   
          path: AppRoutes.forgetPasswordNewPasswordRoute,
          builder: (context, state) => BlocProvider(
            create: (context) => ForgetPasswordCubit(sl()),
            child: const ForgetPasswordNewPasswordScreen(),
          ),
        ), 
          GoRoute(
            name: AppRoutes.faqScreen,
            path: AppRoutes.faqScreen,
            builder: (context, state) =>const FAQScreen(),
            ),
          GoRoute(
            name: AppRoutes.helpCenterScreen,
            path: AppRoutes.helpCenterScreen,
            builder: (context, state) => const HelpCenterScreen(),
          ),
           GoRoute(
          name: AppRoutes.myCartScreen,   
          path: AppRoutes.myCartScreen,
          builder: (context, state) => BlocProvider(
            create: (context) => CartCubit(sl()),
            child: const MyCartScreen(),
          ),
                        ),
        

  ]);
}
