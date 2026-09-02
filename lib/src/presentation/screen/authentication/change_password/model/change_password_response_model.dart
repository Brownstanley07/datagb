class ChangePasswordResponseModel {
  String? email;
  String? otp;
  String? password;
  String? passwordConfirmation;

  ChangePasswordResponseModel({
    this.email,
    this.otp,
    this.password,
    this.passwordConfirmation,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponseModel(
        email: json["email"],
        otp: json["otp"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
