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
                      'fileUrl': data.fileUrl,
                      'createdAt': data.createdAt.toString().substring(0, 10),
                      'profile':
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                    });
                  },
                  child: HomeItemScreen(
                    title: data.title,
                    writer: data.userId.toString(),
                    date: data.createdAt.toString().substring(0, 10),
                    content: data.description,
                    profileUrl: data.fileUrl,
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
