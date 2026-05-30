import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/core/utils/service_locator.dart';
import 'package:e_commerce_app/core/utils/storage_helper.dart';
import 'package:e_commerce_app/features/auth/repo/auth_local_data_source.dart';
import 'package:e_commerce_app/features/auth/models/login_response_model.dart';

class AuthRepo {
  final DioHelper _dioHelper;

  AuthRepo(this._dioHelper);
  Future<Either<String, String>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.register,
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "phoneNumber": phoneNumber,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['message'] ?? 'Create Account successful');
      } else {
        return Left(response.toString());
      }
    } catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          final errors =
              error.response?.data['errors'] as Map<String, dynamic>?;
          if (errors != null) {
            final errorMessages = errors.entries
                .map((entry) => "${entry.key}: ${entry.value.join(', ')}")
                .join('\n');
            return Left(errorMessages);
          }
        }
        return Left(
          error.response?.data['message'] ?? error.message.toString(),
        );
      }
      return Left(error.toString());
    }
  }

  Future<Either<String, LoginResponseModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.login,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(
          response.data,
        );

        if (loginResponseModel.token != null) {
          log(LoginResponseModel.fromJson(response.data).toString());

          {
            await sl<StorageHelper>().saveToken(loginResponseModel.token!);
            if (loginResponseModel.userId != null) {
              await sl<AuthLocalDataSource>().saveUserId(
                loginResponseModel.userId!,
              );
            }
            if (loginResponseModel.refreshToken != null) {
              await sl<StorageHelper>().saveRefreshToken(
                loginResponseModel.refreshToken!,
              );
            }
          }

          return Right(loginResponseModel);
        } else {
          return const Left("Token is null");
        }
      } else {
        return Left(response.toString());
      }
    } catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          final errors =
              error.response?.data['errors'] as Map<String, dynamic>?;
          if (errors != null) {
            final errorMessages = errors.entries
                .map((entry) => "${entry.key}: ${entry.value.join(', ')}")
                .join('\n');
            return Left(errorMessages);
          }
        }
        return Left(
          error.response?.data['message'] ?? error.message.toString(),
        );
      }
      return Left(error.toString());
    }
  }
}

Future<String?> refreshAccessToken() async {
  final refreshToken = await sl<StorageHelper>().getRefreshToken();
  if (refreshToken == null) return null;

  try {
    final response = await Dio().post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      final newAccessToken = response.data['Token'];
      final newRefreshToken = response.data['Refreshtoken'];

      await sl<StorageHelper>().saveToken(newAccessToken);
      await sl<StorageHelper>().saveRefreshToken(newRefreshToken);
      return newAccessToken;
    }
  } catch (e) {
    // Handle error (e.g., refresh token expired)
    return null;
  }
}
