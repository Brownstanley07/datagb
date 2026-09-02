class SchemaHistoryResponseModel {
  bool? status;
  Data? data;
  Meta? meta;

  SchemaHistoryResponseModel({this.status, this.data, this.meta});

  factory SchemaHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      SchemaHistoryResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Data {
  List<Invest>? invests;

  Data({this.invests});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    invests: json["invests"] == null
        ? []
        : List<Invest>.from(json["invests"]!.map((x) => Invest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "invests": invests == null
        ? []
        : List<dynamic>.from(invests!.map((x) => x.toJson())),
  };
}

class Invest {
  int? id;
  num? investAmount;
  num? interest;
  String? roi;
  String? profitText;
  String? periodRemaining;
  String? interestType;
  String? returnType;
  String? returnInterestType;
  num? numberOfPeriod;
  dynamic lastProfitTime;
  DateTime? nextProfitTime;
  String? wallet;
  String? status;
  bool? isCancel;
  bool? isAutoRenewal;
  bool? isCompounding;
  DateTime? createdAt;
  String? createdAtFormat;
  String? createAtDateFormat;
  String? createAtTimeFormat;
  DateTime? updatedAt;
  Schema? schema;

  Invest({
    this.id,
    this.investAmount,
    this.interest,
    this.roi,
    this.profitText,
    this.periodRemaining,
    this.interestType,
    this.returnType,
    this.returnInterestType,
    this.numberOfPeriod,
    this.lastProfitTime,
    this.nextProfitTime,
    this.wallet,
    this.status,
    this.isCancel,
    this.isAutoRenewal,
    this.isCompounding,
    this.createdAt,
    this.createdAtFormat,
    this.createAtDateFormat,
    this.createAtTimeFormat,
    this.updatedAt,
    this.schema,
  });

  factory Invest.fromJson(Map<String, dynamic> json) => Invest(
    id: json["id"],
    investAmount: json["invest_amount"],
    interest: json["interest"],
    roi: json["roi"],
    profitText: json["profit_text"],
    periodRemaining: json["period_remaining"],
    interestType: json["interest_type"],
    returnType: json["return_type"],
    returnInterestType: json["return_interest_type"],
    numberOfPeriod: json["number_of_period"],
    lastProfitTime: json["last_profit_time"],
    nextProfitTime: json["next_profit_time"] == null
        ? null
        : DateTime.parse(json["next_profit_time"]),
    wallet: json["wallet"],
    status: json["status"],
    isCancel: json["is_cancel"],
    isAutoRenewal: json["is_auto_renewal"],
    isCompounding: json["is_compounding"],

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAtFormat: json["created_at_format"],
    createAtDateFormat: json["created_at_date_format"],
    createAtTimeFormat: json["created_at_time_format"],
    schema: json["schema"] == null ? null : Schema.fromJson(json["schema"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invest_amount": investAmount,
    "interest": interest,
    "roi": roi,
    "profit_text": profitText,
    "period_remaining": periodRemaining,
    "interest_type": interestType,
    "return_type": returnType,
    "return_interest_type": returnInterestType,
    "number_of_period": numberOfPeriod,
    "last_profit_time": lastProfitTime,
    "next_profit_time": nextProfitTime?.toIso8601String(),
    "wallet": wallet,
    "status": status,
    "is_cancel": isCancel,
    "is_auto_renewal": isAutoRenewal,
    "is_compounding": isCompounding,
    "created_at": createdAt?.toIso8601String(),
    "created_at_format": createdAtFormat,
    "updated_at": updatedAt?.toIso8601String(),
    "schema": schema?.toJson(),
  };
}

class Schema {
  int? id;
  String? icon;
  String? name;
  String? badge;
  String? holiday;
  String? amountRange;
  num? minAmount;
  num? maxAmount;
  num? fixedAmount;
  String? returnInterest;
  String? returnInterestType;
  String? numberPeriod;
  bool? capitalBack;
  bool? isAutoRenewal;
  bool? isCompounding;
  num? investAmount;
  num? period;
  String? interest;
  String? interestType;
  String? roiInterestType;
  num? minRoi;
  num? maxRoi;
  num? fixedRoi;

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
    "is_compounding": isCompounding,
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

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}
