import 'dart:io';
import 'package:dio/dio.dart';

class FormDataHelper {
  static Future<FormData> mapToFormData(Map<String, dynamic> map) async {
    final formData = FormData();
    for (final e in map.entries) {
      final key = e.key;
      final value = e.value;
      if (value == null) continue;

      if (value is File) {
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(
              value.path,
              filename: value.path.split('/').last,
            ),
          ),
        );
      } else if (value is List<File>) {
        // support list of files
        for (var f in value) {
          final multipart = await MultipartFile.fromFile(
            f.path,
            filename: f.path.split('/').last,
          );
          formData.files.add(MapEntry(key, multipart));
        }
      } else {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }
    return formData;
  }
}
