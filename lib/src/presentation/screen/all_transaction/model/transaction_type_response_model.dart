class TransactionTypeResponseModel {
  bool? status;
  Data? data;

  TransactionTypeResponseModel({this.status, this.data});

  factory TransactionTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      TransactionTypeResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  List<TransactionType>? transactionTypes;

  Data({this.transactionTypes});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactionTypes: json["transaction_types"] == null
        ? []
        : List<TransactionType>.from(
            json["transaction_types"]!.map((x) => TransactionType.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "transaction_types": transactionTypes == null
        ? []
        : List<dynamic>.from(transactionTypes!.map((x) => x.toJson())),
  };
}

class TransactionType {
  String? name;
  String? value;

  TransactionType({this.name, this.value});

  factory TransactionType.fromJson(Map<String, dynamic> json) =>
      TransactionType(name: json["name"], value: json["value"]);

  Map<String, dynamic> toJson() => {"name": name, "value": value};
}
