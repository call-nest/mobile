import '../../../common/constants.dart';
import '../models/user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_interests.dart';
import '../models/user_posts.dart';

class UserRepository {
  Future<UserInfo> getUser(int userId) async {
    final url = Uri.parse("${Constants.baseUrl}users/$userId/user_info");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return UserInfo.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to get user info, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get user info, status code: $e');
    }
  }

  Future<UserInterests> getUserInterests(int userId) async {
    final url = Uri.parse("${Constants.baseUrl}users/$userId/interests");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return UserInterests.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to get user interests, status code: ${response
            .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get user interests, status code: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAccount(int id, String password) async {
    final url = Uri.parse("${Constants.baseUrl}users/$id/delete");
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'id': id, 'password': password}),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['message'],
        };
      } else {
        throw Exception(
            'Failed to delete account, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete account, status code: ${e}');
    }
  }

  Future<UserPosts> getPosts(int userId) async {
    final url = Uri.parse("${Constants.baseUrl}posts/$userId/posts");
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        UserPosts userPosts = UserPosts.fromJson(jsonResponse);
        return userPosts;
      } else {
        throw Exception('Failed to get user posts, status code: ${response
            .statusCode}');
      }
    }catch(e){
      throw Exception('Failed to get user posts, status code: ${e}');
    }
  }
}
