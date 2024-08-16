import 'package:flutter/material.dart';

class HomeItemScreen extends StatefulWidget {
  static const routeUrl = '/homeItemScreen';
  static const routeName = 'homeItemScreen';

  final String writer;
  final String title;
  final String? content;
  final String date;

  const HomeItemScreen(
      {super.key,
      required this.writer,
      required this.title,
      required this.content,
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
          subtitle: Text(widget.content ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(widget.date),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://s3.ap-northeast-1.wasabisys.com/collnest/profile/13/image-2.png?AWSAccessKeyId=ZZDV4EWRWG8PEDFGNKXH&Expires=1723825863&Signature=Ayp21F1%2FikIyEywPiSXboVX%2BI%2F0%3D'
            ),
          ),
        ),
      ),
    ]);
  }
}
