import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/home/models/category_model.dart';
import 'package:e_commerce_app/features/home/models/products_model.dart';

class HomeRepo {
  final DioHelper _dioHelper;

  HomeRepo(this._dioHelper);

  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
       final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.allProducts,
      );

      if (response.statusCode == 200) {
        List<ProductModel> products =   (response.data as List).map((e) => ProductModel.fromJson(e)).toList();

        return Right(products);
      } else {
        return Left("Something went wrong");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ProductModel>>> getProductCategories(
      int catId) async {
    try {
      final response = await _dioHelper.getRequest(
        endPoint:
            "${ApiEndpoints.baseUrl}${ApiEndpoints.productsByCategoryId}$catId",
      );

      if (response.statusCode == 200) {
        List<ProductModel> products =   (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
        return Right(products);
      } else {
        return Left("Something went wrong");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ProductModel>>> searchProducts(String name) async {
    try {
      final trimmedName = name.trim();
      if (trimmedName.isEmpty) {
        return Left("Search term cannot be empty.");
      }

      final response = await _dioHelper.getRequest(
        endPoint: ApiEndpoints.searchProducts,
        query: {'name': trimmedName},
      );

      if (response.statusCode == 200) {
        List<ProductModel> products =   (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
        return Right(products);
      } else {
        return Left("Something went wrong");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<CategoryModel>>> getCategories() async {
  try {
    final response = await _dioHelper.getRequest(
      endPoint: ApiEndpoints.allCategories,
    );
   
    if (response.statusCode == 200) {
      if (response.data is List) {
        List<CategoryModel> categories = (response.data as List)
            .where((item) => item != null && item['id'] != null) // Filter out invalid items
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        categories.insert(0, CategoryModel(id: 0, name: "all"));
        return Right(categories);
      } else {
        return Left("Invalid data format");
      }
    } else {
      return Left("Something went wrong");
    }
  } catch (e) {
    log("categories error: ${e.toString()}");
    return Left(e.toString());
  }
}
}
