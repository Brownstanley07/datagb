class NotificationResponseModel {
  bool? status;
  Data? data;
  Meta? meta;

  NotificationResponseModel({this.status, this.data, this.meta});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
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
  Map<String, List<Notifications>>? notifications;

  Data({this.notifications});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: Map.from(json["notifications"]!).map(
      (k, v) => MapEntry<String, List<Notifications>>(
        k,
        List<Notifications>.from(v.map((x) => Notifications.fromJson(x))),
      ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "notifications": Map.from(notifications!).map(
      (k, v) => MapEntry<String, dynamic>(
        k,
        List<dynamic>.from(v.map((x) => x.toJson())),
      ),
    ),
  };
}

class Notifications {
  int? id;
  String? title;
  String? description;
  bool? isRead;
  String? createdAt;

  Notifications({
    this.id,
    this.title,
    this.description,
    this.isRead,
    this.createdAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    title: json["title"],
    description: json["notice"],
    isRead: json["is_read"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "notice": description,
    "is_read": isRead,
    "created_at": createdAt,
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
