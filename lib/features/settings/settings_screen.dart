import 'package:defaults/features/authentication/login_screen.dart';
import 'package:defaults/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/viewmodel/user_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  static const routeUrl = "/settings";
  static const routeName = "settings";

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String password = "";

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("token");
    context.go(LoginScreen.routeUrl);
  }

  Future<void> _deleteAccount() async {
    final viewModel = Provider.of<UserViewModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("회원 탈퇴"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("정말로 회원 탈퇴를 진행하시겠습니까?"),
                TextField(
                  decoration: InputDecoration(labelText: "비밀번호를 입력해주세요."),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () async {
                  final response =
                      await viewModel.deleteAccount(userId!, password);
                  if (response['statusCode'] == 200) {
                    _logout();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['detail'])));
                  }
                },
                child: Text("확인"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            "앱 설정",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("다크 모드"),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        ListTile(
          title: Text("알림 설정"),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            "계정 관리",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text("비밀번호 변경"),
          onTap: () {
            // 비밀번호 변경 로직
          },
        ),
        ListTile(
          title: Text("로그아웃"),
          onTap: () {
            _logout();
          },
        ),
        ListTile(
          title: Text("회원 탈퇴", style: TextStyle(color: Colors.red)),
          onTap: () {
            _deleteAccount();
          },
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            "법률 및 정책",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: FlutterLogo(size: 24),
          title: Text("이용약관"),
          onTap: () {},
        ),
      ]),
    );
  }
}
