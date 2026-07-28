class LoginResponseModel {
  String? userId;
  bool? success;
  String? message;
  String? token;
  String? refreshToken;

  LoginResponseModel({
    this.success,
    this.message,
    this.token,
    this.refreshToken,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    success = json['success'];
    message = json['message'];
    token = json['token'];
    refreshToken = json['refreshtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['userId'] = userId;
    data['message'] = message;
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
