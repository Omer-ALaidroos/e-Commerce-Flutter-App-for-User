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
 
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Login To Your Account",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "it's great to see you again",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Email", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      controller: email,
                      hintText: "Enter Your Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required.";
                        }
                        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                        if (!emailRegex.hasMatch(value)) {
                          return "Invalid email format.";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(16),
                    Text("Password", style: AppStyles.black16w500Style),
                    const HeightSpace(8),
                    CustomTextField(
                      hintText: "Enter Your Password",
                      controller: password,
                      isPassword: true,
                      suffixIcon: const Icon(Icons.visibility_off_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required.";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters long.";
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Password must contain at least one uppercase letter.";
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return "Password must contain at least one lowercase letter.";
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return "Password must contain at least one digit.";
                        }
                        if (!RegExp(r'[^]').hasMatch(value)) {
                          return "Password must contain at least one special character.";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(55),
                    PrimayButtonWidget(
                      buttonText: "Sign in",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                            email: email.text,
                            password: password.text,
                          );
                        }
                           
                      },
                    ),
                    const HeightSpace(12),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.registerScreen);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppStyles.black16w500Style.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                            children: [
                              TextSpan(
                                text: "Join",
                                style: AppStyles.black15BoldStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
            );
          },
        ),
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
