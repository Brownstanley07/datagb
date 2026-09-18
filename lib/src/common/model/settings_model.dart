class SettingResponseModel {
  bool? status;
  bool? isLicense;
  Data? data;

  SettingResponseModel({this.status, this.isLicense, this.data});

  factory SettingResponseModel.fromJson(Map<String, dynamic> json) =>
      SettingResponseModel(
        status: json["status"],
        isLicense: json["is_license"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  List<Setting>? settings;
  PageLinks? pageLinks;
  bool onboardingEnabled;
  WhatsAppSupport? whatsappSupport;
  String? telegramChannelUrl;

  Data({
    this.settings,
    this.pageLinks,
    this.onboardingEnabled = true,
    this.whatsappSupport,
    this.telegramChannelUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    settings: json["settings"] == null
        ? []
        : List<Setting>.from(json["settings"]!.map((x) => Setting.fromJson(x))),
    pageLinks: json["page_links"] == null
        ? null
        : PageLinks.fromJson(json["page_links"]),
    onboardingEnabled: _asBool(json['onboarding_enabled'], fallback: true),
    whatsappSupport: json['whatsapp_support'] == null
        ? null
        : WhatsAppSupport.fromJson(json['whatsapp_support']),
    telegramChannelUrl: json['telegram_channel_url']?.toString(),
  );
}

class WhatsAppSupport {
  final bool enabled;
  final String type;
  final String? phone;
  final String? groupUrl;

  const WhatsAppSupport({
    required this.enabled,
    required this.type,
    this.phone,
    this.groupUrl,
  });

  factory WhatsAppSupport.fromJson(Map<String, dynamic> json) =>
      WhatsAppSupport(
        enabled: _asBool(json['enabled']),
        type: json['type']?.toString() ?? 'phone',
        phone: json['phone']?.toString(),
        groupUrl: json['group_url']?.toString(),
      );
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case '1':
      case 'true':
      case 'yes':
      case 'on':
        return true;
      case '0':
      case 'false':
      case 'no':
      case 'off':
        return false;
    }
  }
  return fallback;
}

class Setting {
  String? name;
  String? value;

  Setting({this.name, this.value});

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(name: json["name"], value: json["value"]);
}

class PageLinks {
  String? termsConditions;
  String? privacyPolicy;

  PageLinks({this.termsConditions, this.privacyPolicy});

  factory PageLinks.fromJson(Map<String, dynamic> json) => PageLinks(
    termsConditions: json["terms_conditions"],
    privacyPolicy: json["privacy_policy"],
  );

  Map<String, dynamic> toJson() => {
    "terms_conditions": termsConditions,
    "privacy_policy": privacyPolicy,
  };
}
