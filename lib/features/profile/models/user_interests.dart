// To parse this JSON data, do
//
//     final userInsterests = userInsterestsFromJson(jsonString);

import 'dart:convert';

UserInterests userInterestsFromJson(String str) => UserInterests.fromJson(json.decode(str));

String userInterestsToJson(UserInterests data) => json.encode(data.toJson());

class UserInterests {
  String message;
  Data data;

  UserInterests({
    required this.message,
    required this.data,
  });

  factory UserInterests.fromJson(Map<String, dynamic> json) => UserInterests(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<String> interests;

  Data({
    required this.interests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    interests: List<String>.from(json["interests"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "interests": List<dynamic>.from(interests.map((x) => x)),
  };
}
