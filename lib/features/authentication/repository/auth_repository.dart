import 'dart:convert';

import 'package:defaults/common/constants.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<int> verifyNickName(String nickname) async {
    final url = Uri.parse("${Constants.baseUrl}users/nickname/verify");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'nickname': nickname}),
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else if (response.statusCode == 400) {
        return response.statusCode;
      } else {
        throw Exception(
            'Failed to verify nickname, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to verify nickname, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> signUp(
      String email, String password, String nickname) async {
    final url = Uri.parse("${Constants.baseUrl}users/signup");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(
            {'email': email, 'password': password, 'nickname': nickname}),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['message'],
          'data': jsonResponse['data']
        };
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['message'],
        };
      } else {
        throw Exception(
            'Failed to sign up, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign up, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("${Constants.baseUrl}users/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['message'],
          'data': jsonResponse['data']
        };
      } else if (response.statusCode == 404) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['detail'],
        };
      } else if (response.statusCode == 401) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['detail'],
        };
      } else {
        throw Exception(
            'Failed to sign in, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> saveInterests(
      int userId, List<String> interests) async {
    final url = Uri.parse("${Constants.baseUrl}users/$userId/interests");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'interests': interests}),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['message'],
          'data': jsonResponse['data']
        };
      } else {
        throw Exception(
            'Failed to save interests, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to save interests, status code: ${e}');
    }
  }

  Future<String> sendEmail(String email) async {
    final url = Uri.parse("${Constants.baseUrl}users/email/otp");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'email': email}),
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        throw Exception(
            'Failed to send email, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send email, status code: ${e}');
    }
  }

  Future<Map<String, dynamic>> checkVerifyCode(String email, int otp) async {
    final url = Uri.parse("${Constants.baseUrl}users/email/otp/verify");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'email' : email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {'statusCode': response.statusCode, 'message': jsonResponse["message"]};
      } else {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'statusCode': response.statusCode,
          'message': jsonResponse['detail'],
        };
      }
    } catch (e) {
      throw Exception('Failed to verify code, status code: ${e}');
    }
  }

}
