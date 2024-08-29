import 'dart:convert';
import 'dart:io';

import 'package:defaults/features/chatting/models/detail_chatting.dart';
import 'package:defaults/service/chat_service.dart';
import 'package:dio/dio.dart';

import '../../../common/constants.dart';

import 'package:http/http.dart' as http;

class ChattingRepository {
  final Dio _dio = Dio();

  late ChatService _service;

  Future<DetailChatting> getChatting(int userId, int reciepientId) async {
    final url = Uri.parse(
        "${Constants.baseUrl}chatting/messages/$userId/$reciepientId");
    try {
      final response = await _dio.get(url.toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final DetailChatting chatting = DetailChatting.fromJson(jsonResponse);
        return chatting;
      } else {
        throw Exception(
            'Failed to load chatting, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chatting, status code: ${e}');
    }
  }

  Future<List<Message>> getChattingList(int userId) async {
    final url = Uri.parse("${Constants.baseUrl}chatting/messages");
    try {
      final response =
          await _dio.get(url.toString(), queryParameters: {"user_id": userId});
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        final List<Message> messages =
            jsonResponse.map((item) => Message.fromJson(item)).toList();
        return messages;
      } else {
        throw Exception(
            'Failed to load chatting, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load chatting, status code: ${e}');
    }
  }

  Future<void> connect(int userId) async {
    try {
      _service = ChatService(userId: userId);
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  bool isConnected() {
    return _service.isConnected;
  }

  void sendMessage(int recipientId, String content){
    _service.sendMessage(jsonEncode({
      "recipient_id": recipientId,
      "content": content
    }));
  }

  Future<Map<String, dynamic>> sendMessageToServer(
      int senderId, int recipientId, String content) async {
    final response = await _dio.post("${Constants.baseUrl}chatting/messages",
        queryParameters: {
          "sender_id": senderId,
          "recipient_id": recipientId,
          "content": content
        });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to send message');
    }
  }

  void listenMessages(Function(String) onMessageReceived) {
    _service.listenMessages(onMessageReceived);
  }

  void close() {
    _service.connectionClose();
  }
}
