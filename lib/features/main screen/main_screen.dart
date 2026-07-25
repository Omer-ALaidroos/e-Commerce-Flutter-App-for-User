
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/features/Cart/cubit/cart_cubit.dart';
import 'package:e_commerce_app/features/Cart/my_cart_screen.dart';
import 'package:e_commerce_app/features/Favorite%20screen/favorites_screen.dart';
import 'package:e_commerce_app/features/account/account_screen.dart';
import 'package:e_commerce_app/features/home/cubit/categories_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/favorite_cubit.dart';
import 'package:e_commerce_app/features/home/cubit/product_cubit.dart';
import 'package:e_commerce_app/features/home/home_screen.dart';
import 'package:e_commerce_app/features/auth/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  List<Widget> screens = [
     MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProductCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CategoriesCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<FavoriteCubit>(),
        ),
      ],
      child: HomeScreen(),
    ),
    MyCartScreen(),
    const FavoritesScreen(),
  
    BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const AccountScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CartCubit>()..fetchCarts(),
      child: SafeArea(
        child: Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: SalomonBottomBar(
                  currentIndex: currentIndex,
                  onTap: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.greyColor,
                  curve: Curves.easeInOut,
                  items: [
                    SalomonBottomBarItem(
                      icon: Icon(Icons.home, size: 26.sp),
                      title: const Text('Home'),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(Icons.shopping_cart, size: 26.sp),
                      title: const Text('Cart'),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(Icons.favorite, size: 26.sp),
                      title: const Text('Favorites'),
                      selectedColor: AppColors.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(Icons.person_3_outlined, size: 26.sp),
                      title: const Text('Account'),
                      selectedColor: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
