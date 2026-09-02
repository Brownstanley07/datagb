class WithdrawAccountsResponseModel {
  bool? status;
  Data? data;

  WithdrawAccountsResponseModel({this.status, this.data});

  factory WithdrawAccountsResponseModel.fromJson(Map<String, dynamic> json) =>
      WithdrawAccountsResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<WithdrawAccount>? withdrawAccounts;

  Data({this.withdrawAccounts});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    withdrawAccounts: json["withdraw_accounts"] == null
        ? []
        : List<WithdrawAccount>.from(
            json["withdraw_accounts"]!.map((x) => WithdrawAccount.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "withdraw_accounts": withdrawAccounts == null
        ? []
        : List<dynamic>.from(withdrawAccounts!.map((x) => x.toJson())),
  };
}

class WithdrawAccount {
  int? id;
  String? methodName;
  String? currency;
  Method? method;
  List<Field>? fields;

  WithdrawAccount({
    this.id,
    this.methodName,
    this.currency,
    this.method,
    this.fields,
  });

  factory WithdrawAccount.fromJson(Map<String, dynamic> json) =>
      WithdrawAccount(
        id: json["id"],
        methodName: json["method_name"],
        currency: json["currency"],
        method: json["method"] == null ? null : Method.fromJson(json["method"]),
        fields: json["fields"] == null
            ? []
            : List<Field>.from(json["fields"]!.map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "method_name": methodName,
    "currency": currency,
    "method": method?.toJson(),
    "fields": fields == null
        ? []
        : List<dynamic>.from(fields!.map((x) => x.toJson())),
  };
}

class Field {
  String? name;
  dynamic value;
  String? type;
  String? validation;

  Field({this.name, this.value, this.type, this.validation});

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    name: json["name"],
    value: json["value"],
    type: json["type"],
    validation: json["validation"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "type": type,
    "validation": validation,
  };
}

class Method {
  int? id;
  String? name;
  String? icon;
  String? type;
  num? minWithdraw;
  num? maxWithdraw;
  num? charge;
  num? rate;
  String? chargeType;
  String? time;

  Method({
    this.id,
    this.name,
    this.icon,
    this.type,
    this.minWithdraw,
    this.maxWithdraw,
    this.charge,
    this.rate,
    this.chargeType,
    this.time,
  });

  factory Method.fromJson(Map<String, dynamic> json) => Method(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    type: json["type"],
    minWithdraw: json["min_withdraw"],
    maxWithdraw: json["max_withdraw"],
    charge: json["charge"],
    rate: json["rate"],
    chargeType: json["charge_type"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "type": type,
    "min_withdraw": minWithdraw,
    "max_withdraw": maxWithdraw,
    "charge": charge,
    "rate": rate,
    "charge_type": chargeType,
    "time": time,
  };
}
