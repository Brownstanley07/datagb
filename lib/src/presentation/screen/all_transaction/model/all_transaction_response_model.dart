class AllTransactionResponseModel {
  bool? status;
  Data? data;
  Meta? meta;

  AllTransactionResponseModel({this.status, this.data, this.meta});

  factory AllTransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      AllTransactionResponseModel(
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
  List<Transaction>? transactions;

  Data({this.transactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactions: json["transactions"] == null
        ? []
        : List<Transaction>.from(
            json["transactions"]!.map((x) => Transaction.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "transactions": transactions == null
        ? []
        : List<dynamic>.from(transactions!.map((x) => x.toJson())),
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
