import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/forgetPassword/repo/forget_password_repo.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo _forgetPasswordRepo;

  ForgetPasswordCubit(this._forgetPasswordRepo) : super(ForgetPasswordInitial());

  Future<void> sendOtp(String email) async {
    emit(ForgetPasswordLoading());
    try {
      final message = await _forgetPasswordRepo.forgotPassword(email);
      emit(SendOtpSuccess(message));
    } catch (e) {
      emit(ForgetPasswordError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    emit(ForgetPasswordLoading());
    try {
      final message = await _forgetPasswordRepo.verifyCode(email, code);
      emit(VerifyOtpSuccess(message));
    } catch (e) {
      emit(ForgetPasswordError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ForgetPasswordLoading());
    try {
      final message = await _forgetPasswordRepo.resetPassword(
        email,
        code,
        newPassword,
        confirmPassword,
      );
      emit(ResetPasswordSuccess(message));
    } catch (e) {
      emit(ForgetPasswordError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}