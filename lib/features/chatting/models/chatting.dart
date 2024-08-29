// To parse this JSON data, do
//
//     final chatting = chattingFromJson(jsonString);

import 'dart:convert';

Chatting chattingFromJson(String str) => Chatting.fromJson(json.decode(str));

String chattingToJson(Chatting data) => json.encode(data.toJson());

class Chatting {
  int userId;
  int recipientId;
  List<Message> messages;

  Chatting({
    required this.userId,
    required this.recipientId,
    required this.messages,
  });

  factory Chatting.fromJson(Map<String, dynamic> json) => Chatting(
    userId: json["sender_id"],
    recipientId: json["recipient_id"],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sender_id": userId,
    "recipient_id": recipientId,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  int id;
  String content;
  int senderId;
  int recipientId;
  DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.recipientId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    content: json["content"],
    senderId: json["sender_id"],
    recipientId: json["recipient_id"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "sender_id": senderId,
    "recipient_id": recipientId,
    "timestamp": timestamp.toIso8601String(),
  };
}
