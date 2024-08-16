// To parse this JSON data, do
//
//     final collaboration = collaborationFromJson(jsonString);

import 'dart:convert';

Collaboration collaborationFromJson(String str) => Collaboration.fromJson(json.decode(str));

String collaborationToJson(Collaboration data) => json.encode(data.toJson());

class Collaboration {
  String message;
  CollaborationClass collaboration;

  Collaboration({
    required this.message,
    required this.collaboration,
  });

  factory Collaboration.fromJson(Map<String, dynamic> json) => Collaboration(
    message: json["message"],
    collaboration: CollaborationClass.fromJson(json["collaboration"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "collaboration": collaboration.toJson(),
  };
}

class CollaborationClass {
  int id;
  bool isAccepted;
  bool isCanceled;
  int status;
  bool isRejected;
  int postId;
  int userId;
  DateTime createdAt;

  CollaborationClass({
    required this.id,
    required this.isAccepted,
    required this.isCanceled,
    required this.status,
    required this.isRejected,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory CollaborationClass.fromJson(Map<String, dynamic> json) => CollaborationClass(
    id: json["id"],
    isAccepted: json["is_accepted"],
    isCanceled: json["is_canceled"],
    status: json["status"],
    isRejected: json["is_rejected"],
    postId: json["post_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_accepted": isAccepted,
    "is_canceled": isCanceled,
    "status": status,
    "is_rejected": isRejected,
    "post_id": postId,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
  };
}
