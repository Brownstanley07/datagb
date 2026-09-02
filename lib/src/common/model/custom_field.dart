class CustomField {
  final String key;
  final String label;
  final String type;
  final bool required;

  CustomField({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
  });

  factory CustomField.fromJson(Map<String, dynamic> json) {
    return CustomField(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      required: json['required'] == 'on' ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'type': type,
      'required': required ? 'on' : 'off',
    };
  }
}
