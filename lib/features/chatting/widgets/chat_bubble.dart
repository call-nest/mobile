import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime time;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7, // 최대 너비를 화면의 70%로 설정
          ),
          decoration: BoxDecoration(
            color: isMe ? Theme.of(context).primaryColor : Colors.grey[300], // 본인과 상대방 메시지 색상 구분
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                time.toString().substring(0,10),
                style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
