import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPostScreen extends StatelessWidget {
  static const String routeUrl = '/detailPost';
  static const routeName = "detailPost";

  final int postId;

  const DetailPostScreen({super.key, required this.postId});

  Future<bool> _compareUserId(int userId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final myUserId = prefs.getInt("userId");
    return myUserId == userId;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context, listen: false);
    viewModel.getDetailPosts(postId);
    final post = viewModel.detailPosts;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Post"),
      ),
      body: FutureBuilder(
        future: viewModel.getDetailPosts(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage:
                              Image.network("https://picsum.photos/200/300")
                                  .image,
                        ),
                      ),
                      trailing: FutureBuilder(
                        future: _compareUserId(post.writer, context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.data == true) {
                              return IconButton(
                                icon: const Icon(Icons.more_horiz_rounded),
                                onPressed: () {},
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        },
                      ),
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
                    FutureBuilder(
                        future: _compareUserId(post.writer, context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.data == false) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("협업 신청하기"),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite_border)),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
