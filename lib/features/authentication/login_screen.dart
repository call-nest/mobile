import 'package:defaults/features/authentication/interests_screen.dart';
import 'package:defaults/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:defaults/features/authentication/widgets/form_button.dart';
import 'package:defaults/features/authentication/widgets/form_input.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  static const String routeUrl = '/';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final response = await viewModel.login(
          _emailController.text, _passwordController.text);

      if (response['statusCode'] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> token = response['data']['token'];
        Map<String, dynamic> user = response['data']['user'];
        await prefs.setString('token', token["access_token"]);
        await prefs.setInt("userId", user['id']);
        if(userViewModel.getUserInfo(user['id']) == null) {
          context.push(InterestsScreen.routeUrl);
        }else{
          context.go('/home');
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("로그인 실패"),
                content: Text(response['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("확인"),
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Align(
                  alignment: Alignment.center,
                  child: FaIcon(FontAwesomeIcons.penNib,
                      size: 80, color: Theme.of(context).primaryColor)),
              const SizedBox(height: 20),
              Text("App Name",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor)),
              const SizedBox(height: 40),
              const FormButton(
                color: Colors.yellow,
                text: "카카오 로그인",
              ),
              const SizedBox(height: 16),
              FormButton(
                color: Colors.blue.shade400,
                text: "구글 로그인",
              ),
              const SizedBox(height: 40),
              FormInput(
                controller: _emailController,
                text: "이메일을 입력해주세요.",
                icon: Icons.email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "이메일을 입력해주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              FormInput(
                controller: _passwordController,
                text: "비밀번호를 입력해주세요.",
                icon: Icons.lock,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "비밀번호를 입력해주세요.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      _login();
                    },
                    child: Text(
                      "로그인",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: "계정이 없으신가요? ",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: "회원가입",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push('/signup');
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
