import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingItem {
  final String imageUrl;
  final String title;
  final String description;

  OnboardingItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      imageUrl: 'assets/images/discover.svg',
      title: 'Discover the Latest\nTrends',
      description:
          'Explore a wide range of fashion products curated just for you. Stay ahead with the newest styles.',
    ),
    OnboardingItem(
     imageUrl: 'assets/images/favorite.svg',
      title: 'Save Your\nFavorites',
      description:
          'Heart the items you love and create your personal wishlist. Never miss out on your must-haves.',
    ),
    OnboardingItem(
      imageUrl: 'assets/images/checkout.svg',
      title: 'Secure & Easy\nCheckout',
      description:
          'Multiple payment options with top-notch security. Fast, seamless, and hassle-free shopping experience.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final storageHelper = sl<StorageHelper>();
    await storageHelper.setOnboardingCompleted();
    if (!mounted) return;
    GoRouter.of(context).go(AppRoutes.loginScreen);
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: EdgeInsets.only(right: 24.w, top: 16.h),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Container
                        Container(
                          width: 200.r,
                          height: 200.r,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: // Illustration Image
                          SvgPicture.asset(
                            page.imageUrl, // Using SvgPicture for .svg assets
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 48.h),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Description
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primaryColor
                        : AppColors.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Next / Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _currentPage == _pages.length - 1
                    ? PrimayButtonWidget(
                        key: const ValueKey('getStarted'),
                        buttonText: 'Get Started',
                        onPress: _completeOnboarding,
                        width: double.infinity,
                      )
                    : PrimayButtonWidget(
                        key: const ValueKey('next'),
                        buttonText: 'Next',
                        onPress: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        width: double.infinity,
                      ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}