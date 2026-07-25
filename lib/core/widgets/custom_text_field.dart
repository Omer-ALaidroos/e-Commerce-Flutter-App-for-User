import 'package:e_commerce_app/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? width;
  final bool? isPassword;
  final bool? isPhoneNumber;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.width,
    this.isPassword,
    this.isPhoneNumber,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 331.w,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        autofocus: false,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        keyboardType: widget.isPhoneNumber == true
            ? TextInputType.phone
            : TextInputType.text,
        obscureText: widget.isPassword == true ? _isObscured : false,
        cursorColor: AppColors.primaryColor,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: const Color(0xff9CA4AB),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: Color(0xffE7EAF2), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.9), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 10.w),
                  child: IconTheme(
                    data: IconThemeData(color: const Color(0xff8391A1), size: 22.sp),
                    child: widget.prefixIcon!,
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
          filled: true,
          fillColor: const Color(0xffF7F8FF),
          suffixIcon: widget.isPassword == true
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xff8391A1),
                    size: 22.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
