import 'package:defaults/features/home/home_item_screen.dart';
import 'package:defaults/features/home/show_youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.push(ShowYoutubeScreen.routeUrl, extra: {
                          'writer': '작성자',
                          'title': '제목',
                          'content': '내용',
                          'youtubeUrl': 'Dx4_Ki_zDy4',
                          'createdAt': '2021-10-10',
                          'profile':
                              'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'
                        });
                      },
                      child: const HomeItemScreen(
                          writer: '작성자',
                          title: '제목',
                          content: '내용',
                          date: '2021-10-10'),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: FaIcon(FontAwesomeIcons.penNib),
        ),
      ),
    );
  }
}
