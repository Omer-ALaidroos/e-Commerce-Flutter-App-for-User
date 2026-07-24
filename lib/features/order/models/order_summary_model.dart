import 'package:e_commerce_app/features/order/models/order_status.dart';

class OrderSummaryModel {
  final int id;
  final double totalPrice;
  final OrderStatus status;
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
      status: OrderStatus.fromJson(json['status'] ?? json['Status']),
      totalPrice: (json['totalAmount'] ?? json['TotalAmount'] ?? 0.0).toDouble(),
      createdAt: DateTime.tryParse(json['orderDate'] ?? json['OrderDate'] ?? '') ?? DateTime.now(),
    );
  }
}