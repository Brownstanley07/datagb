class InvestResponseModel {
  bool? status;
  String? message;
  Data? data;

  InvestResponseModel({this.status, this.message, this.data});

  factory InvestResponseModel.fromJson(Map<String, dynamic> json) =>
      InvestResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Transaction? transaction;
  Invest? invest;
  Gateway? gateway;

  Data({this.transaction, this.invest, this.gateway});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    invest: json["invest"] == null ? null : Invest.fromJson(json["invest"]),
    gateway: json["gateway"] == null ? null : Gateway.fromJson(json["gateway"]),
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction?.toJson(),
    "invest": invest?.toJson(),
    "gateway": gateway?.toJson(),
  };
}

class Gateway {
  String? redirectUrl;
  bool? isRedirect;

  Gateway({this.redirectUrl, this.isRedirect});

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
    redirectUrl: json["redirect_url"],
    isRedirect: json["is_redirect"],
  );

  Map<String, dynamic> toJson() => {
    "redirect_url": redirectUrl,
    "is_redirect": isRedirect,
  };
}

class Invest {
  int? id;
  String? investAmount;
  num? interest;
  String? interestType;
  String? returnType;
  String? returnInterestType;
  int? numberOfPeriod;
  dynamic lastProfitTime;
  DateTime? nextProfitTime;
  String? wallet;
  String? status;
  bool? isAutoRenewal;
  bool? isCompounding;
  DateTime? createdAt;
  DateTime? updatedAt;

  Invest({
    this.id,
    this.investAmount,
    this.interest,
    this.interestType,
    this.returnType,
    this.returnInterestType,
    this.numberOfPeriod,
    this.lastProfitTime,
    this.nextProfitTime,
    this.wallet,
    this.status,
    this.isAutoRenewal,
    this.isCompounding,
    this.createdAt,
    this.updatedAt,
  });

  factory Invest.fromJson(Map<String, dynamic> json) => Invest(
    id: json["id"],
    investAmount: json["invest_amount"],
    interest: json["interest"],
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
    isAutoRenewal: json["is_auto_renewal"],
    isCompounding: json["is_compounding"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invest_amount": investAmount,
    "interest": interest,
    "interest_type": interestType,
    "return_type": returnType,
    "return_interest_type": returnInterestType,
    "number_of_period": numberOfPeriod,
    "last_profit_time": lastProfitTime,
    "next_profit_time": nextProfitTime?.toIso8601String(),
    "wallet": wallet,
    "status": status,
    "is_auto_renewal": isAutoRenewal,
    "is_compounding": isCompounding,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Transaction {
  int? id;
  String? description;
  String? tnx;
  bool? isPlus;
  String? type;
  String? amount;
  String? charge;
  String? finalAmount;
  String? status;
  String? method;
  String? payCurrency;
  String? createdAt;
  String? date;
  String? time;

  Transaction({
    this.id,
    this.description,
    this.tnx,
    this.isPlus,
    this.type,
    this.amount,
    this.charge,
    this.finalAmount,
    this.status,
    this.method,
    this.payCurrency,
    this.createdAt,
    this.date,
    this.time,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    description: json["description"],
    tnx: json["tnx"],
    isPlus: json["is_plus"],
    type: json["type"],
    amount: json["amount"],
    charge: json["charge"],
    finalAmount: json["final_amount"],
    status: json["status"],
    method: json["method"],
    payCurrency: json["pay_currency"],
    createdAt: json["created_at"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "tnx": tnx,
    "is_plus": isPlus,
    "type": type,
    "amount": amount,
    "charge": charge,
    "final_amount": finalAmount,
    "status": status,
    "method": method,
    "pay_currency": payCurrency,
    "created_at": createdAt,
    "date": date,
    "time": time,
  };
}
