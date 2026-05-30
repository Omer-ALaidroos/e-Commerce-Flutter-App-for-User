class RegisterResponseModel {
 
  bool? success;
  String? message;
  RegisterResponseModel({
    this.success,
    this.message,
  });
  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }
  


}