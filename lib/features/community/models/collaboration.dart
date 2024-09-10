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
  int requestUserId;
  int postId;
  DateTime createdAt;
  int id;
  int receiveUserId;
  int status;

  CollaborationClass({
    required this.requestUserId,
    required this.postId,
    required this.createdAt,
    required this.id,
    required this.receiveUserId,
    required this.status,
  });

  factory CollaborationClass.fromJson(Map<String, dynamic> json) => CollaborationClass(
    requestUserId: json["request_user_id"],
    postId: json["post_id"],
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    receiveUserId: json["receive_user_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "request_user_id": requestUserId,
    "post_id": postId,
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "receive_user_id": receiveUserId,
    "status": status,
  };
}
