class WalletExchangeResponseModel {
  bool? status;
  String? message;
  Data? data;

  WalletExchangeResponseModel({this.status, this.message, this.data});

  factory WalletExchangeResponseModel.fromJson(Map<String, dynamic> json) =>
      WalletExchangeResponseModel(
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
  Wallets? wallets;

  Data({this.transaction, this.wallets});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    wallets: json["wallets"] == null ? null : Wallets.fromJson(json["wallets"]),
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction?.toJson(),
    "wallets": wallets?.toJson(),
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
  dynamic payCurrency;
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

class Wallets {
  Wallet? mainWallet;
  Wallet? profitWallet;

  Wallets({this.mainWallet, this.profitWallet});

  factory Wallets.fromJson(Map<String, dynamic> json) => Wallets(
    mainWallet: json["main_wallet"] == null
        ? null
        : Wallet.fromJson(json["main_wallet"]),
    profitWallet: json["profit_wallet"] == null
        ? null
        : Wallet.fromJson(json["profit_wallet"]),
  );

  Map<String, dynamic> toJson() => {
    "main_wallet": mainWallet?.toJson(),
    "profit_wallet": profitWallet?.toJson(),
  };
}

class Wallet {
  int? id;
  String? name;
  double? balance;

  Wallet({this.id, this.name, this.balance});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    name: json["name"],
    balance: json["balance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "balance": balance};
}
