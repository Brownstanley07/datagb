import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../backend/app_error.dart';
import '../constants/app_constants.dart';

/// Structured application logging used by the network layer and controllers.
///
/// The output format intentionally matches the logger used by LMS Skill Track.
class AppLogger {
  AppLogger._();

  static void request({
    required String client,
    required String method,
    required Uri uri,
    Object? queryParameters,
    Object? body,
    Object? headers,
  }) {
    _printBlock(
      title: 'HTTP REQUEST',
      icon: '📤',
      accent: '$method ${uri.path}',
      lines: [
        'Client: $client',
        'URL: $uri',
        if (_hasValue(queryParameters))
          'Query:\n${_indent(_pretty(queryParameters))}',
        if (_hasValue(body)) 'Body:\n${_indent(_pretty(body))}',
        if (_hasValue(headers)) 'Headers:\n${_indent(_pretty(headers))}',
      ],
    );
  }

  static void response({
    required String client,
    required String method,
    required Uri uri,
    int? statusCode,
    Object? data,
  }) {
    _printBlock(
      title: 'HTTP RESPONSE',
      icon: '✅',
      accent: '$method ${uri.path}',
      lines: [
        'Client: $client',
        if (statusCode != null) 'HTTP: $statusCode',
        'URL: $uri',
        if (_hasValue(data)) 'Data:\n${_indent(_pretty(data))}',
      ],
    );
  }

  static void httpError({
    required String client,
    required String method,
    required Uri uri,
    int? statusCode,
    Object? data,
    String? message,
  }) {
    _printBlock(
      title: 'HTTP ERROR',
      icon: '❌',
      accent: '$method ${uri.path}',
      lines: [
        'Client: $client',
        if (statusCode != null) 'HTTP: $statusCode',
        'URL: $uri',
        if (_hasValue(message)) 'Message: $message',
        if (_hasValue(data)) 'Data:\n${_indent(_pretty(data))}',
      ],
    );
  }

  static void failure(
    AppError error, {
    String? context,
    StackTrace? stackTrace,
  }) {
    _printBlock(
      title: 'FAILURE',
      icon: '❗',
      accent: 'Unexpected error: ${error.message}',
      lines: [
        if (error.statusCode != null) 'HTTP: ${error.statusCode}',
        if (context != null) 'Where: $context',
        if (error.code != null) 'Code: ${error.code}',
        if (stackTrace != null)
          'Stack:\n${_indent(_formatStackPreview(stackTrace) ?? stackTrace.toString())}',
      ],
    );
  }

  static void info(String message) =>
      _printBlock(title: 'INFO', icon: 'ℹ️', accent: message);

  static void warning(String message) =>
      _printBlock(title: 'WARNING', icon: '⚠️', accent: message);

  static void success(String message) =>
      _printBlock(title: 'SUCCESS', icon: '✅', accent: message);

  static void exception(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    _printBlock(
      title: 'EXCEPTION',
      icon: '💥',
      accent: error.toString(),
      lines: [
        if (context != null) 'Where: $context',
        if (stackTrace != null)
          'Stack:\n${_indent(_formatStackPreview(stackTrace) ?? stackTrace.toString())}',
      ],
    );
  }

  static void _printBlock({
    required String title,
    required String icon,
    required String accent,
    List<String> lines = const [],
  }) {
    if (!kDebugMode && !AppConstants.isDeveloperMode) return;

    debugPrint('');
    debugPrint('╔══════════ $title ══════════');
    debugPrint('║ $icon $accent');
    for (final line in lines.where((line) => line.trim().isNotEmpty)) {
      for (final part in line.split('\n')) {
        debugPrint('║ $part');
      }
    }
    debugPrint('╚════════════════════════════');
  }

  static bool _hasValue(Object? value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    if (value is Iterable) return value.isNotEmpty;
    return true;
  }

  static String _pretty(Object? value) {
    if (value == null) return '';
    if (value is FormData) {
      return _pretty({
        'fields': {
          for (final field in value.fields) field.key: _sanitize(field.value),
        },
        'files': {
          for (final file in value.files) file.key: file.value.filename,
        },
      });
    }
    if (value is String) return value;
    try {
      return const JsonEncoder.withIndent('  ').convert(_sanitize(value));
    } catch (_) {
      return value.toString();
    }
  }

  static Object? _sanitize(Object? value) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): _isSensitiveKey(entry.key.toString())
              ? '***'
              : _sanitize(entry.value),
      };
    }
    if (value is Iterable) return value.map(_sanitize).toList();
    return value;
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll('-', '_');
    return normalized.contains('password') ||
        normalized.contains('token') ||
        normalized == 'authorization' ||
        normalized == 'otp' ||
        normalized == 'code';
  }

  static String _indent(String value) =>
      value.split('\n').map((line) => '  $line').join('\n');

  static String? _formatStackPreview(StackTrace? stackTrace) {
    if (stackTrace == null) return null;
    final lines = stackTrace
        .toString()
        .split('\n')
        .map((line) => line.trimRight())
        .where((line) => line.trim().isNotEmpty)
        .where(
          (line) =>
              line.contains('package:hyiprio/') ||
              line.contains('DioClient.') ||
              line.contains('Controller.'),
        )
        .take(4)
        .toList();
    return lines.isEmpty
        ? stackTrace.toString().split('\n').take(3).join('\n')
        : lines.join('\n');
  }
}
