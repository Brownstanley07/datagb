class ReferralResponseModel {
  bool? status;
  Data? data;

  ReferralResponseModel({this.status, this.data});

  factory ReferralResponseModel.fromJson(Map<String, dynamic> json) =>
      ReferralResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  String? text;
  String? code;
  String? link;
  num? joinedText;
  Tree? tree;
  String? totalReferralPoint;
  ReferralLogs? referralLogs;

  Data({
    this.text,
    this.code,
    this.link,
    this.joinedText,
    this.tree,
    this.totalReferralPoint,
    this.referralLogs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    text: json["text"],
    code: json["code"],
    link: json["link"],
    joinedText: json["joined_text"],
    tree: json["tree"] == null ? null : Tree.fromJson(json["tree"]),
    totalReferralPoint: json["total_referral_point"],
    referralLogs: json["referral_logs"] == null
        ? null
        : ReferralLogs.fromJson(json["referral_logs"]),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "link": link,
    "code": code,
    "joined_text": joinedText,
    "tree": tree?.toJson(),
    "total_referral_point": totalReferralPoint,
    "referral_logs": referralLogs?.toJson(),
  };
}

class ReferralLogs {
  List<General>? general;
  List<Targeted>? targeted;

  ReferralLogs({this.general, this.targeted});

  factory ReferralLogs.fromJson(Map<String, dynamic> json) => ReferralLogs(
    general: json["general"] == null
        ? []
        : List<General>.from(json["general"]!.map((x) => General.fromJson(x))),
    targeted: json["targeted"] == null
        ? []
        : List<Targeted>.from(
            json["targeted"]!.map((x) => Targeted.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "general": general == null
        ? []
        : List<dynamic>.from(general!.map((x) => x.toJson())),
    "targeted": targeted == null
        ? []
        : List<dynamic>.from(targeted!.map((x) => x.toJson())),
  };
}

class General {
  String? description;
  String? tnx;
  String? type;
  String? amount;
  String? status;
  String? createdAt;

  General({
    this.description,
    this.tnx,
    this.type,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory General.fromJson(Map<String, dynamic> json) => General(
    description: json["description"],
    tnx: json["tnx"],
    type: json["type"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "tnx": tnx,
    "type": type,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
  };
}

class Targeted {
  Target? target;
  String? totalAmount;
  List<General>? transactions;

  Targeted({this.target, this.totalAmount, this.transactions});

  factory Targeted.fromJson(Map<String, dynamic> json) => Targeted(
    target: json["target"] == null ? null : Target.fromJson(json["target"]),
    totalAmount: json["total_amount"],
    transactions: json["transactions"] == null
        ? []
        : List<General>.from(
            json["transactions"]!.map((x) => General.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "target": target?.toJson(),
    "total_amount": totalAmount,
    "transactions": transactions == null
        ? []
        : List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Target {
  int? id;
  String? type;
  String? theOrder;
  num? bounty;
  DateTime? createdAt;
  DateTime? updatedAt;

  Target({
    this.id,
    this.type,
    this.theOrder,
    this.bounty,
    this.createdAt,
    this.updatedAt,
  });

  factory Target.fromJson(Map<String, dynamic> json) => Target(
    id: json["id"],
    type: json["type"],
    theOrder: json["the_order"],
    bounty: json["bounty"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "the_order": theOrder,
    "bounty": bounty,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Tree {
  int? id;
  String? name;
  String? avatar;
  bool? isChild;
  bool? isMe;
  num? depth;
  String? deposit;
  String? investment;
  String? roiProfit;
  List<Tree>? children;

  Tree({
    this.id,
    this.name,
    this.avatar,
    this.isChild,
    this.isMe,
    this.depth,
    this.deposit,
    this.investment,
    this.roiProfit,
    this.children,
  });

  factory Tree.fromJson(Map<String, dynamic> json) => Tree(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    isChild: json["is_child"],
    isMe: json["is_me"],
    depth: json["depth"],
    deposit: json["deposit"],
    investment: json["investment"],
    roiProfit: json["roi_profit"],
    children: json["children"] == null
        ? []
        : List<Tree>.from(json["children"]!.map((x) => Tree.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "is_child": isChild,
    "is_me": isMe,
    "depth": depth,
    "deposit": deposit,
    "investment": investment,
    "roi_profit": roiProfit,
    "children": children == null
        ? []
        : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}
