import 'dart:convert';
import 'dart:io';

import 'package:defaults/common/constants.dart';
import 'package:defaults/features/management/models/files.dart';
import 'package:dio/dio.dart';

class ManageRepository {
  final Dio _dio = Dio();

  Future<List<Files>> getFiles() async {
    final url = "${Constants.baseUrl}files/get_files";

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        final List<Files> files =
            jsonResponse.map((json) => Files.fromJson(json)).toList();
        return files;
      } else {
        throw Exception(
            'Failed to load posts, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<Files> updateFile(int fileId, int status) async {
    final url = "${Constants.baseUrl}files/$fileId/update_file";
    try {
      final response = await _dio.patch(
        url,
        queryParameters: {'status': status},
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final Files file = Files.fromJson(jsonResponse);
        return file;
      } else {
        throw Exception(
            'Failed to update file, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update file, status code: ${e}');
    }
  }
}
