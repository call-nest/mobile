// To parse this JSON data, do
//
//     final detailChatting = detailChattingFromJson(jsonString);

import 'dart:convert';

DetailChatting detailChattingFromJson(String str) => DetailChatting.fromJson(json.decode(str));

String detailChattingToJson(DetailChatting data) => json.encode(data.toJson());

class DetailChatting {
  int senderId;
  int recipientId;
  Info senderInfo;
  Info recipientInfo;
  List<Message> messages;

  DetailChatting({
    required this.senderId,
    required this.recipientId,
    required this.senderInfo,
    required this.recipientInfo,
    required this.messages,
  });

  factory DetailChatting.fromJson(Map<String, dynamic> json) => DetailChatting(
    senderId: json["sender_id"],
    recipientId: json["recipient_id"],
    senderInfo: Info.fromJson(json["sender_info"]),
    recipientInfo: Info.fromJson(json["recipient_info"]),
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "recipient_id": recipientId,
    "sender_info": senderInfo.toJson(),
    "recipient_info": recipientInfo.toJson(),
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

class Info {
  String email;
  String nickname;
  String? profileImg;
  int role;
  int id;
  String password;
  String? introduce;
  List<Interest> interests;

  Info({
    required this.email,
    required this.nickname,
    required this.profileImg,
    required this.role,
    required this.id,
    required this.password,
    required this.introduce,
    required this.interests,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    email: json["email"],
    nickname: json["nickname"],
    profileImg: json["profile_img"],
    role: json["role"],
    id: json["id"],
    password: json["password"],
    introduce: json["introduce"],
    interests: List<Interest>.from(json["interests"].map((x) => Interest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "nickname": nickname,
    "profile_img": profileImg,
    "role": role,
    "id": id,
    "password": password,
    "introduce": introduce,
    "interests": List<dynamic>.from(interests.map((x) => x.toJson())),
  };
}

class Interest {
  String interest;
  int id;

  Interest({
    required this.interest,
    required this.id,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
    interest: json["interest"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "interest": interest,
    "id": id,
  };
}
