import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';

class ForgetPasswordRepo {
  final DioHelper _dioHelper;

  ForgetPasswordRepo(this._dioHelper);

  /// Sends a request to generate an OTP for the given email.
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.forgotPassword,
        data: {"email": email},
      );
      // The backend returns Ok(result). We extract the message or return a default.
      return response.data['message'] ?? "If an account exists, an OTP has been sent.";
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }



  /// Verifies the OTP code sent to the user's email.
  Future<String> verifyCode(String email, String code) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.verifyResetCode,
        data: {
          "email": email,
          "code": code,
        },
      );
      return response.data['message'] ?? "Code verified successfully.";
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("Verification failed: ${e.toString()}");
    }
  }



  /// Resets the password using the email, verified code, and the new password.
  Future<String> resetPassword(String email, String code, String newPassword,String confirmPassword) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.resetPassword,
        data: {
          "email": email,
          "code": code,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
      );
      return response.data['message'] ?? "Password has been reset successfully.";
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("Reset failed: ${e.toString()}");
    }
  }

  Exception _handleError(DioException e) {
    final serverMessage = e.response?.data is Map
        ? (e.response?.data['message'] ?? e.response?.data['Message'])
        : e.response?.data?.toString();
    return Exception(serverMessage ?? "Network error. Please try again.");
  }


}