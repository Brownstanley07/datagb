import '../../all_schema/model/all_schema_response_model.dart';

class HomePageResponseModel {
  bool? status;
  Data? data;

  HomePageResponseModel({this.status, this.data});

  factory HomePageResponseModel.fromJson(Map<String, dynamic> json) =>
      HomePageResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  String? kycStatus;
  String? welcomeText;
  UserInfo? userInfo;
  int? totalNotifications;
  Ranking? ranking;
  Wallets? wallets;
  List<Schema>? schemas;
  Map<String, double>? dataCount;
  List<RecentTransaction>? recentTransactions;
  RecentTransaction? pendingDeposit;
  Referral? referral;
  PendingCapitalClaim? pendingCapitalClaim;

  Data({
    this.kycStatus,
    this.welcomeText,
    this.userInfo,
    this.totalNotifications,
    this.ranking,
    this.wallets,
    this.schemas,
    this.dataCount,
    this.recentTransactions,
    this.pendingDeposit,
    this.referral,
    this.pendingCapitalClaim,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    kycStatus: json["kyc_status"],
    welcomeText: json["welcomeText"],
    userInfo: json["userInfo"] == null
        ? null
        : UserInfo.fromJson(json["userInfo"]),
    totalNotifications: json["totalNotifications"],
    ranking: json["ranking"] == null ? null : Ranking.fromJson(json["ranking"]),
    wallets: json["wallets"] == null ? null : Wallets.fromJson(json["wallets"]),
    schemas: json["schemas"] == null
        ? []
        : List<Schema>.from(json["schemas"]!.map((x) => Schema.fromJson(x))),
    dataCount: Map.from(
      json["dataCount"]!,
    ).map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
    recentTransactions: json["recentTransactions"] == null
        ? []
        : List<RecentTransaction>.from(
            json["recentTransactions"]!.map(
              (x) => RecentTransaction.fromJson(x),
            ),
          ),
    pendingDeposit: json["pendingDeposit"] == null
        ? null
        : RecentTransaction.fromJson(json["pendingDeposit"]),
    referral: json["referral"] == null
        ? null
        : Referral.fromJson(json["referral"]),
    pendingCapitalClaim:
        (json['pending_capital_claim'] ?? json['pendingCapitalClaim']) == null
        ? null
        : PendingCapitalClaim.fromJson(
            json['pending_capital_claim'] ?? json['pendingCapitalClaim'],
          ),
  );

  Map<String, dynamic> toJson() => {
    "kyc_status": kycStatus,
    "welcomeText": welcomeText,
    "userInfo": userInfo?.toJson(),
    "totalNotifications": totalNotifications,
    "ranking": ranking?.toJson(),
    "wallets": wallets?.toJson(),
    "schemas": schemas == null
        ? []
        : List<dynamic>.from(schemas!.map((x) => x.toJson())),
    "dataCount": Map.from(
      dataCount!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "recentTransactions": recentTransactions == null
        ? []
        : List<dynamic>.from(recentTransactions!.map((x) => x.toJson())),
    "pendingDeposit": pendingDeposit?.toJson(),
    "referral": referral?.toJson(),
  };
}

class PendingCapitalClaim {
  num? amount;
  DateTime? availableAt;
  PendingCapitalClaim({this.amount, this.availableAt});
  factory PendingCapitalClaim.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    return PendingCapitalClaim(
      // Laravel decimal casts are serialized as strings. Accept both that
      // representation and numeric JSON so one redemption cannot make the
      // entire dashboard response fail to parse after login.
      amount: rawAmount is num
          ? rawAmount
          : num.tryParse(rawAmount?.toString() ?? ''),
      availableAt: json['available_at'] == null
          ? null
          : DateTime.tryParse(json['available_at']),
    );
  }
}

class Ranking {
  String? icon;
  String? level;
  String? name;

  Ranking({this.icon, this.level, this.name});

  factory Ranking.fromJson(Map<String, dynamic> json) =>
      Ranking(icon: json["icon"], level: json["level"], name: json["name"]);

  Map<String, dynamic> toJson() => {"icon": icon, "level": level, "name": name};
}

class RecentTransaction {
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

  RecentTransaction({
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

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
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

class Referral {
  int? id;
  int? userId;
  int? referralProgramId;
  String? code;
  DateTime? createdAt;
  DateTime? updatedAt;

  Referral({
    this.id,
    this.userId,
    this.referralProgramId,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
    id: json["id"],
    userId: json["user_id"],
    referralProgramId: json["referral_program_id"],
    code: json["code"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "referral_program_id": referralProgramId,
    "code": code,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class UserInfo {
  String? name;
  String? email;
  String? image;

  UserInfo({this.name, this.email, this.image});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      UserInfo(name: json["name"], email: json["email"], image: json["image"]);

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "image": image,
  };
}

class Wallets {
  String? mainWallet;
  String? profitWallet;

  Wallets({this.mainWallet, this.profitWallet});

  factory Wallets.fromJson(Map<String, dynamic> json) => Wallets(
    mainWallet: json["main_wallet"],
    profitWallet: json["profit_wallet"],
  );

  Map<String, dynamic> toJson() => {
    "main_wallet": mainWallet,
    "profit_wallet": profitWallet,
  };
}
