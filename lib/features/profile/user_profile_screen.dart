import 'dart:convert';

import 'package:defaults/features/profile/models/user_info.dart';
import 'package:defaults/features/profile/models/user_interests.dart';
import 'package:defaults/features/profile/user_modify_profile_screen.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:defaults/features/profile/widgets/persistent_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_screen.dart';
import 'models/user_posts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "";
  List<String> interests = [];
  String? introduce = "";
  String? profile = "";

  late UserViewModel viewModel;


  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId")!;
    UserInfo userInfo = await viewModel.getUserInfo(userId);
    userName = userInfo.data.user.nickname;
    introduce = userInfo.data.user.introduce == null
        ? "자신을 알려주기 위해 자기 소개를 작성해주세요."
        : userInfo.data.user.introduce;
    UserInterests userInterests = await viewModel.getUserInterests(userId);
    interests = userInterests.data.interests;
  }

  Future<void> _getUserPosts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId")!;
    await viewModel.getUserPosts(userId);
  }

  void _onTapEditProfile() {
    final userInfoMap = {
      "userName": userName,
      "introduce": introduce!,
      "profile": profile,
      "interests": jsonEncode(interests),
    };
    context.push(UserModifyProfileScreen.routeUrl, extra: userInfoMap);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!mounted) return;
      viewModel = Provider.of<UserViewModel>(context, listen: false);
      _getUserInfo();
      _getUserPosts();

  }

  @override
  void dispose() {
    super.dispose();
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
                  SliverAppBar(
                    centerTitle: true,
                    title: Text("Profile"),
                    actions: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.gear, size: 20),
                        onPressed: () {
                          context.push(SettingsScreen.routeUrl);
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.circleUser, size: 100),
                        ),
                        SizedBox(height: 20),
                        Text(
                          userName,
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            introduce!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            _onTapEditProfile();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor),
                            child: Text(
                              "Edit Profile",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        const IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text("게시물 수"),
                                    Text(
                                      "0",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: VerticalDivider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text("협업 요청"),
                                    Text(
                                      "10",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: VerticalDivider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text("협업 중"),
                                    Text(
                                      "5",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("나의 관심분야"),
                        SizedBox(height: 20),
                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            for (var interest in interests)
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200]),
                                child: Text(interest),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: PersistentTabBar(),
                    pinned: true,
                  )
                ];
              },
              body: TabBarView(children: [
                GridView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("프로젝트 이름"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("프로젝트 설명"),
                            )
                          ],
                        ),
                      );
                    }),
                Consumer<UserViewModel>(
                  builder: (context, viewModel, child){
                    if(viewModel.userPosts?.data.isEmpty ?? true){
                      return Center(child: Text("게시물이 없습니다."),);
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (BuildContext context, int index) {
                        final post = viewModel.userPosts!.data[index];
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(post.title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(post.content),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: viewModel.userPosts?.data.length,
                    );
                  },
                )
              ])),
        ),
      ),
    );
  }
}
