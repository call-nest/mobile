import 'dart:async';
import 'dart:convert';

import 'package:defaults/features/chatting/repository/chatting_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../common/constants.dart';
import '../../profile/models/user_info.dart';
import '../models/detail_chatting.dart';

class ChattingViewModel extends ChangeNotifier {
  final ChattingRepository chattingRepository;

  ChattingViewModel({required this.chattingRepository});

  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Info? _senderInfo;
  Info? _recipientInfo;

  Info? get senderInfo => _senderInfo;

  Info? get recipientInfo => _recipientInfo;

  int _userId = 0;

  int get userId => _userId;

  List<Message> _chattingList = [];

  List<Message> get chattingList => _chattingList;

  Future<void> getChatting(int userId, int recipientId) async {
    if (_messages.isNotEmpty) {
      _messages = [];
    }
    try {
      final response =
          await chattingRepository.getChatting(userId, recipientId);
      _userId = response.senderId;
      _senderInfo = response.senderInfo;
      _recipientInfo = response.recipientInfo;
      if (response.messages.isNotEmpty) {
        _messages.addAll(response.messages);
      } else {
        _messages = [];
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load chatting, status code: ${e}');
    }
  }

  Future<void> getChattingList(int userId) async {
    if (_chattingList.isNotEmpty) {
      _chattingList = [];
    }
    try {
      final response = await chattingRepository.getChattingList(userId);
      if (response.isNotEmpty) {
        _chattingList.addAll(response);
      } else {
        _chattingList = [];
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load chatting, status code: ${e}');
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      final decodedMessage = jsonDecode(message) as Map<String, dynamic>;
      _messages.add(
        Message(
          id: 0,
          content: decodedMessage['content'],
          senderId: decodedMessage['sender_id'],
          recipientId: decodedMessage['recipient_id'],
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print('Failed to decode message: $e');
    }
  }

  Future<void> connectWebSocket(int userId) async {
    if(chattingRepository.isConnected()) {
      return;
    }
    try {
      await chattingRepository.connect(userId);

      chattingRepository.listenMessages((message) {
        _handleIncomingMessage(message);
      });
    } catch (e) {
      print('Failed to connect to server, status code: ${e}');
    }
  }

  Future<void> sendMessage(int userId, int recipientId, String content) async {
    final response = await chattingRepository.sendMessageToServer(
        userId, recipientId, content);
    if (response == "Failed to send message") {
      throw Exception('Failed to send message');
    }
    _messages.add(Message(
        id: 0,
        senderId: userId,
        recipientId: recipientId,
        content: content,
        timestamp: DateTime.now()));
    notifyListeners();
  }

  void disconnectWebSocket() {
    chattingRepository.close();
  }

  void sendWebSocket(int recipientId, String content) {
    chattingRepository.sendMessage(recipientId, content);
  }
}
