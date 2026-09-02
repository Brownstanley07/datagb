class RegisterResponseModel {
  bool? status;
  String? message;
  Data? data;

  RegisterResponseModel({this.status, this.message, this.data});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? token;

  Data({this.token});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"]);

  Map<String, dynamic> toJson() => {"token": token};
}
