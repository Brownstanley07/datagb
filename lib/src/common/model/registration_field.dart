class RegistrationResponseModel {
  final bool? status;
  bool? isLicense;
  final Data? data;

  RegistrationResponseModel({this.status, this.isLicense, this.data});

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) =>
      RegistrationResponseModel(
        status: json["status"],
        isLicense: json["is_license"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  final List<RegisterField>? registerFields;

  Data({this.registerFields});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    registerFields: json["register_fields"] == null
        ? []
        : List<RegisterField>.from(
            json["register_fields"]!.map((x) => RegisterField.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "register_fields": registerFields == null
        ? []
        : List<dynamic>.from(registerFields!.map((x) => x.toJson())),
  };
}

class RegisterField {
  final String? key;
  final dynamic value;

  RegisterField({this.key, this.value});

  factory RegisterField.fromJson(Map<String, dynamic> json) =>
      RegisterField(key: json["key"], value: json["value"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value};
}

class ValueElement {
  final String? name;
  final String? type;
  final String? validation;

  ValueElement({this.name, this.type, this.validation});

  factory ValueElement.fromJson(Map<String, dynamic> json) => ValueElement(
    name: json["name"],
    type: json["type"],
    validation: json["validation"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "validation": validation,
  };
}
