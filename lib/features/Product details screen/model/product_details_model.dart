class ProductImageModel {
  final int id;
  final String imageUrl;
  final bool isPrimary;

  ProductImageModel(
      {required this.id, required this.imageUrl, required this.isPrimary});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

class UserModel {
  final String fullName;
  final String? profilePicture;

  UserModel({required this.fullName, this.profilePicture});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? 'Anonymous',
      profilePicture: json['profilePicture'],
    );
  }
}

class ProductReviewModel {
  final int rating;
  final String review; // Keep as non-nullable, handle empty string
  final UserModel user;
  final DateTime createdAt;

  ProductReviewModel({
    required this.user,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      rating: json['rating'],
      review: json['review'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class ProductDetailsModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int categoryId;
  final double averageRating;
  final int reviewsCount;
  final DateTime createdAt;
  final List<ProductImageModel> images;
  final List<ProductReviewModel> reviews;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.averageRating,
    required this.reviewsCount,
    required this.createdAt,
    required this.images,
    required this.reviews,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      categoryId: json['categoryId'],
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'],
      createdAt: DateTime.parse(json['createdAt']),
      images: (json['images'] as List)
          .map((i) => ProductImageModel.fromJson(i))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((r) => ProductReviewModel.fromJson(r))
          .toList(),
    );
  }
}