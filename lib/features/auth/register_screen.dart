import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/auth/models/create_user_model.dart';
import 'package:e_commerce_app/features/auth/cubit/register/register_cubit.dart';
import 'package:e_commerce_app/features/auth/cubit/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is ErrorRegisterState) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
            if (state is SuccessRegisterState) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.success);
              context.pop();
            }
          },
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is LoadingRegisterState) const LoadingWidget(),
                    const HeightSpace(28),
                      CustomTextField(
                      controller: fullNameController,
                      hintText: "Full Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Full name is required.";
                        }
                        
                        return null;
                      },
                    ),
                     const SizedBox(height: 16),
                    CustomTextField(
                      controller: emailController,
                      hintText: "Email",
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: phoneController,
                      hintText: "Phone",
                      isPhoneNumber: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required.";
                        }
                        final phoneRegex = RegExp(r'^(77|78|70|71|73)[0-9]{7}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return "Phone must be 9 digits and start with 77, 78, 70, 71, or 73.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: passwordController,
                      hintText: "Password",
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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      isPassword: true,
                      suffixIcon: const Icon(Icons.visibility_off_outlined),
                     
                      validator: (value) {
                        if (value != passwordController.text || value == null || value.isEmpty) {
                          return "Passwords do not match.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    PrimayButtonWidget(
                      buttonText: "Create Account",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          context.read<RegisterCubit>().register(
                                CreateUserModel(
                                  fullName: fullNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword: confirmPasswordController.text,
                                  phoneNumber: phoneController.text,
                                ),
                              );
                        }
                      },
                    ),
                    HeightSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text("log in"),
                        )
                      ],
                    ),
                    HeightSpace(20.h),
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
