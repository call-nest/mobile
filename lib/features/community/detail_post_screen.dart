import 'package:defaults/features/community/models/collaboration.dart';
import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPostScreen extends StatefulWidget {
  static const String routeUrl = '/detailPost';
  static const routeName = "detailPost";

  final int postId;

  const DetailPostScreen({super.key, required this.postId});

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  late int myUserId;

  @override
  void initState() {
    super.initState();
    _initializeUserIdAndFetchData();
  }

  Future<void> _initializeUserIdAndFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getInt("userId")!;

    final viewModel = Provider.of<PostViewModel>(context, listen: false);
    await viewModel.getDetailPosts(widget.postId);
    await viewModel.postCollaboration(widget.postId, myUserId);
  }

  Future<bool> _compareUserId(int userId) async {
    return myUserId == userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Post"),
      ),
      body: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          final post = viewModel.detailPosts;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            Image.network("https://picsum.photos/200/300")
                                .image,
                        radius: 25,
                      ),
                      trailing: _compareUserId(myUserId) == true
                          ? IconButton(
                              icon: const Icon(Icons.more_horiz_rounded),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: const Text("수정하기"),
                                          onTap: () {
                                            // 수정 로직
                                          },
                                        ),
                                        ListTile(
                                          title: const Text("삭제하기"),
                                          onTap: () {
                                            // 삭제 로직
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          : SizedBox(),
                      title: Text(post.writerNickname),
                      subtitle: Text(post.createdAt.substring(0, 10)),
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(post.content),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            viewModel.postCollaboration(
                                widget.postId, myUserId);
                          },
                          child: Text(viewModel.collaboration?.collaboration.status == 0
                              ? "협업 신청하기"
                              : "협업 신청 취소하기"),
                        ),
                        IconButton(
                          onPressed: () {
                            // 좋아요 로직
                          },
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
