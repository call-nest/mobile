import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DetailHomeScreen extends StatefulWidget {
  static const routeUrl = '/detailHomeScreen';
  static const routeName = 'detailHomeScreen';

  final String userId;
  final String title;
  final String content;
  final String createdAt;
  final String profile;
  final String? fileUrl;

  const DetailHomeScreen({
    super.key,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.profile,
    this.fileUrl,
  });

  @override
  State<DetailHomeScreen> createState() => _DetailHomeScreenState();
}

class _DetailHomeScreenState extends State<DetailHomeScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  late int userId;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
    initUserId();
  }

  Future<void> initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
    });
  }

  Future<void> _initializeVideoPlayer() async {
    if (widget.fileUrl == null) return;

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.fileUrl!));
    await _controller.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.profile),
                      ),
                      title: Text(widget.userId),
                      subtitle: Text(widget.createdAt),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Chewie(controller: _chewieController)),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
