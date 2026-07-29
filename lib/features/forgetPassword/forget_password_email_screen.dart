import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/features/forgetPassword/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({super.key});

  @override
  State<ForgetPasswordEmailScreen> createState() => _ForgetPasswordEmailScreenState();
}

class _ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordError) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.error);
          }
          if (state is SendOtpSuccess) {
            showAnimatedSnackDialog(context,
                message: state.message, type: AnimatedSnackBarType.success);
            GoRouter.of(context).pushNamed(
              AppRoutes.forgetPasswordOtpRoute,
              extra: _emailController.text,
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
                'Enter your email to receive an OTP code.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@example.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),
              PrimayButtonWidget(
                bordersRadius: 12.r,
                buttonText: 'Send OTP',
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ForgetPasswordCubit>().sendOtp(_emailController.text);
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