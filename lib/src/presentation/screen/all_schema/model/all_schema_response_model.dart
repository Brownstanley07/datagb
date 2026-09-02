class AllSchemaResponseModel {
  bool? status;
  Data? data;

  AllSchemaResponseModel({this.status, this.data});

  factory AllSchemaResponseModel.fromJson(Map<String, dynamic> json) =>
      AllSchemaResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<Schema>? schemas;

  Data({this.schemas});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    schemas: json["schemas"] == null
        ? []
        : List<Schema>.from(json["schemas"]!.map((x) => Schema.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "schemas": schemas == null
        ? []
        : List<dynamic>.from(schemas!.map((x) => x.toJson())),
  };
}

class Schema {
  int? id;
  String? icon;
  String? name;
  String? badge;
  String? holiday;
  String? amountRange;
  int? minAmount;
  int? maxAmount;
  int? fixedAmount;
  String? returnInterest;
  String? returnInterestType;
  String? numberPeriod;
  bool? capitalBack;
  bool? isAutoRenewal;
  String? autoRenewalSource;
  bool? isCancel;
  bool? isCompounding;
  int? investAmount;
  int? period;
  String? interest;
  String? interestType;
  String? roiInterestType;
  int? minRoi;
  int? maxRoi;
  int? fixedRoi;

  Schema({
    this.id,
    this.icon,
    this.name,
    this.badge,
    this.holiday,
    this.amountRange,
    this.minAmount,
    this.maxAmount,
    this.fixedAmount,
    this.returnInterest,
    this.returnInterestType,
    this.numberPeriod,
    this.capitalBack,
    this.isAutoRenewal,
    this.autoRenewalSource,
    this.isCancel,
    this.isCompounding,
    this.investAmount,
    this.period,
    this.interest,
    this.interestType,
    this.roiInterestType,
    this.minRoi,
    this.maxRoi,
    this.fixedRoi,
  });

  factory Schema.fromJson(Map<String, dynamic> json) => Schema(
    id: json["id"],
    icon: json["icon"],
    name: json["name"],
    badge: json["badge"],
    holiday: json["holiday"],
    amountRange: json["amount_range"],
    minAmount: json["min_amount"],
    maxAmount: json["max_amount"],
    fixedAmount: json["fixed_amount"],
    returnInterest: json["return_interest"],
    returnInterestType: json["return_interest_type"],
    numberPeriod: json["number_period"],
    capitalBack: json["capital_back"],
    isAutoRenewal: json["is_auto_renewal"],
    autoRenewalSource: json["auto_renew_source"],
    isCancel: json["is_cancel"],
    isCompounding: json["is_compounding"],
    investAmount: json["invest_amount"],
    period: json["period"],
    interest: json["interest"],
    interestType: json["interest_type"],
    roiInterestType: json["roi_interest_type"],
    minRoi: json["min_roi"],
    maxRoi: json["max_roi"],
    fixedRoi: json["fixed_roi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "name": name,
    "badge": badge,
    "holiday": holiday,
    "amount_range": amountRange,
    "min_amount": minAmount,
    "max_amount": maxAmount,
    "fixed_amount": fixedAmount,
    "return_interest": returnInterest,
    "return_interest_type": returnInterestType,
    "number_period": numberPeriod,
    "capital_back": capitalBack,
    "is_auto_renewal": isAutoRenewal,
    "auto_renew_source": autoRenewalSource,
    "is_compounding": isCompounding,
    "is_cancel": isCancel,
    "invest_amount": investAmount,
    "period": period,
    "interest": interest,
    "interest_type": interestType,
    "roi_interest_type": roiInterestType,
    "min_roi": minRoi,
    "max_roi": maxRoi,
    "fixed_roi": fixedRoi,
  };
}
