import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyAmountFormatter extends TextInputFormatter {
  const CurrencyAmountFormatter();

  static final NumberFormat _wholeNumber = NumberFormat('#,##0', 'en_NG');

  static double? parse(String value) =>
      double.tryParse(value.replaceAll(',', '').trim());

  static String format(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    return '${_wholeNumber.format(int.parse(parts.first))}.${parts.last}';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return const TextEditingValue();

    final parts = cleaned.split('.');
    final whole = parts.first.isEmpty ? '0' : parts.first;
    var formatted = _wholeNumber.format(int.tryParse(whole) ?? 0);
    if (cleaned.contains('.')) {
      final decimals = parts.length > 1 ? parts[1] : '';
      formatted += '.${decimals.substring(0, decimals.length.clamp(0, 2))}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
