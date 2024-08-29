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

  late DetailPosts _detailPosts;
  DetailPosts get detailPosts => _detailPosts;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Collaboration? _collaboration;
  Collaboration? get collaboration => _collaboration;

  Future<void> getPosts(int page) async {
    try{
      final response = await postRepository.getPosts(page);
      if(response.data.isNotEmpty){
        _posts.addAll(response.data);
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

  Future<void> postCollaboration(int postId, int userId) async{
    try{
      _collaboration = await postRepository.postCollaboration(postId, userId);
      notifyListeners();
    }catch (e){
      throw Exception('Failed to post collaboration, status code: ${e}');
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
}
