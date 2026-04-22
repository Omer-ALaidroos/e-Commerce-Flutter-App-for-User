import 'package:e_commerce_app/features/auth/cubit/register/register_state.dart';
import 'package:e_commerce_app/features/auth/models/create_user_model.dart';
import 'package:e_commerce_app/features/auth/repo/register_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit   extends Cubit<RegisterState> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  void register(CreateUserModel createUserModel) async {
    emit(LoadingRegisterState());

    final result = await _registerRepo.register(createUserModel);

    result.fold(
      (error) => emit(ErrorRegisterState(error)),
      (message) => emit(SuccessRegisterState(message)),
    );
  }
}
