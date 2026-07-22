import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/Cart/models/cart_item_model.dart';

class CartRepo {
  final DioHelper _dioHelper;

  CartRepo(this._dioHelper);

  Future<Either<String, List<CartItemModel>>> getUserCart() async {
    try {
   
      final response =
          await _dioHelper.getRequest(endPoint: ApiEndpoints.myCarts);
      if (response.statusCode == 200) {
        if (response.data == null || (response.data is List && (response.data as List).isEmpty)) {
          return const Right([]);
        }

        if (response.data is! List) {
          return const Left("Invalid cart data format: expected a list of items.");
        }

        final List<dynamic> productsList = response.data;

        List<CartItemModel> cartItems = List<CartItemModel>.from(
          productsList.map((item) => CartItemModel.fromJson(item)),
        );

        return Right(cartItems);
      } else {
        return Left("Error in Getting Cart: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
      log(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, CartItemModel>> addToCart(
      {
     
      required int productId,
      required int quantity}) async {
    try {
   
      final response = await _dioHelper.postRequest(
          endPoint: ApiEndpoints.addToCart, data: {
       
        "productId": productId,
        "quantity": quantity,
      });
      if (response.statusCode == 200) {
        CartItemModel cartItem = CartItemModel.fromJson(response.data);
        return Right(cartItem);
      } else { // This else block should be for non-200 status codes
        return Left("Error in Adding to Cart: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> incrementQuantity(int cartItemId) async {
    try {
      
      final response = await _dioHelper.putRequest(
        endPoint: ApiEndpoints.incrementCartItem,
        query: {"cartItemId": cartItemId},
        
      );

      if (response.statusCode == 200) {
        return const Right("Quantity incremented");
      } else {
        return Left("Error: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
        log(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> decrementQuantity(int cartItemId) async {
    try {
      
      final response = await _dioHelper.putRequest(
        endPoint: ApiEndpoints.decrementCartItem,
        query: {"cartItemId": cartItemId},
       
      );

      if (response.statusCode == 200) {
        return const Right("Quantity decremented");
      } else {
        return Left("Error: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> removeCartItem(int cartItemId) async {
    try {
   
      final response = await _dioHelper.deleteRequest(
        endPoint: "${ApiEndpoints.removeCartItem}/$cartItemId",
       
     
      );

      if (response.statusCode == 200) {
        return const Right("Cart item removed");
      } else {
        return Left("Error: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
  //write methode to checkout using shippingaddressid 
  //parameters : shippingAddressId,payemntMethodId
  Future<Either<String, String>> checkout({required int shippingAddressId, required int payment
  }) async {
    try {
      log("Initiating checkout with shippingAddressId: $shippingAddressId and paymentMethodId: $payment");
     
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.checkout,
       
        data: {
          "shippingAddressId": shippingAddressId,
          "paymentMethodId": payment
        },
      );

      if (response.statusCode == 200) {
        return const Right("Checkout successful");
      } else {
        return Left("Error: ${response.statusMessage ?? 'Unknown error'}");
      }
    } catch (e) {
      log("Error in checkout: ${e.toString()}");
      if (e is DioException) {
        return Left(e.response?.data['message'] ?? e.message.toString());
      }
      return Left(e.toString());
    }
  }
}
