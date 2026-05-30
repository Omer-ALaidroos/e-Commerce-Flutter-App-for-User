import 'package:e_commerce_app/features/auth/cubit/register/register_state.dart';
import 'package:e_commerce_app/features/auth/models/create_user_model.dart';
import 'package:e_commerce_app/features/auth/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo _authRepo;

  RegisterCubit(this._authRepo) : super(RegisterInitial());

  void register(CreateUserModel userModel) async {
    emit(LoadingRegisterState());

    final result = await _authRepo.register(
      fullName: userModel.fullName,
      email: userModel.email,
      password: userModel.password,
      confirmPassword: userModel.confirmPassword,
      phoneNumber: userModel.phoneNumber,
    );

    result.fold(
      (error) => emit(ErrorRegisterState(error)),
      (message) => emit(SuccessRegisterState(message)),
    );
  }
}