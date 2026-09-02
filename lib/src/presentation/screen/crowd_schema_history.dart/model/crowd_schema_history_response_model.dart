class CrowdSchemaHistoryResponseModel {
  bool? status;
  Data? data;
  Meta? meta;

  CrowdSchemaHistoryResponseModel({this.status, this.data, this.meta});

  factory CrowdSchemaHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CrowdSchemaHistoryResponseModel(
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
  List<CrowdInvest>? crowdInvests;

  Data({this.crowdInvests});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    crowdInvests: json["crowdInvests"] == null
        ? []
        : List<CrowdInvest>.from(
            json["crowdInvests"]!.map((x) => CrowdInvest.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "crowdInvests": crowdInvests == null
        ? []
        : List<dynamic>.from(crowdInvests!.map((x) => x.toJson())),
  };
}

class CrowdInvest {
  int? id;
  num? investAmount;
  num? interest;
  String? roi;
  String? profitAmount;
  String? interestType;
  String? wallet;
  String? status;
  String? createdAtDateFormat;
  String? createdAtTimeFormat;
  String? createdAtFormat;
  DateTime? createdAt;
  DateTime? updatedAt;
  CrowdSchema? crowdSchema;

  CrowdInvest({
    this.id,
    this.investAmount,
    this.interest,
    this.profitAmount,
    this.roi,
    this.interestType,
    this.wallet,
    this.status,
    this.createdAtDateFormat,
    this.createdAtTimeFormat,
    this.createdAtFormat,
    this.createdAt,
    this.updatedAt,
    this.crowdSchema,
  });

  factory CrowdInvest.fromJson(Map<String, dynamic> json) => CrowdInvest(
    id: json["id"],
    investAmount: json["invest_amount"]?.toDouble(),
    interest: json["interest"]?.toDouble(),
    roi: json["roi"],
    profitAmount: json["profit_amount"],
    interestType: json["interest_type"],
    wallet: json["wallet"],
    status: json["status"],

    createdAtDateFormat: json["created_at_date_format"],
    createdAtTimeFormat: json["created_at_time_format"],
    createdAtFormat: json["created_at_format"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    crowdSchema: json["crowdSchema"] == null
        ? null
        : CrowdSchema.fromJson(json["crowdSchema"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invest_amount": investAmount,
    "interest": interest,
    "roi": roi,
    "profit_amount": profitAmount,
    "interest_type": interestType,
    "wallet": wallet,
    "status": status,
    "created_at_date_format": createdAtDateFormat,
    "created_at_time_format": createdAtTimeFormat,
    "created_at_format": createdAtFormat,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "crowdSchema": crowdSchema?.toJson(),
  };
}

class CrowdSchema {
  int? id;
  String? icon;
  String? name;
  String? badge;
  String? amountRange;
  num? minAmount;
  num? maxAmount;
  num? fixedAmount;
  num? investAmount;
  String? interest;
  String? interestType;
  String? roiInterestType;
  num? minRoi;
  num? maxRoi;
  num? fixedRoi;
  DateTime? returnDate;
  String? returnDateFormat;
  dynamic endDate;
  num? totalInvestors;
  num? daysLeft;
  num? progressPercentage;
  String? totalCollected;
  String? maxCollection;

  CrowdSchema({
    this.id,
    this.icon,
    this.name,
    this.badge,
    this.amountRange,
    this.minAmount,
    this.maxAmount,
    this.fixedAmount,
    this.investAmount,
    this.interest,
    this.interestType,
    this.roiInterestType,
    this.minRoi,
    this.maxRoi,
    this.fixedRoi,
    this.returnDate,
    this.returnDateFormat,
    this.endDate,
    this.totalInvestors,
    this.daysLeft,
    this.progressPercentage,
    this.totalCollected,
    this.maxCollection,
  });

  factory CrowdSchema.fromJson(Map<String, dynamic> json) => CrowdSchema(
    id: json["id"],
    icon: json["icon"],
    name: json["name"],
    badge: json["badge"],
    amountRange: json["amount_range"],
    minAmount: json["min_amount"],
    maxAmount: json["max_amount"],
    fixedAmount: json["fixed_amount"],
    investAmount: json["invest_amount"],
    interest: json["interest"],
    interestType: json["interest_type"],
    roiInterestType: json["roi_interest_type"],
    minRoi: json["min_roi"],
    maxRoi: json["max_roi"],
    fixedRoi: json["fixed_roi"],
    returnDate: json["return_date"] == null
        ? null
        : DateTime.parse(json["return_date"]),
    returnDateFormat: json["return_date_format"],
    endDate: json["end_date"],
    totalInvestors: json["total_investors"],
    daysLeft: json["days_left"],
    progressPercentage: json["progress_percentage"]?.toDouble(),
    totalCollected: json["total_collected"],
    maxCollection: json["max_collection"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "name": name,
    "badge": badge,
    "amount_range": amountRange,
    "min_amount": minAmount,
    "max_amount": maxAmount,
    "fixed_amount": fixedAmount,
    "invest_amount": investAmount,
    "interest": interest,
    "interest_type": interestType,
    "roi_interest_type": roiInterestType,
    "min_roi": minRoi,
    "max_roi": maxRoi,
    "fixed_roi": fixedRoi,
    "return_date": returnDate?.toIso8601String(),
    "return_date_format": returnDateFormat,
    "end_date": endDate,
    "total_investors": totalInvestors,
    "days_left": daysLeft,
    "progress_percentage": progressPercentage,
    "total_collected": totalCollected,
    "max_collection": maxCollection,
  };
}

class Meta {
  num? currentPage;
  num? lastPage;
  num? perPage;
  num? total;

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
