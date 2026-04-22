abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
class LoadingRegisterState extends RegisterState {}
class ErrorRegisterState extends RegisterState {
  final String message;
  ErrorRegisterState(this.message);
}
class SuccessRegisterState extends RegisterState {
  final String message;
  SuccessRegisterState(this.message);
}
