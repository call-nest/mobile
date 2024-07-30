class VerifyNickname{
  final String nickname;
  final bool isAvailable;

  VerifyNickname({required this.nickname, required this.isAvailable});

  factory VerifyNickname.fromJson(Map<String, dynamic> json){
    return VerifyNickname(
      nickname: json['nickname'],
      isAvailable: json['isAvailable']
    );
  }

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'isAvailable': isAvailable
  };
}