import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/auth/cubit/auth/auth_cubit.dart';
import 'package:e_commerce_app/features/auth/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  bool _hasCheckedToken = false;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedToken) {
      _hasCheckedToken = true;
      sl<StorageHelper>().getToken().then((token) {
        if (token != null && token.isNotEmpty) {
          context.pushReplacementNamed(AppRoutes.mainScreen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FF),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffF6F8FF), Color(0xffFFFFFF)],
              ),
            ),
          ),
          Positioned(
            top: -90,
            left: -80,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -70,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor.withOpacity(0.14), AppColors.primaryColor.withOpacity(0.04)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ErrorAuthState) {
                showAnimatedSnackDialog(
                  context,
                  message: state.message,
                  type: AnimatedSnackBarType.error,
                );
              }

              if (state is SuccessAuthState) {
                showAnimatedSnackDialog(
                  context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );

                context.pushReplacementNamed(AppRoutes.mainScreen);
              }
            },
            builder: (context, state) {
              if (state is LoadingAuthState) {
                return const LoadingWidget();
              }

              return SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 28.sp),
                                ),
                                const HeightSpace(10),
                                Text(
                                  'Sign in to access your shopping history, orders, and personalized offers.',
                                  style: AppStyles.subtitlesStyles.copyWith(color: AppColors.secondaryColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 82.w,
                            height: 82.w,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/shopping-cart.png',
                                width: 42.w,
                                height: 42.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const HeightSpace(24),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Login to your account',
                                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 24.sp),
                              ),
                              const HeightSpace(10),
                              Text(
                                'Enter your credentials to continue shopping securely.',
                                style: AppStyles.subtitlesStyles.copyWith(fontSize: 14.sp, color: AppColors.secondaryColor),
                              ),
                              const HeightSpace(28),
                              Text('Email', style: AppStyles.black16w500Style),
                              const HeightSpace(8),
                              CustomTextField(
                                controller: email,
                                hintText: 'Enter your email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required.';
                                  }
                                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Invalid email format.';
                                  }
                                  return null;
                                },
                              ),
                              const HeightSpace(20),
                              Text('Password', style: AppStyles.black16w500Style),
                              const HeightSpace(8),
                              CustomTextField(
                                controller: password,
                                hintText: 'Enter your password',
                                isPassword: true,
                                prefixIcon: const Icon(Icons.lock_outline),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required.';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long.';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Password must contain at least one uppercase letter.';
                                  }
                                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                                    return 'Password must contain at least one lowercase letter.';
                                  }
                                  if (!RegExp(r'\d').hasMatch(value)) {
                                    return 'Password must contain at least one digit.';
                                  }
                                  if (!RegExp(r'[^]').hasMatch(value)) {
                                    return 'Password must contain at least one special character.';
                                  }
                                  return null;
                                },
                              ),
                              const HeightSpace(16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    context.pushNamed(AppRoutes.forgetPasswordEmailRoute);
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppStyles.black16w500Style.copyWith(fontSize: 14.sp, color: AppColors.primaryColor),
                                  ),
                                ),
                              ),
                              const HeightSpace(12),
                              PrimayButtonWidget(
                                buttonText: 'Sign In',
                                buttonColor: AppColors.primaryColor,
                                textColor: AppColors.whiteColor,
                                width: double.infinity,
                                height: 56.h,
                                bordersRadius: 16.r,
                                onPress: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                          email: email.text,
                                          password: password.text,
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const HeightSpace(24),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(AppRoutes.registerScreen);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: AppStyles.black16w500Style.copyWith(color: AppColors.secondaryColor),
                              children: [
                                TextSpan(
                                  text: 'Create account',
                                  style: AppStyles.black15BoldStyle.copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const HeightSpace(20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
