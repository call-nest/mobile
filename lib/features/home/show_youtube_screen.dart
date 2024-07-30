import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShowYoutubeScreen extends StatefulWidget {
  final String writer;
  final String title;
  final String content;
  final String youtubeUrl;
  final String createdAt;
  final String profile;

  static const routeUrl = '/showYoutubeScreen';
  static const routeName = 'showYoutubeScreen';

  const ShowYoutubeScreen(
      {super.key,
      required this.writer,
      required this.title,
      required this.content,
      required this.youtubeUrl,
      required this.createdAt,
      required this.profile});

  @override
  State<ShowYoutubeScreen> createState() => _ShowYoutubeScreenState();
}

class _ShowYoutubeScreenState extends State<ShowYoutubeScreen> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.youtubeUrl,
      flags: const YoutubePlayerFlags(
        isLive: false,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('작성자: ${widget.writer}'),
              subtitle: Text(widget.createdAt),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.profile),
              ),
            ),
            Container(
              child: YoutubePlayer(
                controller: _youtubePlayerController,
                liveUIColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
