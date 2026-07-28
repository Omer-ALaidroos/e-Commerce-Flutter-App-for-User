import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/address/address_model.dart';

class AddressRepo {
  final DioHelper _dioHelper;

  AddressRepo(this._dioHelper);

  Future<Either<String, List<AddressModel>>> getAddresses() async {
    try {
      final response = await _dioHelper.getRequest(endPoint: ApiEndpoints.userAddresses);
      // On success (200), the backend returns a single address object.
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        // Wrap the single address in a list.
        return Right([AddressModel.fromJson(response.data)]);
      }
      // If the status code is not 200 and Dio did not throw an exception,
      // it's an unexpected scenario for a successful response.
      // This line is a fallback and might be unreachable if Dio always throws for non-2xx.
      return Left("Unexpected response status: ${response.statusCode}");
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return const Right([]); // Return empty list for 404 Not Found
        }
        // For other DioErrors, try to extract a meaningful message from the response data
        final serverMessage = e.response?.data is Map
            ? (e.response?.data['message'] ?? e.response?.data['Message'])
            : e.response?.data?.toString();
        return Left(serverMessage ?? e.message ?? "An unknown Dio error occurred.");
      }
      // For any other type of exception
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> addAddress(AddressModel address) async {
    try {
      final response = await _dioHelper.postRequest(
        endPoint: ApiEndpoints.addAddress,
        data: address.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the success message is in the response data.
        return Right(response.data?.toString() ?? "Address added successfully");
      }
      // Fallback for unexpected successful status codes without a message.
      return Left("Failed to add address with status: ${response.statusCode}");
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.response?.data['Message'])
          : e.response?.data?.toString();
      return Left(serverMessage ?? e.message ?? "An unknown error occurred.");
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<Either<String, String>> deleteAddress(int addressId) async {
    try {
      final response = await _dioHelper.deleteRequest(
        endPoint: "${ApiEndpoints.deleteAddress}/$addressId", // Correctly constructs the URL
      );
      if (response.statusCode == 200) {
        return Right(response.data?.toString() ?? "Address deleted successfully");
      }
      return Left("Failed to delete address with status: ${response.statusCode}");
    } on DioException catch (e) {
      final serverMessage = e.response?.data?.toString();
      return Left(serverMessage ?? e.message ?? "An unknown error occurred.");
    } catch (e) {
      return Left("An unexpected error occurred: ${e.toString()}");
    }
  }
}