import 'dart:async';

import 'package:defaults/common/validation.dart';
import 'package:defaults/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:defaults/features/authentication/widgets/form_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeUrl = '/signup';
  static const routeName = "signup";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();

  bool _isVerificationCodeSend = false;
  String _receivedVerificationCode = "인증번호 받기";
  String _verifyButtonText = "중복확인";

  late Timer _timer;
  int _remainingTime = 180;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nicknameController.dispose();
    _verificationCodeController.dispose();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void _sendOtp() {
    if(_emailController.text == null || _emailController.text.isEmpty || Validation.isEmail(_emailController.text) == false){
      _showDialog(
        title: "알림",
        content: "이메일 형식에 맞지 않거나 입력되지 않았습니다.",
      );
      return;
    }
    else {
      _isVerificationCodeSend = true;
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      viewModel.sendEmail(_emailController.text);
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _receivedVerificationCode = _formatTime(_remainingTime);
        } else {
          _timer.cancel();
          _receivedVerificationCode = "인증번호 받기";
          _isVerificationCodeSend = false;
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyNickName() async {
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    await viewModel.verifyNickname(_nicknameController.text);
    final isAvailable = viewModel.verifyNickName == "사용 가능한 닉네임입니다.";
    _showDialog(
      title: "알림",
      content: isAvailable ? "사용 가능한 닉네임입니다." : "이미 사용중인 닉네임입니다.",
    );
    setState(() {
      _verifyButtonText = isAvailable ? "확인" : "중복확인";
    });
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _verifyButtonText == "확인") {
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      final result = await viewModel.signUp(
        _emailController.text,
        _passwordController.text,
        _nicknameController.text,
      );
      final isSignUpSuccessful = result['statusCode'] == 201;
      _showDialog(
        title: "알림",
        content: isSignUpSuccessful ? "회원가입이 완료되었습니다." : "이미 계정이 존재합니다.",
      );
      if (isSignUpSuccessful) {
        context.go('/');
      }
    } else {
      _showDialog(
        title: "알림",
        content: "닉네임 중복확인을 진행해주세요.",
      );
    }
  }

  Future<void> _verifyCode() async {
    if(_verificationCodeController.text.isEmpty){
      _showDialog(
        title: "알림",
        content: "인증번호를 입력해주세요.",
      );
      return;
    }else {
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      final result = await viewModel.verifyEmail(
          _emailController.text, int.parse(_verificationCodeController.text));
      final isVerified = result['statusCode'] == 200;
      _showDialog(
        title: "알림",
        content: isVerified ? "인증되었습니다." : "인증번호가 일치하지 않습니다.",
      );
    }
  }

  Widget _buildFormInput({
    required TextEditingController controller,
    required String text,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return FormInput(
      controller: controller,
      text: text,
      icon: icon,
      validator: validator,
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Container(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "App Name",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 20),
              const Text("회원가입을 진행해주세요.", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildFormInput(
                      controller: _emailController,
                      text: "이메일을 입력해주세요",
                      icon: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "이메일을 입력해주세요.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildButton(
                      onPressed: () {
                        _sendOtp();
                      },
                      text: _receivedVerificationCode,
                    ),
                  ),
                ],
              ),
              if (_isVerificationCodeSend) ...[
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildFormInput(
                        controller: _verificationCodeController,
                        text: "인증번호를 입력해주세요",
                        icon: Icons.check_circle,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "인증번호를 입력해주세요.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildButton(
                        onPressed: _verifyCode,
                        text: "인증하기",
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildFormInput(
                      controller: _nicknameController,
                      text: "닉네임을 입력해주세요",
                      icon: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "닉네임을 입력해주세요.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildButton(
                      onPressed: _verifyNickName,
                      text: _verifyButtonText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFormInput(
                controller: _passwordController,
                text: "비밀번호를 입력해주세요",
                icon: Icons.lock,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "비밀번호를 입력해주세요.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildFormInput(
                controller: _passwordConfirmController,
                text: "비밀번호를 다시 입력해주세요",
                icon: Icons.lock,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "비밀번호를 다시 입력해주세요.";
                  }
                  if (value != _passwordController.text) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: _buildButton(
                  onPressed: _signUp,
                  text: "회원가입",
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              text: "이미 계정이 있으신가요? ",
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: "로그인",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pop();
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
