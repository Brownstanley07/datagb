class WalletResponseModel {
  bool? status;
  Data? data;

  WalletResponseModel({this.status, this.data});

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) =>
      WalletResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Settings? settings;
  Wallets? wallets;

  Data({this.settings, this.wallets});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    settings: json["settings"] == null
        ? null
        : Settings.fromJson(json["settings"]),
    wallets: json["wallets"] == null ? null : Wallets.fromJson(json["wallets"]),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings?.toJson(),
    "wallets": wallets?.toJson(),
  };
}

class Settings {
  String? chargeType;
  String? charge;
  dynamic minAmount;
  dynamic maxAmount;
  int? dayLimit;
  dynamic status;

  Settings({
    this.chargeType,
    this.charge,
    this.minAmount,
    this.maxAmount,
    this.dayLimit,
    this.status,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    chargeType: json["charge_type"],
    charge: json["charge"],
    minAmount: json["min_amount"],
    maxAmount: json["max_amount"],
    dayLimit: json["day_limit"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "charge_type": chargeType,
    "charge": charge,
    "min_amount": minAmount,
    "max_amount": maxAmount,
    "day_limit": dayLimit,
    "status": status,
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
