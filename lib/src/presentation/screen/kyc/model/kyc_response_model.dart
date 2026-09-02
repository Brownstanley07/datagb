class KycResponseModel {
  bool? status;
  Data? data;

  KycResponseModel({this.status, this.data});

  factory KycResponseModel.fromJson(Map<String, dynamic> json) =>
      KycResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<Kyc>? kyc;

  Data({this.kyc});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    kyc: json["kyc"] == null
        ? []
        : List<Kyc>.from(json["kyc"]!.map((x) => Kyc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "kyc": kyc == null ? [] : List<dynamic>.from(kyc!.map((x) => x.toJson())),
  };
}

class Kyc {
  int? id;
  String? name;
  List<Field>? fields;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Kyc({
    this.id,
    this.name,
    this.fields,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
    id: json["id"],
    name: json["name"],
    fields: json["fields"] == null
        ? []
        : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
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
    "name": name,
    "fields": fields == null
        ? []
        : List<dynamic>.from(fields!.map((x) => x.toJson())),
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Field {
  String? name;
  String? type;
  String? validation;

  Field({this.name, this.type, this.validation});

  factory Field.fromJson(Map<String, dynamic> json) => Field(
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
