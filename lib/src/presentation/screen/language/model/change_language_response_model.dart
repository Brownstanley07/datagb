class ChangeLanguageListResponseModel {
  bool? status;
  Data? data;

  ChangeLanguageListResponseModel({this.status, this.data});

  factory ChangeLanguageListResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangeLanguageListResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Language? language;

  Data({this.language});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    language: json["language"] == null
        ? null
        : Language.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {"language": language?.toJson()};
}

class Language {
  String? locale;
  Map<String, dynamic>? translationsKeys;
  String? message;

  Language({this.locale, this.translationsKeys, this.message});

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    locale: json["locale"],
    translationsKeys: json["translations_keys"] == null
        ? null
        : Map<String, dynamic>.from(json["translations_keys"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "locale": locale,
    "translations_keys": translationsKeys == null
        ? null
        : Map<String, dynamic>.from(translationsKeys!),
    "message": message,
  };
}
