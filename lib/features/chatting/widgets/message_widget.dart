import 'package:defaults/features/chatting/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageWidget extends StatelessWidget {
  final List<Message> messages;
  final String userId;

  const MessageWidget({super.key, required this.messages, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index){
        return ChatBubble(
          isMe: messages[index].senderId == userId,
          message: messages[index].message,
          time: messages[index].time,
        );
      }),
    );
  }
}
