class DepositMethodResponseModel {
  bool? status;
  Data? data;

  DepositMethodResponseModel({this.status, this.data});

  factory DepositMethodResponseModel.fromJson(Map<String, dynamic> json) =>
      DepositMethodResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<DepositMethod>? depositMethods;

  Data({this.depositMethods});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    depositMethods: json["deposit_methods"] == null
        ? []
        : List<DepositMethod>.from(
            json["deposit_methods"]!.map((x) => DepositMethod.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "deposit_methods": depositMethods == null
        ? []
        : List<dynamic>.from(depositMethods!.map((x) => x.toJson())),
  };
}

class DepositMethod {
  num? id;
  num? gatewayId;
  String? logo;
  String? name;
  String? type;
  String? gatewayCode;
  num? charge;
  String? chargeType;
  num? minimumDeposit;
  num? maximumDeposit;
  num? rate;
  String? currency;
  String? currencySymbol;
  List<FieldOption>? fieldOptions;
  String? paymentDetails;
  String? bankName;
  String? accountNumber;
  String? accountName;
  num? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? gatewayLogo;

  DepositMethod({
    this.id,
    this.gatewayId,
    this.logo,
    this.name,
    this.type,
    this.gatewayCode,
    this.charge,
    this.chargeType,
    this.minimumDeposit,
    this.maximumDeposit,
    this.rate,
    this.currency,
    this.currencySymbol,
    this.fieldOptions,
    this.paymentDetails,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gatewayLogo,
  });

  factory DepositMethod.fromJson(Map<String, dynamic> json) => DepositMethod(
    id: json["id"],
    gatewayId: json["gateway_id"],
    logo: json["logo"],
    name: json["name"],
    type: json["type"],
    gatewayCode: json["gateway_code"],
    charge: json["charge"]?.toDouble(),
    chargeType: json["charge_type"],
    minimumDeposit: json["minimum_deposit"],
    maximumDeposit: json["maximum_deposit"],
    rate: json["rate"],
    currency: json["currency"],
    currencySymbol: json["currency_symbol"],
    fieldOptions: json["field_options"] == null
        ? []
        : List<FieldOption>.from(
            json["field_options"]!.map((x) => FieldOption.fromJson(x)),
          ),
    paymentDetails: json["payment_details"],
    bankName: json["bank_name"],
    accountNumber: json["account_number"],
    accountName: json["account_name"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    gatewayLogo: json["gateway_logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gateway_id": gatewayId,
    "logo": logo,
    "name": name,
    "type": type,
    "gateway_code": gatewayCode,
    "charge": charge,
    "charge_type": chargeType,
    "minimum_deposit": minimumDeposit,
    "maximum_deposit": maximumDeposit,
    "rate": rate,
    "currency": currency,
    "currency_symbol": currencySymbol,
    "field_options": fieldOptions == null
        ? []
        : List<dynamic>.from(fieldOptions!.map((x) => x.toJson())),
    "payment_details": paymentDetails,
    "bank_name": bankName,
    "account_number": accountNumber,
    "account_name": accountName,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "gateway_logo": gatewayLogo,
  };
}

class FieldOption {
  String? name;
  String? type;
  String? validation;

  FieldOption({this.name, this.type, this.validation});

  factory FieldOption.fromJson(Map<String, dynamic> json) => FieldOption(
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
