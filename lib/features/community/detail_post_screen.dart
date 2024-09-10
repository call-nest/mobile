import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/user_profile_screen.dart';
import 'models/detail_posts.dart';
import 'modify_screen.dart';

class DetailPostScreen extends StatefulWidget {
  static const String routeUrl = '/detailPost';
  static const routeName = "detailPost";

  final int postId;
  final int userId;

  const DetailPostScreen(
      {super.key, required this.postId, required this.userId});

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {

  late PostViewModel viewModel;
  late int receiveUserId;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<PostViewModel>(context, listen: false);

    _loadData();
  }

  void _loadData() async {
    viewModel.getDetailPosts(widget.postId);
    viewModel.getCollaboration(widget.postId);
  }

  void _goToProfileScreen(BuildContext context, int userId) {
    context.push("/userProfile/$userId", extra: userId);
  }

  void _deletePost(int postId){
    viewModel.deletePost(postId);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _modifyPost(DetailPosts post){
    context.push(ModifyScreen.routeUrl, extra: post);
  }

  void _changeStatePost(int postId, int state){

    Navigator.of(context).pop();
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
          final collaboration = viewModel.collaboration;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: InkWell(
                      onTap: () => _goToProfileScreen(context, post!.writer),
                      child: CircleAvatar(
                        backgroundImage:
                            Image.network("https://picsum.photos/200/300")
                                .image,
                        radius: 25,
                      ),
                    ),
                    trailing: widget.userId == post!.writer
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
                                        title: Text(post.isRecruit ? "마감하기" : "모집하기"),
                                        onTap: (){
                                          _changeStatePost(post.id, 1);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text("수정하기"),
                                        onTap: () {
                                          _modifyPost(post);
                                        },
                                      ),
                                      ListTile(
                                        title: const Text("삭제하기"),
                                        onTap: () {
                                          _deletePost(post.id);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        : const SizedBox(),
                    title: Text(post.writerNickname),
                    subtitle: Text(post.createdAt.substring(0, 10)),
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          // if (collaborationStatus == 1) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return AlertDialog(
                          //         title: const Text("협업 신청 취소"),
                          //         content: const Text("협업 신청을 취소하시겠습니까?"),
                          //         actions: [
                          //           TextButton(
                          //             onPressed: () {
                          //               Navigator.pop(context);
                          //             },
                          //             child: const Text("취소"),
                          //           ),
                          //           TextButton(
                          //             onPressed: () {
                          //               // viewModel.postCollaboration(
                          //               //     widget.postId, widget.userId);
                          //               Navigator.pop(context);
                          //             },
                          //             child: const Text("확인"),
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // } else {
                          //   // viewModel.postCollaboration(
                          //   //     widget.postId, widget.userId);
                          // }
                        },
                        child: Text(
                          "협업 신청하기",
                        ),
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
          );
        },
      ),
    );
  }
}
