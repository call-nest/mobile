import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final int userId;
  late WebSocketChannel _channel;
  bool isConnected = false;
  Timer? _reconnectTimer;
  Function(String)? _onMessageReceived;

  Logger log = Logger();

  ChatService({required this.userId}) {
    _connect();
  }

  void _connect() {
    _channel = IOWebSocketChannel.connect(
        "ws://192.168.123.107:8000/chatting/ws/$userId");
    log.d("Connected to server");
    _channel.stream.listen((message) {
      if (_onMessageReceived != null) {
        _onMessageReceived!(message);
      } else {
        log.w('No message handler set');
      }
    }, onError: (error) {
      _handlerError(error);
    }, onDone: () {
      isConnected = false;
      connectionClose();
    });

    isConnected = true;
  }

  void sendMessage(String message) {
    if (isConnected) {
      _channel.sink.add(message);
    } else {
      log.e('Connection is closed. Unable to send message');
    }
  }

  void listenMessages(Function(String) onMessageReceived) {
    _onMessageReceived = onMessageReceived;
  }

  void _handlerError(dynamic error) {
    log.e('Error: $error');
    _reconnect();
  }

  void _reconnect() {
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (!isConnected) {
          log.e("Attempting to reconnect...");
          _connect();
        } else {
          timer.cancel();
        }
      });
    }
  }

  void connectionClose() {
    _channel.sink.close();
    isConnected = false;
    _reconnectTimer?.cancel();
  }
}
