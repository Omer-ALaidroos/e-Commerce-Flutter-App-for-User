import 'package:e_commerce_app/core/routing/app_routes.dart';
import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/custom_text_field.dart';
import 'package:e_commerce_app/core/widgets/primay_button_widget.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            Text("Login To Your Account",
            style: AppStyles.primaryHeadLinesStyle,
            ),
            HeightSpace(10.h),
            Text("It's greate to see you again",
              style: AppStyles.grey12MediumStyle,
            ),
            HeightSpace( 60.h),
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
            HeightSpace( 60.h),
            PrimayButtonWidget(
              buttonText: "Sign in",
              onPress: (){
                GoRouter.of(  context).pushReplacement(AppRoutes.mainScreen);
              },
            ),
            HeightSpace( 250.h),
           
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Text("Don't have an account?"),
               
                  TextButton(
                    onPressed:() {
                      GoRouter.of(context).push(AppRoutes.registerScreen);
                    },
                    child: Text("join ",),
                   )
                ],
              )

          ],
        ),
      ),
    );
  }
}