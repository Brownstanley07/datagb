class RegisterRequestModel {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? country;
  String? password;
  String? passwordConfirmation;
  String? invite;
  String? phone;
  bool? iAgree;

  RegisterRequestModel({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.country,
    this.password,
    this.passwordConfirmation,
    this.invite,
    this.phone,
    this.iAgree,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      RegisterRequestModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        country: json["country"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        invite: json["invite"],
        phone: json["phone"],
        iAgree: json["i_agree"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (country != null) data['country'] = country;
    if (password != null) data['password'] = password;
    if (passwordConfirmation != null) {
      data['password_confirmation'] = passwordConfirmation;
    }
    if (invite != null) data['invite'] = invite;
    if (phone != null) data['phone'] = phone;
    if (iAgree != null) data['i_agree'] = iAgree;
    return data;
  }
}
