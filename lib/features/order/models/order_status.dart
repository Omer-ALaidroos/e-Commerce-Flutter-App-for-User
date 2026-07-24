enum OrderStatus {
  PendingPayment(1),
  Paid(2),
  Processing(3),
  Shipped(4),
  Delivered(5),
  Cancelled(6),
  PaymentFailed(7),
  Unknown(0);

  final int value;
  const OrderStatus(this.value);

  static OrderStatus fromJson(dynamic json) {
    if (json == null) return OrderStatus.Unknown;

    // If backend sends numeric values
    if (json is int) {
      return OrderStatus.values.firstWhere(
        (e) => e.value == json,
        orElse: () => OrderStatus.Unknown,
      );
    }

    // If backend sends strings like "Paid" or numeric strings
    final s = json.toString().trim();
    final lower = s.toLowerCase();

    // Try parse as int string
    final asInt = int.tryParse(s);
    if (asInt != null) {
      return OrderStatus.values.firstWhere(
        (e) => e.value == asInt,
        orElse: () => OrderStatus.Unknown,
      );
    }

    if (lower.contains('pending')) return OrderStatus.PendingPayment;
    if (lower.contains('paid')) return OrderStatus.Paid;
    if (lower.contains('processing')) return OrderStatus.Processing;
    if (lower.contains('shipped')) return OrderStatus.Shipped;
    if (lower.contains('delivered')) return OrderStatus.Delivered;
    if (lower.contains('cancel')) return OrderStatus.Cancelled;
    if (lower.contains('paymentfailed') || lower.contains('payment_failed') || lower.contains('payment failed')) return OrderStatus.PaymentFailed;

    return OrderStatus.Unknown;
  }

  String displayName() {
    switch (this) {
      case OrderStatus.PendingPayment:
        return 'Pending Payment';
      case OrderStatus.Paid:
        return 'Paid';
      case OrderStatus.Processing:
        return 'Processing';
      case OrderStatus.Shipped:
        return 'Shipped';
      case OrderStatus.Delivered:
        return 'Delivered';
      case OrderStatus.Cancelled:
        return 'Cancelled';
      case OrderStatus.PaymentFailed:
        return 'Payment Failed';
      default:
        return 'Unknown';
    }
  }
}
