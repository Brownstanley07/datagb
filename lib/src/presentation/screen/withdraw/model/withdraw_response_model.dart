class WithdrawResponseModel {
  bool? status;
  String? message;
  WithdrawData? data;

  WithdrawResponseModel({this.status, this.message, this.data});

  factory WithdrawResponseModel.fromJson(Map<String, dynamic> json) =>
      WithdrawResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : WithdrawData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class WithdrawData {
  Transaction? transaction;
  Gateway? gateway;

  WithdrawData({this.transaction, this.gateway});

  factory WithdrawData.fromJson(Map<String, dynamic> json) => WithdrawData(
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    gateway: json["gateway"] == null ? null : Gateway.fromJson(json["gateway"]),
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction?.toJson(),
    "gateway": gateway?.toJson(),
  };
}

class Gateway {
  dynamic redirectUrl;
  bool? isRedirect;
  String? status;
  String? message;
  String? reference;

  Gateway({
    this.redirectUrl,
    this.isRedirect,
    this.status,
    this.message,
    this.reference,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
    redirectUrl: json["redirect_url"],
    isRedirect: json["is_redirect"],
    status: json["status"],
    message: json["message"],
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "redirect_url": redirectUrl,
    "is_redirect": isRedirect,
    "status": status,
    "message": message,
    "reference": reference,
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
