import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _numberFormat = NumberFormat('#,##0.##', 'en_NG');

  static String number(Object? value) {
    if (value == null) return '0';
    if (value is num) return _numberFormat.format(value);

    final text = value.toString().trim();
    final cleaned = text
        .replaceAll(',', '')
        .replaceAll(RegExp(r'[^0-9.\-]'), '');
    final parsed = num.tryParse(cleaned);
    return parsed == null ? text : _numberFormat.format(parsed);
  }

  static String naira(Object? value) => '₦${number(value)}';

  static String nairaRange(Object? minimum, Object? maximum) =>
      '${naira(minimum)} - ${naira(maximum)}';

  /// Normalizes monetary strings returned by the API, including values such
  /// as "$1200", "1200 USD", "NGN 1200", and "₦1,200".
  static String nairaText(Object? value) {
    if (value == null) return naira(0);
    final text = value.toString().trim();
    final match = RegExp(r'-?[0-9][0-9,]*(?:\.[0-9]+)?').firstMatch(text);
    return match == null ? text : naira(match.group(0));
  }
}
