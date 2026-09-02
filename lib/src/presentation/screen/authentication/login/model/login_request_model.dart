class LoginRequestModel {
  String? email;
  String? password;

  LoginRequestModel({this.email, this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(email: json["email"], password: json["password"]);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
