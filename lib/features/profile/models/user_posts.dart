// To parse this JSON data, do
//
//     final userPosts = userPostsFromJson(jsonString);

import 'dart:convert';

UserPosts userPostsFromJson(String str) => UserPosts.fromJson(json.decode(str));

String userPostsToJson(UserPosts data) => json.encode(data.toJson());

class UserPosts {
  String msg;
  List<Datum> data;

  UserPosts({
    required this.msg,
    required this.data,
  });

  factory UserPosts.fromJson(Map<String, dynamic> json) => UserPosts(
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String title;
  String content;
  String writerNickname;
  bool isRecruit;
  DateTime createdAt;
  dynamic updatedAt;
  bool isDeleted;
  String category;

  Datum({
    required this.id,
    required this.title,
    required this.content,
    required this.writerNickname,
    required this.isRecruit,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.category,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    writerNickname: json["writer_nickname"],
    isRecruit: json["is_recruit"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    isDeleted: json["is_deleted"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "writer_nickname": writerNickname,
    "is_recruit": isRecruit,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "category": category,
  };
}
