import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/my_Details/models/user_details.dart';
import 'package:e_commerce_app/features/my_Details/repo/user_details_repo.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  final UserDetailsRepo _userDetailsRepo;
  EditCubit(this._userDetailsRepo) : super(EditInitial());

  Future<void> updateFullName({
   
    required String fullName,
  }) async {
    emit(EditLoading());
    try {
      final message =
          await _userDetailsRepo.updateFullName(fullName: fullName);

     
      emit(EditSuccess(message));
    } catch (e) {
      emit(EditError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updatePhoneNumber({
   
    required String phoneNumber,
  }) async {
    emit(EditLoading());
    try {
      final message =
          await _userDetailsRepo.updatePhoneNumber(phoneNumber: phoneNumber);

      emit(EditSuccess( message));
    } catch (e) {
      emit(EditError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(EditLoading());
    try {
      final message = await _userDetailsRepo.updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      emit(EditSuccess(message));
    } catch (e) {
      emit(EditError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}