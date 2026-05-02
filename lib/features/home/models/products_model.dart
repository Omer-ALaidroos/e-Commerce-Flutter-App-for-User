List<ProductModel> productModelFromJson(dynamic str) =>
    List<ProductModel>.from(str.map((x) => ProductModel.fromJson(x)));

class ProductModel {
  final int? id;
  final String? name;
  final String? description;
  final double price;
  final int quantity;
  final int categoryId;
  final String? imageUrl;
  final DateTime? createdAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    this.imageUrl,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] as int?,
        name: json["name"] as String?,
        description: json["description"] as String?,
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        quantity: json["quantity"] as int? ?? 0,
        categoryId: json["categoryId"] as int? ?? 0,
        imageUrl: json["imageUrl"] as String?,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (name != null) "name": name,
        if (description != null) "description": description,
        "price": price,
        "quantity": quantity,
        "categoryId": categoryId,
        if (imageUrl != null) "imageUrl": imageUrl,
        if (createdAt != null) "createdAt": createdAt!.toIso8601String(),
      };
}
