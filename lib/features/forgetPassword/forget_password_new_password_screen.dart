import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/primay_button_widget.dart';

class ForgetPasswordNewPasswordScreen extends StatefulWidget {
  const ForgetPasswordNewPasswordScreen({super.key});

  @override
  State<ForgetPasswordNewPasswordScreen> createState() => _ForgetPasswordNewPasswordScreenState();
}

class _ForgetPasswordNewPasswordScreenState extends State<ForgetPasswordNewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final email = extra?['email'] as String? ?? "";
    final otp = extra?['otp'] as String? ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set New Password'),
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordError) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.error);
          }
          if (state is ResetPasswordSuccess) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.success);
            context.goNamed(AppRoutes.loginScreen);
          }
        },
        builder: (context, state) {
          if (state is ForgetPasswordLoading) {
            return const LoadingWidget();
          }
          return Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please enter your new password.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              PrimayButtonWidget(
                bordersRadius: 12.r,
                buttonText: 'Reset Password',
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ForgetPasswordCubit>().resetPassword(
                          email: email,
                          code: otp,
                          newPassword: _newPasswordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        );
                  }
                },
              ),
            ],
          ),
        ),);
        },
      ),
    );
  }
}