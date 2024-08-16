// To parse this JSON data, do
//
//     final files = filesFromJson(jsonString);

import 'dart:convert';

List<Files> filesFromJson(String str) => List<Files>.from(json.decode(str).map((x) => Files.fromJson(x)));

String filesToJson(List<Files> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Files {
  int id;
  String title;
  String? description;
  String fileUrl;
  int userId;
  int status;
  DateTime createdAt;

  Files({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory Files.fromJson(Map<String, dynamic> json) => Files(
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
