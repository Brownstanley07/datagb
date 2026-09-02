class RankingBadgeResponseModel {
  bool? status;
  Data? data;

  RankingBadgeResponseModel({this.status, this.data});

  factory RankingBadgeResponseModel.fromJson(Map<String, dynamic> json) =>
      RankingBadgeResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<Ranking>? ranking;

  Data({this.ranking});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ranking: json["ranking"] == null
        ? []
        : List<Ranking>.from(json["ranking"]!.map((x) => Ranking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ranking": ranking == null
        ? []
        : List<dynamic>.from(ranking!.map((x) => x.toJson())),
  };
}

class Ranking {
  String? name;
  String? icon;
  String? description;
  bool? isLocked;

  Ranking({this.name, this.icon, this.description, this.isLocked});

  factory Ranking.fromJson(Map<String, dynamic> json) => Ranking(
    name: json["name"],
    icon: json["icon"],
    description: json["description"],
    isLocked: json["is_locked"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "icon": icon,
    "description": description,
    "is_locked": isLocked,
  };
}
