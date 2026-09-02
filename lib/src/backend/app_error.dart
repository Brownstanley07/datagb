class AppError implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  AppError({required this.message, this.statusCode, this.code});

  @override
  String toString() {
    return 'AppError: $message (Status: $statusCode, Code: $code)';
  }
}
