import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/my_Details/cubit/user_details_cubit.dart';
import 'package:e_commerce_app/features/my_Details/cubit/edit_cubit.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:e_commerce_app/features/my_Details/widgets/header.dart';
import 'package:e_commerce_app/features/my_Details/widgets/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsScreen extends StatefulWidget {
 

  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late UserDetails currentUser;

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text("Account Details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<EditCubit, EditState>(
        listener: (context, state) {
          if (state is EditSuccess) {
            // Refresh data from backend after successful edit
            context.read<UserDetailsCubit>().fetchUserDetails();
            showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.success);
          } else if (state is EditError) {
            showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.error);
          }
        },
        builder: (context, editState) {
          return BlocBuilder<UserDetailsCubit, UserDetailsState>(
            builder: (context, userState) {
              if (userState is UserDetailsLoading) {
                return const Center(child: LoadingWidget());
              } else if (userState is UserDetailsError) {
                return Center(child: Text(userState.message));
              } else if (userState is UserDetailsSuccess) {
                currentUser = userState.userDetails;
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Header(userDetails: currentUser),
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  InfoCard(
                                    icon: Icons.email_outlined,
                                    label: "Email",
                                    value: currentUser.email,
                                  ),
                                  const Divider(height: 1),
                                  InfoCard(
                                    icon: Icons.person_outline_rounded,
                                    label: "Full Name",
                                    value: currentUser.fullName,
                                    isEditable: true,
                                    onEdit: () => _showEditDialog(
                                      context,
                                      "Full Name",
                                      currentUser.fullName,
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  InfoCard(
                                    icon: Icons.phone_android_rounded,
                                    label: "Phone Number",
                                    value: currentUser.phoneNumber,
                                    isEditable: true,
                                    onEdit: () => _showEditDialog(
                                      context,
                                      "Phone Number",
                                      currentUser.phoneNumber,
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  InfoCard(
                                    icon: Icons.lock_outline_rounded,
                                    label: "Password",
                                    value: "••••••••",
                                    isEditable: true,
                                    onEdit: () => _showChangePasswordDialog(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (editState is EditLoading) const LoadingWidget(),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  
  void _showEditDialog(BuildContext context, String label, String value) {
    final editCubit = context.read<EditCubit>();
    final TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit $label", style: AppStyles.primaryHeadLinesStyle),
              const HeightSpace(20),
              CustomTextField(
                controller: controller,
                hintText: label,
              ),
              const HeightSpace(24),
              PrimayButtonWidget(
                buttonText: "Save Changes",
                onPress: () {
                  Navigator.pop(dialogContext);
                  if (label == "Full Name") {
                    editCubit.updateFullName(
                          fullName: controller.text,
                        );
                  } else if (label == "Phone Number") {
                    editCubit.updatePhoneNumber(
                          phoneNumber: controller.text,
                        );
                  }
                },
              ),
              const HeightSpace(12),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final editCubit = context.read<EditCubit>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Change Password", style: AppStyles.primaryHeadLinesStyle),
                  const HeightSpace(20),
                  CustomTextField(
                    controller: oldPasswordController,
                    hintText: "Old Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Required";
                      if (value.length < 8) return "Min 8 characters";
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Must contain an uppercase letter";
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Must contain a lowercase letter";
                      }
                      if (!RegExp(r'\d').hasMatch(value)) {
                        return "Must contain a digit";
                      }
                      // Consider adding a special character validation if your backend requires it.
                      // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) { return "Must contain a special character"; }
                      return null;
                    },
                  ),
                  const HeightSpace(16),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: "New Password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Required";
                      if (value.length < 8) return "Min 8 characters";
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Must contain an uppercase letter";
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Must contain a lowercase letter";
                      }
                      if (!RegExp(r'\d').hasMatch(value)) {
                        return "Must contain a digit";
                      }
                      return null;
                    },
                  ),
                  const HeightSpace(16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isPassword: true,
                    validator: (val) => (val != newPasswordController.text) ? "Passwords don't match" : null,
                  ),
                  const HeightSpace(24),
                  PrimayButtonWidget(
                    buttonText: "Save Changes",
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(dialogContext);
                        editCubit.updatePassword(
                          confirmPassword: confirmPasswordController.text,
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,

                        );
                      }
                    },
                  ),
                  const HeightSpace(12),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}