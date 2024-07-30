// To parse this JSON data, do
//
//     final detailPosts = detailPostsFromJson(jsonString);

import 'dart:convert';

DetailPosts detailPostsFromJson(String str) => DetailPosts.fromJson(json.decode(str));

String detailPostsToJson(DetailPosts data) => json.encode(data.toJson());

class DetailPosts {
  int id;
  String title;
  String content;
  String writerNickname;
  int writer;
  bool isRecruit;
  String createdAt;
  dynamic updatedAt;
  bool isDeleted;

  DetailPosts({
    required this.id,
    required this.title,
    required this.content,
    required this.writerNickname,
    required this.writer,
    required this.isRecruit,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  factory DetailPosts.fromJson(Map<String, dynamic> json) => DetailPosts(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    writerNickname: json["writer_nickname"],
    writer: json["writer"],
    isRecruit: json["is_recruit"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isDeleted: json["is_deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "writer_nickname": writerNickname,
    "writer": writer,
    "is_recruit": isRecruit,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
  };
}
