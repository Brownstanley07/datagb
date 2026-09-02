class TicketMessageResponseModel {
  bool? status;
  MessageData? data;

  TicketMessageResponseModel({this.status, this.data});

  factory TicketMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      TicketMessageResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : MessageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class MessageData {
  MessageTicket? ticket;
  List<Message>? messages;

  MessageData({this.ticket, this.messages});

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
    ticket: json["ticket"] == null
        ? null
        : MessageTicket.fromJson(json["ticket"]),
    messages: json["messages"] == null
        ? []
        : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ticket": ticket?.toJson(),
    "messages": messages == null
        ? []
        : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  int? id;
  String? message;
  String? avatar;
  String? name;
  String? email;
  bool? isAdmin;
  String? attachment;
  String? createdAt;

  Message({
    this.id,
    this.message,
    this.avatar,
    this.name,
    this.email,
    this.isAdmin,
    this.attachment,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    message: json["message"],
    avatar: json["avatar"],
    name: json["name"],
    email: json["email"],
    isAdmin: json["is_admin"],
    attachment: json["attachment"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "avatar": avatar,
    "name": name,
    "email": email,
    "is_admin": isAdmin,
    "attachment": attachment,
    "created_at": createdAt,
  };
}

class MessageTicket {
  int? id;
  String? uuid;
  User? user;
  String? title;
  String? message;
  String? priority;
  String? status;
  String? lastReply;
  String? attachment;
  String? createdAt;

  MessageTicket({
    this.id,
    this.uuid,
    this.user,
    this.title,
    this.message,
    this.priority,
    this.status,
    this.lastReply,
    this.attachment,
    this.createdAt,
  });

  factory MessageTicket.fromJson(Map<String, dynamic> json) => MessageTicket(
    id: json["id"],
    uuid: json["uuid"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    title: json["title"],
    message: json["message"],
    priority: json["priority"],
    status: json["status"],
    lastReply: json["last_reply"],
    attachment: json["attachment"],
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
    "attachment": attachment,
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
