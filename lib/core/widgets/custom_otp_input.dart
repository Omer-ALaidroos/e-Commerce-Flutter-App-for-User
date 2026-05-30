import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOtpInput extends StatelessWidget {
  final int length;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomOtpInput({
    super.key,
    this.length = 6,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Invisible TextFormField to handle input logic, pasting, and keyboard
        Opacity(
          opacity: 0,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            maxLength: length,
            decoration: const InputDecoration(counterText: ""),
          ),
        ),
        // Decorative boxes for the "perfect" UI look
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(length, (index) {
            bool isFilled = controller.text.length > index;
            bool isFocused = controller.text.length == index || (index == length - 1 && controller.text.length == length);
            
            return Container(
              width: 50.w,
              height: 55.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isFocused ? Theme.of(context).primaryColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                isFilled ? controller.text[index] : "",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}