num? _flagValue(dynamic value) {
  if (value is bool) return value ? 1 : 0;
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '');
}

class UserResponseModel {
  bool? status;
  Data? data;

  UserResponseModel({this.status, this.data});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  User? user;

  Data({this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(user: json["user"] == null ? null : User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"user": user?.toJson()};
}

class User {
  int? id;
  dynamic rankingId;
  String? avatar;
  String? firstName;
  String? lastName;
  String? country;
  String? phone;
  String? username;
  String? email;
  String? gender;
  dynamic dateOfBirth;
  dynamic city;
  dynamic zipCode;
  dynamic address;
  num? balance;
  dynamic points;
  num? profitBalance;
  num? status;
  dynamic refId;
  num? kyc;
  dynamic kycCredential;
  bool? twoFa;
  num? depositStatus;
  num? withdrawStatus;
  num? rewardStatus;
  num? transferStatus;
  dynamic emailVerifiedAt;
  List<CustomFieldsDatum>? customFieldsData;
  DateTime? createdAt;
  String? updatedAt;
  String? fullName;
  String? kycTime;
  String? kycType;
  String? totalProfit;
  String? totalDeposit;
  String? totalInvest;
  bool? the2FaInitialized;
  bool? isUnreadNotification;
  String? the2FaQrCode;

  User({
    this.id,
    this.rankingId,
    this.avatar,
    this.firstName,
    this.lastName,
    this.country,
    this.phone,
    this.username,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.zipCode,
    this.address,
    this.balance,
    this.points,
    this.profitBalance,
    this.status,
    this.refId,
    this.kyc,
    this.kycCredential,
    this.twoFa,
    this.depositStatus,
    this.withdrawStatus,
    this.rewardStatus,
    this.transferStatus,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.customFieldsData,
    this.fullName,
    this.kycTime,
    this.kycType,
    this.totalProfit,
    this.totalDeposit,
    this.totalInvest,
    this.the2FaInitialized,
    this.isUnreadNotification,
    this.the2FaQrCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    rankingId: json["ranking_id"],
    avatar: json["avatar"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    country: json["country"],
    phone: json["phone"],
    username: json["username"],
    email: json["email"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    city: json["city"],
    zipCode: json["zip_code"],
    address: json["address"],
    balance: json["balance"],
    points: json["points"],
    profitBalance: json["profit_balance"],
    status: _flagValue(json["status"]),
    refId: json["ref_id"],
    kyc: _flagValue(json["kyc"]),
    kycCredential: json["kyc_credential"],
    twoFa: json["two_fa"],
    depositStatus: _flagValue(json["deposit_status"]),
    withdrawStatus: _flagValue(json["withdraw_status"]),
    rewardStatus: _flagValue(json["reward_status"]),
    transferStatus: _flagValue(json["transfer_status"]),
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    customFieldsData: json["custom_fields_data"] == null
        ? []
        : List<CustomFieldsDatum>.from(
            json["custom_fields_data"]!.map(
              (x) => CustomFieldsDatum.fromJson(x),
            ),
          ),
    updatedAt: json["updated_at"],
    fullName: json["full_name"],
    kycTime: json["kyc_time"],
    kycType: json["kyc_type"],
    totalProfit: json["total_profit"],
    totalDeposit: json["total_deposit"],
    totalInvest: json["total_invest"],
    the2FaInitialized: json["2fa_initialized"],
    isUnreadNotification: json["is_unread_notification"],
    the2FaQrCode: json["2fa_qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ranking_id": rankingId,
    "avatar": avatar,
    "first_name": firstName,
    "last_name": lastName,
    "country": country,
    "phone": phone,
    "username": username,
    "email": email,
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "city": city,
    "zip_code": zipCode,
    "address": address,
    "balance": balance,
    "points": points,
    "profit_balance": profitBalance,
    "status": status,
    "ref_id": refId,
    "kyc": kyc,
    "kyc_credential": kycCredential,
    "two_fa": twoFa,
    "deposit_status": depositStatus,
    "withdraw_status": withdrawStatus,
    "reward_status": rewardStatus,
    "transfer_status": transferStatus,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "custom_fields_data": customFieldsData == null
        ? []
        : List<dynamic>.from(customFieldsData!.map((x) => x.toJson())),
    "updated_at": updatedAt,
    "full_name": fullName,
    "kyc_time": kycTime,
    "kyc_type": kycType,
    "total_profit": totalProfit,
    "total_deposit": totalDeposit,
    "total_invest": totalInvest,
    "2fa_initialized": the2FaInitialized,
    "is_unread_notification": isUnreadNotification,
    "2fa_qr_code": the2FaQrCode,
  };
}

class CustomFieldsDatum {
  String? name;
  String? type;
  String? validation;
  String? value;

  CustomFieldsDatum({this.name, this.type, this.validation, this.value});

  factory CustomFieldsDatum.fromJson(Map<String, dynamic> json) =>
      CustomFieldsDatum(
        name: json["name"],
        type: json["type"],
        validation: json["validation"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "validation": validation,
    "value": value,
  };
}
