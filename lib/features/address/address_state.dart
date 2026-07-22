
import 'package:e_commerce_app/features/address/address_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  final List<AddressModel> addresses;
  AddressSuccess(this.addresses);
}
class AddressNotFound extends AddressState {
  final String message;
  AddressNotFound(this.message);
}
class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}
class AddAddressError extends AddressState {
  final String message;
  AddAddressError(this.message);
}
class DeleteAddressError extends AddressState {
  final String message;
  DeleteAddressError(this.message);
}
class AddAddressSuccess extends AddressState {
  final String message;
  AddAddressSuccess(this.message);
}
class DeleteAddressSuccess extends AddressState {
  final String message;
  DeleteAddressSuccess(this.message);
}

class AddressOperationSuccess extends AddressState {
  final String message;
  AddressOperationSuccess(this.message);
}