import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/networking/api_endpoints.dart';
import 'package:e_commerce_app/core/networking/dio_helper.dart';
import 'package:e_commerce_app/features/address/address_model.dart';

class AddressRepo {
  final DioHelper _dioHelper;

  AddressRepo(this._dioHelper);

  Future<Either<String, List<AddressModel>>> getAddresses() async {
    try {
      final response = await _dioHelper.getRequest(endPoint: ApiEndpoints.userAddresses);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return Right(data.map((e) => AddressModel.fromJson(e)).toList());
        } else if (data is Map<String, dynamic>) {
          // Handle the case where the backend returns a single address object
          return Right([AddressModel.fromJson(data)]);
        }
        return const Right([]);
      }
      return const Left("Failed to load addresses");
    } catch (e) {
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
        return Right(response.data['message'] ?? "Address added successfully");
      }
      return const Left("Failed to add address");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteAddress(int addressId) async {
    try {
      final response = await _dioHelper.deleteRequest(
        endPoint: "${ApiEndpoints.deleteAddress}/$addressId",
      );
      if (response.statusCode == 200) {
        return Right(response.data['message'] ?? "Address deleted successfully");
      }
      return const Left("Failed to delete address");
    } catch (e) {
      return Left(e.toString());
    }
  }
}