import 'dart:convert';
import 'dart:io';

import 'package:defaults/common/constants.dart';
import 'package:dio/dio.dart';

import '../models/post_file.dart';
import 'package:http/http.dart' as http;

class FileRepository{

  final Dio _dio = Dio();

  Future<PostFile> postFileFromJson(String title, String description, int userId, File file) async {
    const url ="${Constants.baseUrl}files/upload";
    try {
      FormData formData = FormData.fromMap({
        "title": title,
        "user_id": userId,
        "description": description,
        "file": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      });

      final response = await _dio.post(url, data: formData, options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: "multipart/form-data"
        }
      ));

      if(response.statusCode == 200){
        final Map<String, dynamic> jsonResponse = response.data;
        final PostFile postFile = PostFile.fromJson(jsonResponse);
        return postFile;
      }else{
        throw Exception('Failed to load posts, status code: ${response.statusCode}');
      }
    }catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<List<PostFile>> getFiles() async {
    const url = "${Constants.baseUrl}files/get_files";
    try {
      final response = await _dio.get(url);
      if(response.statusCode == 200){
        final List<dynamic> jsonResponse = response.data;
        final List<PostFile> postFiles = jsonResponse.map((json) => PostFile.fromJson(json)).toList();
        return postFiles;
      }else{
        throw Exception('Failed to load posts, status code: ${response.statusCode}');
      }
    }catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }
}