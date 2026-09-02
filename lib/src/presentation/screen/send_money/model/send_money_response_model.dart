class SendMoneyResponseModel {
  bool? status;
  String? message;
  Data? data;

  SendMoneyResponseModel({this.status, this.message, this.data});

  factory SendMoneyResponseModel.fromJson(Map<String, dynamic> json) =>
      SendMoneyResponseModel(
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

  Data({this.transaction});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
  );

  Map<String, dynamic> toJson() => {"transaction": transaction?.toJson()};
}

class Transaction {
  String? description;
  String? tnx;
  bool? isPlus;
  String? type;
  String? amount;
  String? charge;
  String? finalAmount;
  String? status;
  String? method;
  String? createdAt;

  Transaction({
    this.description,
    this.tnx,
    this.isPlus,
    this.type,
    this.amount,
    this.charge,
    this.finalAmount,
    this.status,
    this.method,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    description: json["description"],
    tnx: json["tnx"],
    isPlus: json["is_plus"],
    type: json["type"],
    amount: json["amount"],
    charge: json["charge"],
    finalAmount: json["final_amount"],
    status: json["status"],
    method: json["method"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "tnx": tnx,
    "is_plus": isPlus,
    "type": type,
    "amount": amount,
    "charge": charge,
    "final_amount": finalAmount,
    "status": status,
    "method": method,
    "created_at": createdAt,
  };
}
