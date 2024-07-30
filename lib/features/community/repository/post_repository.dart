import 'dart:convert';

import 'package:defaults/features/community/widgets/posts_widget.dart';

import '../../../common/constants.dart';
import 'package:http/http.dart' as http;

import '../models/detail_posts.dart';
import '../models/posts.dart';


class PostRepository {
  Future<Posts> getPosts(int page) async {
    final url = Uri.parse("${Constants.baseUrl}posts/all?page=$page");
    try{
      final response = await http.get(url);
      if(response.statusCode == 200){
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final Posts posts = Posts.fromJson(jsonResponse);
        return posts;
      } else {
        throw Exception('Failed to load posts, status code: ${response.statusCode}');
      }
    } catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<DetailPosts> getDetailPosts(int postId) async {
    final url = Uri.parse("${Constants.baseUrl}posts/$postId");
    try{
      final response = await http.get(url);
      if(response.statusCode == 200){
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final DetailPosts detailPosts = DetailPosts.fromJson(jsonResponse);
        return detailPosts;
      } else {
        throw Exception('Failed to load posts, status code: ${response.statusCode}');
      }
    } catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }
}
