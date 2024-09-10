import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:defaults/features/chatting/detail_chatting_screen.dart';
import 'package:defaults/features/community/detail_post_screen.dart';
import 'package:defaults/features/profile/user_modify_profile_screen.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:defaults/features/profile/widgets/persistent_tab_bar.dart';
import 'package:defaults/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  static const routeName = "userProfile";

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    viewModel.getUserInfo(widget.userId);
    viewModel.getUserPosts(widget.userId);
  }

  void _onTapEditProfile() {
    final userInfoMap = {
      "userId": widget.userId,
      "userName": viewModel.userInfo?.data.user.nickname ?? "",
      "introduce": viewModel.userInfo?.data.user.introduce ?? "",
      "profile": viewModel.userInfo?.data.user.profile ?? "",
      "interests": jsonEncode(viewModel.userInfo?.data.user.interests),
    };
    context.push(UserModifyProfileScreen.routeUrl, extra: userInfoMap);
  }

  void _goToDetailChattingScreen(int myId, int userId) {
    context.push(DetailChattingScreen.routeUrl, extra: {"userId": myId, "otherId": userId});
  }

  void _goDetailPostScreen(int postId) {
    context.push(DetailPostScreen.routeUrl, extra: {"postId": postId, "userId": widget.userId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildAppBar(),
                _buildProfileSection(),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(children: [
              _buildProjectsGrid(),
              _buildPostsGrid(),
            ]),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      centerTitle: true,
      title: const Text("Profile"),
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.gear, size: 20),
          onPressed: () {
            context.push(SettingsScreen.routeUrl);
          },
        ),
        IconButton(
          onPressed: () => _goToDetailChattingScreen(widget.userId, widget.userId),
          icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 20),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return SliverToBoxAdapter(
      child: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          final userInfo = viewModel.userInfo?.data;
          if (userInfo == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              CachedNetworkImage(
                imageUrl: userInfo.user.profile ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.person),
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                userInfo.user.nickname,
                style: const TextStyle(fontSize: 25, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  userInfo.user.introduce ?? "",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _onTapEditProfile,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildStatsSection(),
              const SizedBox(height: 20),
              const Text("나의 관심분야"),
              const SizedBox(height: 20),
              _buildInterestsWrap(userInfo.user.interests),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn("게시물 수", viewModel.userPosts?.data.length.toString() ?? "0"),
        _buildVerticalDivider(),
        _buildStatColumn("협업 요청", "10"),
        _buildVerticalDivider(),
        _buildStatColumn("협업 중", "5"),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: VerticalDivider(color: Colors.black, thickness: 2),
      ),
    );
  }

  Widget _buildInterestsWrap(List<String> interests) {
    return Wrap(
      runSpacing: 15,
      spacing: 15,
      children: [
        for (var interest in interests)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]),
            child: Text(interest),
          ),
      ],
    );
  }

  Widget _buildProjectsGrid() {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                height: 90,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("프로젝트 이름"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("프로젝트 설명"),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsGrid() {
    return Consumer<UserViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.userPosts?.data.isEmpty ?? true) {
          return const Center(child: Text("게시물이 없습니다."));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (BuildContext context, int index) {
            final post = viewModel.userPosts!.data[index];
            return InkWell(
              onTap: () => _goDetailPostScreen(post.id),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(post.title),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.isRecruit ? "모집중" : "모집완료",
                        style: TextStyle(
                            color: post.isRecruit ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: viewModel.userPosts?.data.length,
        );
      },
    );
  }
}
