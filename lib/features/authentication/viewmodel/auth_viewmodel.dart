import 'dart:convert';
import 'package:defaults/common/constants.dart';
import 'package:defaults/features/authentication/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthViewModel({required this.authRepository});

  String _verifyNickName = "";

  String get verifyNickName => _verifyNickName;

  Future<void> verifyNickname(String nickname) async {
    try{
      int nickNameCode = await authRepository.verifyNickName(nickname);
      if(nickNameCode == 200) {
        _verifyNickName = "사용 가능한 닉네임입니다.";
      }else if(nickNameCode == 400) {
        _verifyNickName = "이미 존재하는 닉네임입니다.";
      }else{
        _verifyNickName = "사용할 수 없는 닉네임입니다., status code: $nickNameCode";
      }
    }catch(e){
      _verifyNickName = e.toString();
    }finally{
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String nickname) async{
    try{
      final response = await authRepository.signUp(email, password, nickname);
      return response;
    }catch(e){
      return {
        'statusCode' : 500,
        'message' : e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async{
    try{
      final response = await authRepository.login(email, password);
      return response;
    }catch(e){
      return {
        'statusCode' : 500,
        'message' : e.toString(),
      };
    }
  }

  Future<String> sendEmail(String email) async{
    try{
      final response = await authRepository.sendEmail(email);
      print(response);
      return response;
    }catch(e){
      return e.toString();
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, int code) async{
    try{
      final response = await authRepository.checkVerifyCode(email, code);
      return response;
    }catch(e){
      return {
        'statusCode' : 500,
        'message' : e.toString(),
      };
    }
  }


  Future<Map<String, dynamic>> saveInterests(int userId, List<String> interests) async{
    try{
      final response = await authRepository.saveInterests(userId, interests);
      return response;
    }catch(e){
      return {
        'statusCode' : 500,
        'message' : e.toString(),
      };
    }
  }
}
