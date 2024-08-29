// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

Posts postsFromJson(String str) => Posts.fromJson(json.decode(str));

String postsToJson(Posts data) => json.encode(data.toJson());

class Posts {
  String message;
  List<Datum> data;
  Pagination pagination;

  Posts({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Datum {
  int id;
  String title;
  String content;
  String writerNickname;
  bool isRecruit;
  String createdAt;
  String? updatedAt;
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
    createdAt: json["created_at"],
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "category": category,
  };
}

class Pagination {
  int page;
  int pageSize;
  int totalPosts;
  int totalPages;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.totalPosts,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    pageSize: json["page_size"],
    totalPosts: json["total_posts"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "page_size": pageSize,
    "total_posts": totalPosts,
    "total_pages": totalPages,
  };
}
