//create repo for change fullname and phone number
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';

class UserDetailsRepo {
  final DioHelper dioHelper;

  UserDetailsRepo(this.dioHelper);

  Future<String> updateFullName({
    required String fullName,
  }) async {
    try {
      final token = await sl<StorageHelper>().getToken();
      final response = await dioHelper.putRequest(
        endPoint: ApiEndpoints.updateFullName,
        query: { "fullName": fullName },
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The backend returns response.Message in Ok()
        return response.data.toString();
      } else {
        // The backend returns response.Message in BadRequest()
       log(response.data.toString());
        throw Exception(response.data?.toString() ?? "Failed to update name.");
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> updatePhoneNumber({
    
    required String phoneNumber,
  }) async {
    try {
      final token = await sl<StorageHelper>().getToken();
      final response = await dioHelper.putRequest(
        endPoint: ApiEndpoints.updatePhoneNumber,
        query: { "phoneNumber": phoneNumber },
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString();
      } else {
        throw Exception(
            response.data?.toString() ?? "Failed to update phone number.");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await sl<StorageHelper>().getToken();
      final response = await dioHelper.postRequest(
        endPoint: ApiEndpoints.updatePassword,
        data: {
          "CurrentPassword": oldPassword,
          "NewPassword": newPassword,
          "ConfirmPassword": confirmPassword,
        },
        token: token,
      );

      // If the request is successful (2xx status code), extract the message.
      // Assuming your backend's Ok(result) returns a map with a 'message' key.
      return response.data['message'] ?? "Password updated successfully";
    } on DioException catch (e) {
      // When a DioException occurs (e.g., 400 Bad Request),
      // attempt to extract the specific error message from the server's response data.
      final serverMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.response?.data['Message'])
          : e.response?.data?.toString();
          
      log("Change Password Error: $serverMessage");
      throw Exception(serverMessage ?? "Failed to update password.");
    } catch (e) {
      // Catch any other unexpected exceptions.
      throw Exception(e.toString());
    }
  }

  Future<UserDetails> getUserDetails() async {
    try {
      final token = await sl<StorageHelper>().getToken();
      final response = await dioHelper.getRequest(
        endPoint: ApiEndpoints.userDetailsById     
      , token: token,
      );

      if (response.statusCode == 200) {
        return UserDetails.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch user details.");
      }
    } catch (e) {
      throw Exception(e.toString());  
    }
    }


}