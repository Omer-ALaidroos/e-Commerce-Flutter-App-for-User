class CartItemModel {
  int? cartItemId;
  int? productId;
  String? productName;
  int? quantity;
  double? price;
  double? total;
  String? imageUrl;


  CartItemModel({
    this.cartItemId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.total,
    this.imageUrl,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
      cartItemId = json['cartItemId'];
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    total = json['total']?.toDouble();
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'total': total,
      'imageUrl': imageUrl,
    };
  }
}