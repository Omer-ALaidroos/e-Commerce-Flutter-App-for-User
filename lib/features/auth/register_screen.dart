import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
         
          children: [
            HeightSpace(60.h),
            Text("Create an Account",
            style: AppStyles.primaryHeadLinesStyle,
            ),
            HeightSpace(10.h),
            Text("Let's create your account",
              style: AppStyles.grey12MediumStyle,
            ),
            HeightSpace( 40.h),
            Text("Full Name",
              style: AppStyles.black16w500Style,
            ),
            HeightSpace( 10.h),
            CustomTextField(
              hintText: "Enter your Full Name",
            
            ),
            HeightSpace( 10.h),
            Text("Email",
              style: AppStyles.black16w500Style,
            ),
            HeightSpace( 10.h),
            CustomTextField(
              hintText: "Enter your Email Address",
            
            ),
            HeightSpace( 20.h),
            Text("Password",
              style: AppStyles.black16w500Style,
            ),

            HeightSpace( 10.h),
            CustomTextField(
              hintText: "Enter your Password",
              isPassword: true,
              suffixIcon:  Icon(Icons.visibility_off_outlined),
            ),
            HeightSpace( 20.h),
              Text("Confirm Password",
                style: AppStyles.black16w500Style,
              ),
              HeightSpace( 10.h),
              CustomTextField(
                hintText: "Confirm your Password",
                isPassword: true,
                suffixIcon:  Icon(Icons.visibility_off_outlined),
              ),
            HeightSpace( 40.h),
            PrimayButtonWidget(
              buttonText: "Create Account",
              onPress: (){},
            ),
            HeightSpace( 10.h),
           
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Text("Already have an account?"),
               
                  TextButton(
                    onPressed:() {},
                    child: Text("log in",),
                   )
                ],
              )

          ],
        ),
      ),
    );
  }
}