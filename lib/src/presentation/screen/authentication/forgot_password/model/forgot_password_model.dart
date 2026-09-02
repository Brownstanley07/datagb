class ForgotPasswordResponseModel {
  bool? status;
  String? message;

  ForgotPasswordResponseModel({this.status, this.message});

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
