import 'dart:async';

import 'package:defaults/common/widgets/bottom_naviagtion/main_navigation_screen.dart';
import 'package:defaults/features/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  static const String routeUrl = '/splash';
  static const routeName = "splash";
  const SplashScreen({super.key});

  Future<bool> _hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () async{
      if(await _hasToken()) {
        context.go("/home");
      }else{
        context.go(LoginScreen.routeUrl);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("로딩 중..."),
          ],
        ),
      ),);
  }
}
