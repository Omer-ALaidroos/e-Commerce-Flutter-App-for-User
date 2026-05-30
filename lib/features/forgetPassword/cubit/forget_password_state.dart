abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class SendOtpSuccess extends ForgetPasswordState {
  final String message;
  SendOtpSuccess(this.message);
}

class VerifyOtpSuccess extends ForgetPasswordState {
  final String message;
  VerifyOtpSuccess(this.message);
}

class ResetPasswordSuccess extends ForgetPasswordState {
  final String message;
  ResetPasswordSuccess(this.message);
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  ForgetPasswordError(this.message);
}