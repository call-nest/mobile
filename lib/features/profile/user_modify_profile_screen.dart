import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

  final int userId;
  final String userName;
  final String introduce;
  final String profile;
  final List<String> interests;

  const UserModifyProfileScreen(
      {super.key,
        required this.userId,
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

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _introduceController = TextEditingController();

  File? _image; // 선택한 이미지 파일
  String? _profileImageUrl; // 네트워크 이미지 URL

  late UserViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<UserViewModel>(context, listen: false);
    _userNameController.text = widget.userName;
    _introduceController.text = widget.introduce;
    _profileImageUrl = widget.profile; // 초기 URL 설정
    selectedInterests = widget.interests;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _introduceController.dispose();
    super.dispose();
  }

  Future<File> _downloadNetworkImage(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/downloaded_image.jpg';

      final response = await Dio().download(url, path);

      return File(path);
    } catch (e) {
      throw Exception('이미지 다운로드 실패: $e');
    }
  }

  void _saveProfile() async {
    try {
      File? imageFile;

      if (_image != null) {
        imageFile = _image;
      } else if (_profileImageUrl != null) {
        imageFile = await _downloadNetworkImage(_profileImageUrl!);
      }

      if (imageFile != null) {
        await _viewModel.updateUserInfo(
          widget.userId,
          imageFile,
          _userNameController.text,
          _introduceController.text,
          selectedInterests,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("프로필 업데이트 실패: $e");
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final imageFile = File(image.path);
    setState(() {
      _image = imageFile;
      _profileImageUrl = null; // 네트워크 이미지 URL을 null로 설정하여 캐시를 무시
    });
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
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_image!), // 선택한 이미지가 있으면 FileImage 사용
                    )
                        : CachedNetworkImage(
                      imageUrl: _profileImageUrl ?? '',
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.camera,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("닉네임"),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  hintText: "닉네임을 입력해주세요",
                ),
              ),
              SizedBox(height: 20),
              Text("자기 소개"),
              TextFormField(
                controller: _introduceController,
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
                    ),
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
            onPressed: _saveProfile,
            child: Text("저장", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
