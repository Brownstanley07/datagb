class WithdrawAccountListResponseModel {
  bool? status;
  Data? data;

  WithdrawAccountListResponseModel({this.status, this.data});

  factory WithdrawAccountListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => WithdrawAccountListResponseModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<WithdrawMethod>? withdrawMethods;

  Data({this.withdrawMethods});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    withdrawMethods: json["withdraw_methods"] == null
        ? []
        : List<WithdrawMethod>.from(
            json["withdraw_methods"]!.map((x) => WithdrawMethod.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "withdraw_methods": withdrawMethods == null
        ? []
        : List<dynamic>.from(withdrawMethods!.map((x) => x.toJson())),
  };
}

class WithdrawMethod {
  int? id;
  String? icon;
  String? type;
  String? gatewayId;
  String? name;
  String? currency;
  num? rate;
  String? requiredTime;
  String? requiredTimeFormat;
  num? charge;
  String? chargeType;
  String? minWithdraw;
  String? maxWithdraw;
  List<Field>? fields;
  num? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  WithdrawMethod({
    this.id,
    this.icon,
    this.type,
    this.gatewayId,
    this.name,
    this.currency,
    this.rate,
    this.requiredTime,
    this.requiredTimeFormat,
    this.charge,
    this.chargeType,
    this.minWithdraw,
    this.maxWithdraw,
    this.fields,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawMethod.fromJson(Map<String, dynamic> json) => WithdrawMethod(
    id: json["id"],
    icon: json["icon"],
    type: json["type"],
    gatewayId: json["gateway_id"],
    name: json["name"],
    currency: json["currency"],
    rate: json["rate"]?.toDouble(),
    requiredTime: json["required_time"],
    requiredTimeFormat: json["required_time_format"],
    charge: json["charge"]?.toDouble(),
    chargeType: json["charge_type"],
    minWithdraw: json["min_withdraw"],
    maxWithdraw: json["max_withdraw"],
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
    "icon": icon,
    "type": type,
    "gateway_id": gatewayId,
    "name": name,
    "currency": currency,
    "rate": rate,
    "required_time": requiredTime,
    "required_time_format": requiredTimeFormat,
    "charge": charge,
    "charge_type": chargeType,
    "min_withdraw": minWithdraw,
    "max_withdraw": maxWithdraw,
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
