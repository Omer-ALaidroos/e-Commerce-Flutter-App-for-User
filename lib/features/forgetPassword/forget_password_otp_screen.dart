import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/custom_otp_input.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordOTPScreen extends StatefulWidget {
  final String? email; // Optional: to display the email or use it for API calls
  const ForgetPasswordOTPScreen({super.key, this.email});

  @override
  State<ForgetPasswordOTPScreen> createState() => _ForgetPasswordOTPScreenState();
}

class _ForgetPasswordOTPScreenState extends State<ForgetPasswordOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordError) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.error);
          }
          if (state is VerifyOtpSuccess) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.success);
            context.pushNamed(
              AppRoutes.forgetPasswordNewPasswordRoute,
              extra: {'email': widget.email, 'otp': _otpController.text},
            );
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
                //dont dispaly all email just two letters and replace the part after @ and replace the rest with ****
                widget.email != null
                    ? 'Enter the 6-digit code sent to ${widget.email!.replaceAll(RegExp(r'(?<=.{3}).(?=.*@)'), '*')}'
                    : 'Enter the 6-digit code sent to your email.',
             
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20.h),
              // Integrated the custom OTP widget within a FormField for validation
              FormField<String>(
                validator: (value) {
                  if (_otpController.text.length != 6) {
                    return 'Please enter the complete 6-digit code';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    children: [
                      CustomOtpInput(
                        controller: _otpController,
                        onChanged: (_) => setState(() => state.didChange(_otpController.text)),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30.h),
              PrimayButtonWidget(
                bordersRadius: 12.r,
                buttonText: 'Verify OTP',
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ForgetPasswordCubit>().verifyOtp(widget.email ?? '', _otpController.text);
                  }
                },
              ),

              SizedBox(height: 10.h),
              TextButton(
                onPressed: () {
                  // Implement resend OTP logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resending OTP...')),
                  );
                },
                child: const Text('Resend OTP'),
              ),
            ],
          ),
        ),);
        },
      ),
    );
  }
}