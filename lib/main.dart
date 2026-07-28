
import 'dart:developer';

import 'package:e_commerce_app/core/routing/router_generation_config.dart';
import 'package:e_commerce_app/core/styling/theme_data.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

/*  const publishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );*/
  const publishableKey ='pk_test_51TwHoqCpskN5G4YTnBTMDEv3HK58UFEBHaMXuhHtW59TZOfWt8WcNX9pZPK7JexYtlD7W6c72GE9mP6y1JAA7whj00PfKQgPTX';

  if (publishableKey.isEmpty) {
    debugPrint(
      'Stripe publishable key is missing. Start the app with --dart-define=STRIPE_PUBLISHABLE_KEY=your_key',
    );
  } else {
    debugPrint('Stripe publishable key: $publishableKey');
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
     
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'e-commerce Demo',
          theme: AppThemes.lightTheme,
          routerConfig: RouterGenerationConfig.goRouter,
        );
      },
    );
  }
}
