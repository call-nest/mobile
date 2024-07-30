// To parse this JSON data, do
//
//     final userUpdate = userUpdateFromJson(jsonString);

import 'dart:convert';

UserUpdate userUpdateFromJson(String str) => UserUpdate.fromJson(json.decode(str));

String userUpdateToJson(UserUpdate data) => json.encode(data.toJson());

class UserUpdate {
  String message;
  Data data;

  UserUpdate({
    required this.message,
    required this.data,
  });

  factory UserUpdate.fromJson(Map<String, dynamic> json) => UserUpdate(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  int id;
  String email;
  String nickname;

  User({
    required this.id,
    required this.email,
    required this.nickname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    nickname: json["nickname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "nickname": nickname,
  };
}
