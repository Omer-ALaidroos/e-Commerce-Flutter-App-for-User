import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndNavigate();
  }

  Future<void> _checkOnboardingAndNavigate() async {
    // Small delay for splash visibility
    await Future.delayed(const Duration(seconds: 10));

    final storageHelper = sl<StorageHelper>();
    final onboardingCompleted = await storageHelper.isOnboardingCompleted();

    if (!mounted) return;

    if (onboardingCompleted) {
      GoRouter.of(context).go(AppRoutes.loginScreen);
    } else {
      GoRouter.of(context).go(AppRoutes.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo Icon
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20.r,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset( 
                'assets/icons/logo.png',
                fit: BoxFit.contain,
              )
            ),
            SizedBox(height: 24.h),
            // App Name
            Text(
              'Tasawug App',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Discover Your Style',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 48.h),
            // Loading indicator
            SizedBox(
              width: 28.r,
              height: 28.r,
              child: CircularProgressIndicator(
                strokeWidth: 3.r,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}