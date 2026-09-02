class LoginResponseModel {
  bool? status;
  Data? data;

  LoginResponseModel({this.status, this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  String? token;
  String? biometricToken;
  String? tokenType;
  bool? isNewUser;

  Data({this.token, this.biometricToken, this.tokenType, this.isNewUser});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    biometricToken: json["biometric_token"],
    tokenType: json["token_type"],
    isNewUser: json["is_new_user"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "biometric_token": biometricToken,
    "token_type": tokenType,
    "is_new_user": isNewUser,
  };
}
