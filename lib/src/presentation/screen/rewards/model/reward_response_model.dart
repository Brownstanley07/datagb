class RewardResponseModel {
  bool? status;
  Data? data;

  RewardResponseModel({this.status, this.data});

  factory RewardResponseModel.fromJson(Map<String, dynamic> json) =>
      RewardResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  Rewards? rewards;

  Data({this.rewards});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    rewards: json["rewards"] == null ? null : Rewards.fromJson(json["rewards"]),
  );

  Map<String, dynamic> toJson() => {"rewards": rewards?.toJson()};
}

class Rewards {
  int? points;
  bool? isRanking;
  String? ranking;
  String? rankingIcon;
  String? text;
  int? claimThreshold;
  PendingClaim? pendingClaim;
  List<Earning>? earnings;
  List<Earning>? redeems;

  Rewards({
    this.points,
    this.isRanking,
    this.ranking,
    this.rankingIcon,
    this.text,
    this.claimThreshold,
    this.pendingClaim,
    this.earnings,
    this.redeems,
  });

  factory Rewards.fromJson(Map<String, dynamic> json) => Rewards(
    points: json["points"],
    isRanking: json["is_ranking"],
    ranking: json["ranking"],
    rankingIcon: json["ranking_icon"],
    text: json["text"],
    claimThreshold: json["claim_threshold"],
    pendingClaim: json["pending_claim"] == null
        ? null
        : PendingClaim.fromJson(json["pending_claim"]),
    earnings: json["earnings"] == null
        ? []
        : List<Earning>.from(json["earnings"]!.map((x) => Earning.fromJson(x))),
    redeems: json["redeems"] == null
        ? []
        : List<Earning>.from(json["redeems"]!.map((x) => Earning.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "points": points,
    "is_ranking": isRanking,
    "ranking": ranking,
    "ranking_icon": rankingIcon,
    "text": text,
    "claim_threshold": claimThreshold,
    "pending_claim": pendingClaim?.toJson(),
    "earnings": earnings == null
        ? []
        : List<dynamic>.from(earnings!.map((x) => x.toJson())),
    "redeems": redeems == null
        ? []
        : List<dynamic>.from(redeems!.map((x) => x.toJson())),
  };
}

class PendingClaim {
  int? megabytes;
  String? network;
  String? phoneNumber;
  String? status;

  PendingClaim({this.megabytes, this.network, this.phoneNumber, this.status});

  factory PendingClaim.fromJson(Map<String, dynamic> json) => PendingClaim(
    megabytes: json['megabytes'],
    network: json['network'],
    phoneNumber: json['phone_number'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'megabytes': megabytes,
    'network': network,
    'phone_number': phoneNumber,
    'status': status,
  };
}

class Earning {
  String? ranking;
  String? rankingIcon;
  String? rankingLevel;
  String? amountOfTransactions;
  String? point;
  String? amount;

  Earning({
    this.ranking,
    this.rankingIcon,
    this.rankingLevel,
    this.amountOfTransactions,
    this.point,
    this.amount,
  });

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
    ranking: json["ranking"],
    rankingIcon: json["ranking_icon"],
    rankingLevel: json["ranking_level"],
    amountOfTransactions: json["amount_of_transactions"],
    point: json["point"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "ranking": ranking,
    "ranking_icon": rankingIcon,
    "ranking_level": rankingLevel,
    "amount_of_transactions": amountOfTransactions,
    "point": point,
    "amount": amount,
  };
}
