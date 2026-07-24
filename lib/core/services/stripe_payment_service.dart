import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService {
  Future<void> initializePaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    if ((Stripe.publishableKey ?? '').isEmpty) {
      throw Exception(
        'Stripe publishable key is missing. Start the app with --dart-define=STRIPE_PUBLISHABLE_KEY=your_key',
      );
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantDisplayName,
        style: ThemeMode.system,
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          testEnv: true,
        ),
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}
