import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';

class FavoriteRepo {
  final DioHelper _dioHelper;

  FavoriteRepo(this._dioHelper);

  Future<Either<String, void>> addToFavorite(int productId) async {
    try {
      await _dioHelper.postRequest(endPoint: "${ApiEndpoints.addFavorite}/$productId",
        
      );
      return right(null);
    } catch (e) {
      return left('some thing wrong');
    }
  }

  Future<Either<String, void>> removeFromFavorite(int productId) async {
    try {
      await _dioHelper.deleteRequest(
        endPoint: "${ApiEndpoints.removeFavorite}/$productId",
      );
      return right(null);
    } catch (e) {
      return left('some thing wrong');
    }
  }

  Future<Either<String, List<ProductModel>>> getFavoriteProducts() async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.myFavorites,
      );
      List<ProductModel> products = (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return right(products);
    } on DioException catch (e) {
      return left('Failed to fetch favorite products.');
    }
  }
}