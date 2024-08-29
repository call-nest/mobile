import 'package:flutter/material.dart';

class HomeItemScreen extends StatefulWidget {
  static const routeUrl = '/homeItemScreen';
  static const routeName = 'homeItemScreen';

  final String writer;
  final String title;
  final String? content;
  final String date;
  final String profileUrl;

  const HomeItemScreen(
      {super.key,
      required this.writer,
      required this.title,
      required this.content,
      required this.profileUrl,
      required this.date});

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.content ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(widget.date),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
          ),
        ),
      ),
    ]);
  }
}
