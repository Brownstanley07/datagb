class TicketResponseModel {
  bool? status;
  Data? data;
  Meta? meta;

  TicketResponseModel({this.status, this.data, this.meta});

  factory TicketResponseModel.fromJson(Map<String, dynamic> json) =>
      TicketResponseModel(
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
  List<Ticket>? tickets;

  Data({this.tickets});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tickets: json["tickets"] == null
        ? []
        : List<Ticket>.from(json["tickets"]!.map((x) => Ticket.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tickets": tickets == null
        ? []
        : List<dynamic>.from(tickets!.map((x) => x.toJson())),
  };
}

class Ticket {
  int? id;
  String? uuid;
  User? user;
  String? title;
  String? message;
  String? priority;
  String? status;
  String? lastReply;
  String? attachments;
  String? createdAt;

  Ticket({
    this.id,
    this.uuid,
    this.user,
    this.title,
    this.message,
    this.priority,
    this.status,
    this.lastReply,
    this.attachments,
    this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    uuid: json["uuid"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    title: json["title"],
    message: json["message"],
    priority: json["priority"],
    status: json["status"],
    lastReply: json["last_reply"],
    attachments: json["attachments"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "user": user?.toJson(),
    "title": title,
    "message": message,
    "priority": priority,
    "status": status,
    "last_reply": lastReply,
    "attachments": attachments,
    "created_at": createdAt,
  };
}

class User {
  String? name;
  String? email;
  String? avatar;

  User({this.name, this.email, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json["name"], email: json["email"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "avatar": avatar,
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
