// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  String message;
  Data data;

  UserInfo({
    required this.message,
    required this.data,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
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
  String? profile;
  String? introduce;
  int role;
  List<String> interests;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    this.profile = "",
    this.introduce = "",
    required this.role,
    required this.interests,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    nickname: json["nickname"],
    profile: json["profile_img"],
    introduce: json["introduce"],
    role: json["role"],
    interests: List<String>.from(json["interests"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "nickname": nickname,
    "profile_img": profile,
    "introduce": introduce,
    "role": role,
    "interests": List<dynamic>.from(interests.map((x) => x)),
  };
}
