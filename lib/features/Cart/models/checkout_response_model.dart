class CheckoutResponseModel {
  final int orderId;
  final String clientSecret;
  final String paymentIntentId;

  const CheckoutResponseModel({
    required this.orderId,
    required this.clientSecret,
    required this.paymentIntentId,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'];
    final order = json['order'];

    final parsedOrderId = _readInt(
      payment?['orderId'] ?? order?['data'] ?? json['orderId'],
    );
    final parsedClientSecret = _readString(
      payment?['clientSecret'] ?? json['clientSecret'],
    );
    final parsedPaymentIntentId = _readString(
      payment?['paymentIntentId'] ?? json['paymentIntentId'],
    );

    return CheckoutResponseModel(
      orderId: parsedOrderId,
      clientSecret: parsedClientSecret,
      paymentIntentId: parsedPaymentIntentId,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _readString(dynamic value) {
    return value?.toString() ?? '';
  }
}
