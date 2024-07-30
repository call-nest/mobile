import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/getpermissions.dart';

const interests = [
  "작곡",
  "작사",
  "보컬",
  "작가",
  "연기",
  "연출",
  "촬영",
  "편집",
  "유튜브 크리에이터",
  "프로그래밍",
  "디자인",
  "그래픽 디자인",
  "기획"
];

class UserModifyProfileScreen extends StatefulWidget {
  static const routeName = "userModifyProfile";
  static const routeUrl = "/userModifyProfile";

  final String userName;
  final String introduce;
  final String profile;
  final List<String> interests;

  const UserModifyProfileScreen(
      {super.key,
      required this.userName,
      required this.introduce,
      required this.profile,
      required this.interests});

  @override
  State<UserModifyProfileScreen> createState() =>
      _UserModifyProfileScreenState();
}

class _UserModifyProfileScreenState extends State<UserModifyProfileScreen> {
  List<String> selectedInterests = [];

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {

  }

  Future<void> _requestPermissions() async {
    GetPermissions.getCameraPermission();
    GetPermissions.getStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("프로필 수정"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: FaIcon(FontAwesomeIcons.circleUser, size: 100),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("프로필 사진 변경"),
                  ),
                ),
                SizedBox(height: 20),
                Text("닉네임"),
                TextFormField(
                  initialValue: widget.userName,
                  decoration: InputDecoration(
                    hintText: "닉네임을 입력해주세요",
                  ),
                ),
                SizedBox(height: 20),
                Text("자기 소개"),
                TextFormField(
                  initialValue: widget.introduce,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "자기 소개를 입력해주세요",
                  ),
                ),
                SizedBox(height: 20),
                Text("관심사"),
                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 15,
                  spacing: 15,
                  children: [
                    for (var interest in interests)
                      ChoiceChip(
                        label: Text(interest),
                        selected: selectedInterests.contains(interest),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              if (selectedInterests.length < 3) {
                                selectedInterests.add(interest);
                              }
                            } else {
                              selectedInterests.remove(interest);
                            }
                          });
                        },
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              child: Text("저장", style: TextStyle(color: Colors.white)),
            ),
          ),
        ));
  }
}
