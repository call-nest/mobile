import 'package:flutter/material.dart';

class WidgetCollaborationItem extends StatelessWidget {

  final String title;
  final String name;
  final String date;
  final String state;
  final String type;

  const WidgetCollaborationItem({super.key, required this.title, required this.name, required this.date, required this.state, required this.type});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
          type == "received" ? "$name님이 협업을 요청하였습니다." :
          "$name님에게 협업을 요청하였습니다.", maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(state),
          Text(date.substring(0, 10)),
        ],
      ),
    );
  }
}
