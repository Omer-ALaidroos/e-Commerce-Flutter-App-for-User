import 'package:e_commerce_app/features/Cart/models/checkout_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckoutResponseModel', () {
    test('parses order, client secret and payment intent id from JSON', () {
      final json = {
        'orderId': 42,
        'clientSecret': 'pi_test_secret',
        'paymentIntentId': 'pi_test_123',
      };

      final model = CheckoutResponseModel.fromJson(json);

      expect(model.orderId, 42);
      expect(model.clientSecret, 'pi_test_secret');
      expect(model.paymentIntentId, 'pi_test_123');
    });

    test('parses payment details from the nested backend response', () {
      final json = {
        'order': {
          'isSuccess': true,
          'message': 'Order created successfully.',
          'data': 19,
        },
        'payment': {
          'orderId': 19,
          'paymentIntentId': 'pi_test_123',
          'clientSecret': 'pi_test_secret',
          'status': 'requires_payment_method',
          'amount': 4566.0,
          'currency': 'USD',
        },
      };

      final model = CheckoutResponseModel.fromJson(json);

      expect(model.orderId, 19);
      expect(model.clientSecret, 'pi_test_secret');
      expect(model.paymentIntentId, 'pi_test_123');
    });
  });
}
