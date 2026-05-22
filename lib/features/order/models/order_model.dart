

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;
  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.shippingAddress,
    required this.items,
  });   
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Unknown',
      orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
      items: (json['items'] as List<dynamic>? ?? []).map((item) => OrderItem.fromJson(item)).toList(),
    );
  }
}
  class ShippingAddress {
  final int id;
  final String street;
  final String city;
  final String country;
  ShippingAddress({
    required this.id,
    required this.street,
    required this.city,
    required this.country,
  });
  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] ?? 0,
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
class OrderItem {
  final int id;
  final int quantity;
  final double price;
  final ProductOrder product;
  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,  
      price: (json['price'] ?? 0.0).toDouble(),
      product: ProductOrder.fromJson(json['product'] ?? {}),
    );
  }   
}
class ProductOrder {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  ProductOrder({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}