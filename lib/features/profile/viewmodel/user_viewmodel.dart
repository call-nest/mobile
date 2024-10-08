import 'dart:io';

import 'package:defaults/features/profile/models/user_info.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_interests.dart';
import '../models/user_posts.dart';
import '../repository/user_repository.dart';

class UserViewModel extends ChangeNotifier{
  final UserRepository userRepository;

  UserViewModel({required this.userRepository});

  UserPosts? _userPosts;
  UserPosts? get userPosts => _userPosts;

  UserInfo? _userInfo;
  UserInfo? get userInfo => _userInfo;

  Future<void> getUserInfo(int userId) async{
    try {
      final response = await userRepository.getUser(userId);
      _userInfo = response;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get user info, status code: $e');
    }
  }

  Future<UserInterests> getUserInterests(int userId) async{
    try{
      final userInterests = await userRepository.getUserInterests(userId);
      return userInterests;
    }catch(e){
      throw Exception('Failed to get user interests, status code: $e');
    }
  }

  Future<Map<String, dynamic>> deleteAccount(int userId, String password) async{
    try{
      final response = await userRepository.deleteAccount(userId, password);
      return response;
    }catch(e){
      return {
        'statusCode' : 500,
        'message' : e.toString(),
      };
    }
  }

  Future<void> getUserPosts(int userId) async{
    try{
      final response = await userRepository.getPosts(userId);
      _userPosts = response;
      notifyListeners();
    }catch(e){
      throw Exception('Failed to get user posts, status code: $e');
    }
  }

  Future<void> updateUserInfo(int userId, File profileImg, String nickname, String introduce, List<String> interests) async{
    try{
      final response = await userRepository.updateUserInfo(userId, nickname, profileImg, introduce, interests);
      _userInfo = response;
      notifyListeners();
    }catch(e){
      throw Exception('Failed to get user posts, status code: $e');
    }
  }
}