import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChattingListWidget extends StatelessWidget {

  final int id;
  final String content;
  final String time;

  const ChattingListWidget({super.key, required this.id, required this.content, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(content),
        subtitle: Text(time),
      ),
    );
  }
}
