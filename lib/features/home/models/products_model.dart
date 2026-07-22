class ProductModel {
  final int? id;
  final String? name;
 
  final double? price;
 
 
  final bool? isFavorite;
  final double? AverageRating;
  final String? PrimaryImageUrl; // Changed from String? imageUrl

  ProductModel({
    this.PrimaryImageUrl, 
    this.id,
    this.name,
   
    this.price,
    this.isFavorite,
    this.AverageRating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      PrimaryImageUrl: json['primaryImageUrl'],
      id: json['id'],
      name: json['name'],
     
      price: (json['price'] as num?)?.toDouble(),
    
      isFavorite: json['isFavorite'],
      AverageRating: (json['averageRating'] as num?)?.toDouble(), 
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'averageRating': AverageRating,
        'isFavorite': isFavorite,
        'price': price,
      };
}