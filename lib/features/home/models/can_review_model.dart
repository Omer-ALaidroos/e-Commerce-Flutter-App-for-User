class CanReviewModel {
  final bool canReview;
  final bool hasPurchased;
  final bool alreadyReviewed;

  CanReviewModel({
    required this.canReview,
    required this.hasPurchased,
    required this.alreadyReviewed,
  });

  factory CanReviewModel.fromJson(Map<String, dynamic> json) {
    return CanReviewModel(
      canReview: json['canReview'] ?? false,
      hasPurchased: json['hasPurchased'] ?? false,
      alreadyReviewed: json['alreadyReviewed'] ?? false,
    );
  }
}