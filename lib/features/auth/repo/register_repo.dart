import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/auth/models/create_user_model.dart';

class RegisterRepo {
  final DioHelper _dioHelper;

  RegisterRepo(this._dioHelper);

  Future<Either<String, String>> register(CreateUserModel createUserModel) async {
  try {
    final response = await _dioHelper.postRequest(
      endPoint: ApiEndpoints.register,
      data: createUserModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return const Right("Account Created Successfully");
    } else {
      return Left(response.data['message'] ?? "Registration Failed");
    }
  } catch (error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.badResponse) {
        final errors = error.response?.data['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.entries
              .map((entry) => "${entry.key}: ${entry.value.join(', ')}")
              .join('\n');
          return Left(errorMessages);
        }
      }
      return Left(error.response?.data['message'] ?? error.message.toString());
    }
    return Left(error.toString());
  }
}

}