import 'dart:convert';

import 'package:flutter/services.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  Map<String, dynamic> _translations = {};
  Map<String, dynamic> _fallbackTranslations = {};
  bool _loaded = false;

  Future<void> loadBundledTranslations() async {
    final jsonText = await rootBundle.loadString(
      'lib/src/utils/helper/app_translation.json',
    );
    final decoded = jsonDecode(jsonText);

    if (decoded is! Map) {
      throw const FormatException('The bundled translations must be a map.');
    }

    _fallbackTranslations = Map<String, dynamic>.from(decoded);
    _translations = _deepCopy(_fallbackTranslations);
    _loaded = true;
  }

  void setTranslations(Map<String, dynamic> data) {
    // The API may return only some keys. Keep the bundled copy underneath it
    // so a missing or malformed server value never appears as a raw key.
    _translations = _deepMerge(_fallbackTranslations, data);
    _loaded = true;
  }

  String get(String key) {
    final normalizedKey = key.trim();
    if (normalizedKey.isEmpty) return '';

    final translated = _lookup(_translations, normalizedKey);
    if (_isUsableTranslation(translated, normalizedKey)) {
      return _replaceCurrencyTerms(translated as String);
    }

    final fallback = _lookup(_fallbackTranslations, normalizedKey);
    if (_isUsableTranslation(fallback, normalizedKey)) {
      return _replaceCurrencyTerms(fallback as String);
    }

    return _humanizeKey(normalizedKey);
  }

  dynamic _lookup(Map<String, dynamic> source, String key) {
    if (!_loaded && source.isEmpty) return null;

    // Some API versions return flattened keys such as
    // "home.recentTransactions.title" instead of nested JSON.
    final directKey = _matchingKey(source, key);
    if (directKey != null) return source[directKey];

    final parts = key.split('.');
    dynamic value = source;

    for (final part in parts) {
      if (value is! Map) return null;
      final matchingKey = _matchingKey(value, part);
      if (matchingKey == null) return null;
      value = value[matchingKey];
    }
    return value;
  }

  Object? _matchingKey(Map<dynamic, dynamic> map, String requestedKey) {
    if (map.containsKey(requestedKey)) return requestedKey;
    final lowerKey = requestedKey.toLowerCase();
    for (final candidate in map.keys) {
      if (candidate is String && candidate.toLowerCase() == lowerKey) {
        return candidate;
      }
    }
    return null;
  }

  bool _isUsableTranslation(dynamic value, String key) {
    return value is String && value.trim().isNotEmpty && value.trim() != key;
  }

  String _replaceCurrencyTerms(String value) {
    return value
        .replaceAll(RegExp(r'\bUSD\b', caseSensitive: false), '₦')
        .replaceAll(RegExp(r'\bUS Dollars?\b', caseSensitive: false), 'Naira')
        .replaceAll(RegExp(r'\bDollars?\b', caseSensitive: false), 'Naira')
        .replaceAll(r'$', '₦');
  }

  Map<String, dynamic> _deepMerge(
    Map<String, dynamic> fallback,
    Map<String, dynamic> override,
  ) {
    final result = _deepCopy(fallback);
    override.forEach((key, value) {
      final existingKey = _matchingKey(result, key);
      final resultKey = existingKey is String ? existingKey : key;
      final existing = result[resultKey];

      if (existing is Map && value is Map) {
        result[resultKey] = _deepMerge(
          Map<String, dynamic>.from(existing),
          Map<String, dynamic>.from(value),
        );
      } else if (value is String && value.trim().isNotEmpty) {
        result[resultKey] = value;
      }
    });
    return result;
  }

  Map<String, dynamic> _deepCopy(Map<String, dynamic> source) {
    return source.map((key, value) {
      if (value is Map) {
        return MapEntry(key, _deepCopy(Map<String, dynamic>.from(value)));
      }
      return MapEntry(key, value);
    });
  }

  String _humanizeKey(String key) {
    final lastPart = key.split('.').last;
    final spaced = lastPart.replaceAll('_', ' ').replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) {
        return '${match.group(1)} ${match.group(2)}';
      },
    );

    return spaced
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
