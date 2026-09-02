class OnboardingResponseModel {
  bool? status;
  Data? data;

  OnboardingResponseModel({this.status, this.data});

  factory OnboardingResponseModel.fromJson(Map<String, dynamic> json) =>
      OnboardingResponseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  bool enabled;
  List<OnboardingSplashScreen>? onboardingSplashScreens;

  Data({this.enabled = true, this.onboardingSplashScreens});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    enabled: _asBool(json['enabled'], fallback: true),
    onboardingSplashScreens: json["onboarding_splash_screens"] == null
        ? []
        : List<OnboardingSplashScreen>.from(
            json["onboarding_splash_screens"]!.map(
              (x) => OnboardingSplashScreen.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    "onboarding_splash_screens": onboardingSplashScreens == null
        ? []
        : List<dynamic>.from(onboardingSplashScreens!.map((x) => x.toJson())),
  };
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == '1' || normalized == 'true' || normalized == 'yes') {
      return true;
    }
    if (normalized == '0' || normalized == 'false' || normalized == 'no') {
      return false;
    }
  }
  return fallback;
}

class OnboardingSplashScreen {
  String? image;
  String? title;
  String? description;

  OnboardingSplashScreen({this.image, this.title, this.description});

  factory OnboardingSplashScreen.fromJson(Map<String, dynamic> json) =>
      OnboardingSplashScreen(
        image: json["image"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "description": description,
  };
}
