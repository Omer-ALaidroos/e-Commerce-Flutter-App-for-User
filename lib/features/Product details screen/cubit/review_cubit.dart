// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import "package:e_commerce_app/features/Product%20details%20screen/cubit/review_state.dart";
import 'package:e_commerce_app/features/Product%20details%20screen/repo/review_repo.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewCubit(this._reviewRepository) : super(ReviewInitial());

  Future<void> checkCanReview(int productId) async {
    // Assuming user is logged in. Add your own logic to check auth status.
    emit(CanReviewLoading());
    try {
      final canReviewModel = await _reviewRepository.checkCanReview(productId);
      emit(CanReviewLoaded(canReviewModel));
    } catch (e) {
      emit(CanReviewError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int productId,
    required int rating,
    String? reviewText,
  }) async {
    emit(ReviewSubmitting());
    try {
      await _reviewRepository.addReview(
        productId: productId,
        rating: rating,
        review: reviewText,
      );
      emit(ReviewSubmitSuccess());
    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }

  void resetState() {
    emit(ReviewInitial());
  }
}