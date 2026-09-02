class GenerateTwoFaResponseModel {
  bool? status;
  String? message;
  Data? data;

  GenerateTwoFaResponseModel({this.status, this.message, this.data});

  factory GenerateTwoFaResponseModel.fromJson(Map<String, dynamic> json) =>
      GenerateTwoFaResponseModel(
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
  String? qrCode;
  String? secret;

  Data({this.qrCode, this.secret});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(qrCode: json["qr_code"], secret: json["secret"]);

  Map<String, dynamic> toJson() => {"qr_code": qrCode, "secret": secret};
}
