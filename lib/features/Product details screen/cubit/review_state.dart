
import 'package:e_commerce_app/features/home/models/can_review_model.dart';

abstract class ReviewState  {
  const ReviewState();
 
}

class ReviewInitial extends ReviewState {}

class CanReviewLoading extends ReviewState {}

class CanReviewLoaded extends ReviewState {
  final CanReviewModel canReviewModel;

  const CanReviewLoaded(this.canReviewModel);

  List<Object?> get props => [canReviewModel];
}

class CanReviewError extends ReviewState {
  final String message;

  const CanReviewError(this.message);

  List<Object?> get props => [message];
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitSuccess extends ReviewState {}

class ReviewSubmitError extends ReviewState {
  final String message;

  const ReviewSubmitError(this.message);

  List<Object?> get props => [message];
}