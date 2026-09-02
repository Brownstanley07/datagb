class AllCrowdSchemaResponseModel {
  bool? status;
  Data? data;

  AllCrowdSchemaResponseModel({this.status, this.data});

  factory AllCrowdSchemaResponseModel.fromJson(Map<String, dynamic> json) =>
      AllCrowdSchemaResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<CrowdSchema>? crowdSchemas;

  Data({this.crowdSchemas});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    crowdSchemas: json["crowdSchemas"] == null
        ? []
        : List<CrowdSchema>.from(
            json["crowdSchemas"]!.map((x) => CrowdSchema.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "crowdSchemas": crowdSchemas == null
        ? []
        : List<dynamic>.from(crowdSchemas!.map((x) => x.toJson())),
  };
}

class CrowdSchema {
  int? id;
  String? icon;
  String? name;
  String? amountRange;
  num? minAmount;
  num? maxAmount;
  num? fixedAmount;
  num? investAmount;
  String? interest;
  String? returnInterest;
  String? interestType;
  String? roiInterestType;
  num? minRoi;
  num? maxRoi;
  num? fixedRoi;
  DateTime? returnDate;
  DateTime? endDate;
  num? totalInvestors;
  num? daysLeft;
  String? returnDateFormat;
  String? endDateFormat;
  num? progressPercentage;
  String? totalCollected;
  String? maxCollection;

  CrowdSchema({
    this.id,
    this.icon,
    this.name,
    this.amountRange,
    this.minAmount,
    this.maxAmount,
    this.fixedAmount,
    this.investAmount,
    this.interest,
    this.returnInterest,
    this.interestType,
    this.roiInterestType,
    this.minRoi,
    this.maxRoi,
    this.fixedRoi,
    this.returnDate,
    this.endDate,
    this.totalInvestors,
    this.daysLeft,
    this.returnDateFormat,
    this.endDateFormat,
    this.progressPercentage,
    this.totalCollected,
    this.maxCollection,
  });

  factory CrowdSchema.fromJson(Map<String, dynamic> json) => CrowdSchema(
    id: json["id"],
    icon: json["icon"],
    name: json["name"],
    amountRange: json["amount_range"],
    minAmount: json["min_amount"],
    maxAmount: json["max_amount"],
    fixedAmount: json["fixed_amount"],
    investAmount: json["invest_amount"],
    interest: json["interest"],
    returnInterest: json["return_interest"],
    interestType: json["interest_type"],
    roiInterestType: json["roi_interest_type"],
    minRoi: json["min_roi"],
    maxRoi: json["max_roi"],
    fixedRoi: json["fixed_roi"],
    returnDate: json["return_date"] == null
        ? null
        : DateTime.parse(json["return_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    totalInvestors: json["total_investors"],
    daysLeft: json["days_left"],
    returnDateFormat: json["return_date_format"],
    endDateFormat: json["end_date_format"],
    progressPercentage: json["progress_percentage"],
    totalCollected: json["total_collected"],
    maxCollection: json["max_collection"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "name": name,
    "amount_range": amountRange,
    "min_amount": minAmount,
    "max_amount": maxAmount,
    "fixed_amount": fixedAmount,
    "invest_amount": investAmount,
    "interest": interest,
    "return_interest": returnInterest,
    "interest_type": interestType,
    "roi_interest_type": roiInterestType,
    "min_roi": minRoi,
    "max_roi": maxRoi,
    "fixed_roi": fixedRoi,
    "return_date": returnDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "total_investors": totalInvestors,
    "days_left": daysLeft,
    "return_date_format": returnDateFormat,
    "end_date_format": endDateFormat,
    "progress_percentage": progressPercentage,
    "total_collected": totalCollected,
    "max_collection": maxCollection,
  };
}
