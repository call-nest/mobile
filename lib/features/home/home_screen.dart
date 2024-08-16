import 'package:defaults/features/home/home_item_screen.dart';
import 'package:defaults/features/home/post_complete_screen.dart';
import 'package:defaults/features/home/detail_home_screen.dart';
import 'package:defaults/features/home/viewmodels/file_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/post_file.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<FileViewModel>(context, listen: false);
    viewModel.getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<FileViewModel>(builder: (context, viewModel, child) {
          return ListView.builder(
              itemCount: viewModel.files.length,
              itemBuilder: (context, index) {
                final PostFile data = viewModel.files[index];
                return InkWell(
                  onTap: () {
                    context.push(DetailHomeScreen.routeUrl, extra: {
                      'userId': data.userId.toString(),
                      'title': data.title,
                      'content': data.description,
                      'fileUrl':
                          "https://s3.ap-northeast-1.wasabisys.com/collnest/2/Y2meta.app-%ED%98%9C%EC%95%88%EC%A0%B8%EC%8A%A4%20%EC%B2%B4%EC%9D%B8%ED%88%AC%EA%B2%8C%EB%8D%94%20%EC%9D%B4%EC%A0%9C%20%E3%84%B1%E3%85%90%EC%9E%98%ED%95%A9%EB%8B%88%EB%8B%A4%E3%84%B7%E3%84%B7%28%E2%80%BB30%EB%B6%84%20%EC%88%9C%EC%82%AD%29-%28720p60%29.mp4?AWSAccessKeyId=ZZDV4EWRWG8PEDFGNKXH&Expires=1723825905&Signature=THAn%2BG0SBpxLcIy226UcXi14ZnM%3D",
                      'createdAt': data.createdAt.toString().substring(0, 10),
                      'profile':
                          "https://s3.ap-northeast-1.wasabisys.com/collnest/profile/13/image-2.png?AWSAccessKeyId=ZZDV4EWRWG8PEDFGNKXH&Expires=1723825863&Signature=Ayp21F1%2FikIyEywPiSXboVX%2BI%2F0%3D"
                    });
                  },
                  child: HomeItemScreen(
                    title: data.title,
                    writer: data.userId.toString(),
                    date: data.createdAt.toString().substring(0, 10),
                    content: data.description,
                  ),
                );
              });
        }),
        floatingActionButton: FloatingActionButton(
          heroTag: 'home',
          onPressed: () {
            context.push(PostCompleteScreen.routeUrl);
          },
          child: FaIcon(FontAwesomeIcons.penNib),
        ),
      ),
    );
  }
}
