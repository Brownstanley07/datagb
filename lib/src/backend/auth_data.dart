class AuthData {
  final String token;

  AuthData({required this.token});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
