import 'dart:convert';

import 'package:defaults/features/community/widgets/posts_widget.dart';
import 'package:dio/dio.dart';

import '../../../common/constants.dart';
import 'package:http/http.dart' as http;

import '../models/collaboration.dart';
import '../models/detail_posts.dart';
import '../models/posts.dart';

class PostRepository {
  final Dio _dio = Dio();

  Future<Posts> getPosts(int page) async {
    final url = Uri.parse("${Constants.baseUrl}posts/all?page=$page");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        final Posts posts = Posts.fromJson(jsonResponse);
        return posts;
      } else {
        throw Exception(
            'Failed to load posts, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<DetailPosts> getDetailPosts(int postId) async {
    final url = Uri.parse("${Constants.baseUrl}posts/$postId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        final DetailPosts detailPosts = DetailPosts.fromJson(jsonResponse);
        return detailPosts;
      } else {
        throw Exception(
            'Failed to load posts, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<Collaboration> postCollaboration(int postId, int userId) async {
    final url = "${Constants.baseUrl}collaborations/post";
    try {
      final response = await _dio.post(
        url,
        data: json.encode({"post_id": postId, "user_id": userId}),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final Collaboration collaboration =
            Collaboration.fromJson(jsonResponse);
        return collaboration;
      } else {
        throw Exception(
            'Failed to post collaboration, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post collaboration, status code: ${e}');
    }
  }

  Future<Datum> writePost(
      int userId, String title, String content, String category) async {
    final url = "${Constants.baseUrl}posts/create";
    try {
      final response = await _dio.post(url,
          data: json.encode({
            "writer": userId,
            "title": title,
            "content": content,
            "category": category
          }),
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final Datum posts = Datum.fromJson(jsonResponse);
        return posts;
      } else {
        throw Exception(
            'Failed to load posts, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> deletePost(int postId) async {
    final url = "${Constants.baseUrl}posts/$postId";
    try {
      final response = await _dio.delete(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to delete post, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete post, status code: ${e}');
    }
  }

  Future<DetailPosts> modifyPost(
      int postId, String title, String content, String category, int writer) async {
    final url = "${Constants.baseUrl}posts/$postId";
    try {
      final response = await _dio.patch(url,
          data: json.encode(
              {"title": title, "content": content, "category": category, "writer": writer}),
          options: Options(headers: {"Content-Type": "application/json"}));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final DetailPosts modifyPost = DetailPosts.fromJson(jsonResponse);
        return modifyPost;
      } else {
        throw Exception(
            'Failed to modify post, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to modify post, status code: ${e}');
    }
  }
}
