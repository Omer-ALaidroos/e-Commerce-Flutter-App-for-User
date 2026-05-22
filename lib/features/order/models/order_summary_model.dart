class OrderSummaryModel {
  final int id;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrderSummaryModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] ?? json['Id'] ?? 0,
      status: json['status'] ?? json['Status'] ?? 'Unknown',
      totalPrice: (json['totalAmount'] ?? json['TotalAmount'] ?? 0.0).toDouble(),
      createdAt: DateTime.tryParse(json['orderDate'] ?? json['OrderDate'] ?? '') ?? DateTime.now(),
    );
  }
}