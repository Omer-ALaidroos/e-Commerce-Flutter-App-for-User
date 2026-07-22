import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/Product%20details%20screen/model/product_details_model.dart';

class ProductDetailsRepo {
  final DioHelper _dioHelper;

  ProductDetailsRepo(this._dioHelper);

  Future<Either<String, ProductDetailsModel>> getProductDetails(
      int productId) async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: "${ApiEndpoints.getProductDetails}/$productId",
      );
      if (response.statusCode == 200 && response.data != null) {
        final productDetails = ProductDetailsModel.fromJson(response.data);
        return Right(productDetails);
      } else {
        // This handles non-200 status codes that are not exceptions
        return Left('Failed to get product details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return Left('Product with ID $productId not found.');
        }
      }
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }
}