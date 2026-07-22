import 'package:e_commerce_app/features/address/address_model.dart';
import 'package:e_commerce_app/features/address/address_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepo _addressRepo;

  AddressCubit(this._addressRepo) : super(AddressInitial());

  Future<void> fetchAddresses() async {
    emit(AddressLoading());
    final result = await _addressRepo.getAddresses();
    if (isClosed) return;
    result.fold(
      (error) => emit(AddressError("Failed to fetch addresses: $error")),
      (addresses) {
        if (addresses.isEmpty) {
          emit(AddressNotFound("No addresses found"));
        } else if (addresses[0].id == 0) {
          emit(AddressNotFound("No addresses found"));
        } else {
          emit(AddressSuccess(addresses));
        }
      },
    );
  }

  Future<void> addAddress(AddressModel address) async {
    emit(AddressLoading());
    final result = await _addressRepo.addAddress(address);
    if (isClosed) return;
    result.fold(
      (error) => emit(AddAddressError("Failed to add address: $error")),
      (message) {
        emit(AddAddressSuccess(message));
        fetchAddresses();
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    final result = await _addressRepo.deleteAddress(id);
    if (isClosed) return;
    result.fold(
      (error) => emit(DeleteAddressError("Failed to delete address: $error")),
      (message) {
        emit(DeleteAddressSuccess(message));
        fetchAddresses();
      },
    );
  }
}