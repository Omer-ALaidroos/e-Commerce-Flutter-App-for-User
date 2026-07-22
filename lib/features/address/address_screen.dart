import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/utils/animated_snack_dialog.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/loading_widget.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/address/address_cubit.dart';
import 'package:e_commerce_app/features/address/address_model.dart';
import 'package:e_commerce_app/features/address/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      _hasFetched = true;
      context.read<AddressCubit>().fetchAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressNotFound) {
            return FloatingActionButton(
              onPressed: () => _showAddAddressDialog(context),
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: BlocConsumer<AddressCubit, AddressState>(
          listener: (context, state) {
            if (state is AddressOperationSuccess) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.success);
            } else if (state is AddressError) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.error);
            } else if (state is AddAddressError) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.error);
            } else if (state is DeleteAddressError) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.error);
            } else if (state is AddAddressSuccess) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.success);
            } else if (state is DeleteAddressSuccess) {
              showAnimatedSnackDialog(context, message: state.message, type: AnimatedSnackBarType.success);
            }

          },
          builder: (context, state) {
            if (state is AddressLoading) {
              return const LoadingWidget();
            }

            if (state is AddressError) {
              return Center(
                child: Text(state.message, style: AppStyles.black16w500Style),
              );
            }
            if (state is AddressNotFound) {
              return Center(
                child: IconButton(
                  onPressed: () => _showAddAddressDialog(context),
                  icon: Icon(
                    Icons.add_location_alt_outlined, 
                    size: 80.sp,
                    color: AppColors.primaryColor,
                  ),
                  
                ),
              );
            }
            if (state is AddressSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpace(20),
                  Text("Saved Address", style: AppStyles.black15BoldStyle),
                  const HeightSpace(24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.addresses.length,
                      separatorBuilder: (context, index) => const HeightSpace(16),
                      itemBuilder: (context, index) {
                        final item = state.addresses[index];
                        return Container(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded, color: AppColors.primaryColor, size: 22.sp),
                                      const WidthSpace(12),
                                      Text("Address Details", style: AppStyles.black15BoldStyle),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => _showDeleteConfirmation(context, item.id!),
                                    icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20.sp),
                                  ),
                                ],
                              ),
                              const Divider(height: 1),
                              _buildAddressInfoRow(Icons.public_outlined, "Country", item.country ?? ""),
                              const Divider(height: 1),
                              _buildAddressInfoRow(Icons.location_city_outlined, "City", item.city ?? ""),
                              const Divider(height: 1),
                              _buildAddressInfoRow(Icons.map_outlined, "Street", item.street ?? ""),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAddressInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20.sp),
          const WidthSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                const HeightSpace(4),
                Text(value, style: AppStyles.black16w500Style.copyWith(fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    final addressCubit = context.read<AddressCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to remove this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              addressCubit.deleteAddress(id);
              Navigator.pop(dialogContext);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final countryController = TextEditingController();
    final cityController = TextEditingController();
    final streetController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final addressCubit = context.read<AddressCubit>();

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
                  Text("Add New Address", style: AppStyles.primaryHeadLinesStyle),
                  const HeightSpace(20),
                  CustomTextField(
                    controller: countryController,
                    hintText: "Country",
                    validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  ),
                  const HeightSpace(16),
                  CustomTextField(
                    controller: cityController,
                    hintText: "City",
                    validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  ),
                  const HeightSpace(16),
                  CustomTextField(
                    controller: streetController,
                    hintText: "Street",
                    validator: (value) => value == null || value.isEmpty ? "Required" : null,
                  ),
                  const HeightSpace(24),
                  PrimayButtonWidget(
                    buttonText: "Save",
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        addressCubit.addAddress(
                          AddressModel(
                            country: countryController.text,
                            city: cityController.text,
                            street: streetController.text,
                          ),
                        );
                        Navigator.pop(dialogContext);
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
