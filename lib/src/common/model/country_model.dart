class CountryModelResponse {
  bool? status;
  bool? isLicense;
  Data? data;

  CountryModelResponse({this.status, this.isLicense, this.data});

  factory CountryModelResponse.fromJson(Map<String, dynamic> json) =>
      CountryModelResponse(
        status: json["status"],
        isLicense: json["is_license"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Country>? countries;

  Data({this.countries});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countries: json["countries"] == null
        ? []
        : List<Country>.from(
            json["countries"]!.map((x) => Country.fromJson(x)),
          ),
  );
}

class Country {
  String? name;
  String? dialCode;
  String? code;
  bool? selected;

  Country({this.name, this.dialCode, this.code, this.selected});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"],
    dialCode: json["dial_code"],
    code: json["code"],
    selected: json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "dial_code": dialCode,
    "code": code,
    "selected": selected,
  };
}
