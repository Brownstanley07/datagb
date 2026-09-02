class LanguageListResponseModel {
  bool? status;
  Data? data;

  LanguageListResponseModel({this.status, this.data});

  factory LanguageListResponseModel.fromJson(Map<String, dynamic> json) =>
      LanguageListResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<Language>? languages;

  Data({this.languages});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    languages: json["languages"] == null
        ? []
        : List<Language>.from(
            json["languages"]!.map((x) => Language.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "languages": languages == null
        ? []
        : List<dynamic>.from(languages!.map((x) => x.toJson())),
  };
}

class Language {
  int? id;
  dynamic flag;
  String? name;
  String? locale;
  int? isDefault;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Language({
    this.id,
    this.flag,
    this.name,
    this.locale,
    this.isDefault,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    flag: json["flag"],
    name: json["name"],
    locale: json["locale"],
    isDefault: json["is_default"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "flag": flag,
    "name": name,
    "locale": locale,
    "is_default": isDefault,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
