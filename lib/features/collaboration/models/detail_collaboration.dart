// To parse this JSON data, do
//
//     final detailCollaboration = detailCollaborationFromJson(jsonString);

import 'dart:convert';

DetailCollaboration detailCollaborationFromJson(String str) => DetailCollaboration.fromJson(json.decode(str));

String detailCollaborationToJson(DetailCollaboration data) => json.encode(data.toJson());

class DetailCollaboration {
  String message;
  List<Datum> data;

  DetailCollaboration({
    required this.message,
    required this.data,
  });

  factory DetailCollaboration.fromJson(Map<String, dynamic> json) => DetailCollaboration(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Collaboration collaboration;
  String postTitle;
  String requestorNickname;
  String receiverNickname;

  Datum({
    required this.collaboration,
    required this.postTitle,
    required this.requestorNickname,
    required this.receiverNickname,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    collaboration: Collaboration.fromJson(json["collaboration"]),
    postTitle: json["post_title"],
    requestorNickname: json["requestor_nickname"],
    receiverNickname: json["receiver_nickname"],
  );

  Map<String, dynamic> toJson() => {
    "collaboration": collaboration.toJson(),
    "post_title": postTitle,
    "requestor_nickname": requestorNickname,
    "receiver_nickname": receiverNickname,
  };
}

class Collaboration {
  int requestUserId;
  int postId;
  DateTime createdAt;
  int id;
  int receiveUserId;
  int status;

  Collaboration({
    required this.requestUserId,
    required this.postId,
    required this.createdAt,
    required this.id,
    required this.receiveUserId,
    required this.status,
  });

  factory Collaboration.fromJson(Map<String, dynamic> json) => Collaboration(
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
