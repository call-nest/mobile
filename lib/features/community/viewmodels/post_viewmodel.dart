import 'package:defaults/features/community/models/detail_posts.dart';
import 'package:defaults/features/community/widgets/posts_widget.dart';
import 'package:flutter/cupertino.dart';

import '../models/collaboration.dart';
import '../models/posts.dart';
import '../repository/post_repository.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository postRepository;

  PostViewModel({required this.postRepository});

  List<Datum> _posts = [];
  List<Datum> get posts => _posts;

  DetailPosts? _detailPosts;
  DetailPosts? get detailPosts => _detailPosts;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<CollaborationClass> _collaboration = [];
  List<CollaborationClass> get collaboration => _collaboration;

  Future<void> getPosts(int page, String category) async {
    try{
      final response = await postRepository.getPosts(page);
      if(response.data.isNotEmpty){
        if(category == '전체')
          _posts.addAll(response.data);
        else{
          _posts.clear();
          final filteredData = response.data.where((element) => element.category == category).toList();
          _posts.addAll(filteredData);
        }
        _hasMore = true;
      } else {
        _hasMore = false;
      }
      notifyListeners();
    } catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<void> getDetailPosts(int postId) async {
    try{
      final response = await postRepository.getDetailPosts(postId);
      _detailPosts = response;
      notifyListeners();
    } catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  // Future<void> postCollaboration(int postId, int requestUserId, int receiveUserId) async{
  //   try{
  //     _collaboration = await postRepository.postCollaboration(postId, requestUserId, receiveUserId);
  //     notifyListeners();
  //   }catch (e){
  //     throw Exception('Failed to post collaboration, status code: ${e}');
  //   }
  // }

  Future<void> getCollaboration(int postId)async{
    try{
      _collaboration = await postRepository.getCollaboration(postId);
      notifyListeners();
    }catch (e){
      throw Exception('Failed to get collaboration, status code: ${e}');
    }
  }

  Future<void> writePost(int userId, String title, String content, String category) async{
    try{
      await postRepository.writePost(userId, title, content, category);
      notifyListeners();
    }catch (e){
      throw Exception('Failed to write post, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> deletePost(int postId) async{
    try{
      final response = await postRepository.deletePost(postId);
      _posts.removeWhere((element) => element.id == postId);
      notifyListeners();
      return response;
    }catch (e){
      throw Exception('Failed to delete post, status code: ${e}');
    }
  }

  Future<DetailPosts> modifyPost(int postId, String title, String content, int userId, String category) async{
    try{
      final response = await postRepository.modifyPost(postId, title, content, category, userId);
      _detailPosts = response;
      notifyListeners();
      return response;
    }catch (e){
      throw Exception('Failed to modify post, status code: ${e}');
    }
  }
}
