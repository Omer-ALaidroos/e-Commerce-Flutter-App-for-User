class CreateUserModel {
  final String fullName;

  final String email;
  final String password;
  final String confirmPassword;

  CreateUserModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
  }); 
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }

  
}