abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class LoadingRegisterState extends RegisterState {}

class SuccessRegisterState extends RegisterState {
  final String message;
  SuccessRegisterState(this.message);
}

class ErrorRegisterState extends RegisterState {
  final String message;
  ErrorRegisterState(this.message);
}