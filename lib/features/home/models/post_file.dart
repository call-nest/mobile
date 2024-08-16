// To parse this JSON data, do
//
//     final postFile = postFileFromJson(jsonString);

import 'dart:convert';

PostFile postFileFromJson(String str) => PostFile.fromJson(json.decode(str));

String postFileToJson(PostFile data) => json.encode(data.toJson());

class PostFile {
  int id;
  String title;
  String? description;
  String fileUrl;
  int userId;
  int status;
  DateTime createdAt;

  PostFile({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) => PostFile(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    fileUrl: json["file_url"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "file_url": fileUrl,
    "user_id": userId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}
