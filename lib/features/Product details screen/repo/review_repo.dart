import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/home/models/can_review_model.dart';

class ReviewRepository {
  final DioHelper _dioHelper;

  ReviewRepository(this._dioHelper);

  Future<CanReviewModel> checkCanReview(int productId) async {
    try {
    
      final response = await _dioHelper.getRequest(
        endPoint: '${ApiEndpoints.canReview}/$productId',
      );
      return CanReviewModel.fromJson(response.data);
    } catch (e) {
      log('Error checking can review: $e');
      throw Exception('Could not check review permissions.');
    }
  }

  Future<void> addReview({
    required int productId,
    required int rating,
    String? review,
  }) async {
    try {
     
      await _dioHelper.postRequest(
        endPoint: ApiEndpoints.addReview,
        data: {
          'productId': productId,
          'rating': rating,
          'review': review,
        },
      );
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.response?.data['Message'])
          : e.response?.data?.toString();
      log("Add Review Error: $serverMessage");
      throw Exception(serverMessage ?? "Failed to submit review.");
    } catch (e) {
      log('Error adding review: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}