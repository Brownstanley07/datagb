import '../../../services/translation_service.dart';

extension TranslationExtension on String {
  String trns({String? fallback}) {
    final translated = TranslationService().get(this);
    return translated == this && fallback != null ? fallback : translated;
  }
}
