import 'package:defaults/features/authentication/tutorial_screen.dart';
import 'package:defaults/features/authentication/viewmodel/auth_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class InterestsScreen extends StatefulWidget {
  static const String routeUrl = '/interests';
  static const routeName = "interests";

  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final _scrollController = ScrollController();

  bool _showTitle = true;

  List<String> selectedInterests = [];

  int userId = 0;

  void _onScroll() {
    if (_scrollController.offset > 100) {
      setState(() {
        _showTitle = true;
      });
    } else {
      setState(() {
        _showTitle = false;
      });
    }
  }

  Future<void> _saveInterests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId") ?? 0;
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final response = await viewModel.saveInterests(userId, selectedInterests);
    if (response['statusCode'] == 200) {
      context.push(TutorialScreen.routeUrl);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("관심 분야 저장 실패"),
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _showTitle ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: const Text('', style: TextStyle(color: Colors.black)),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Text("관심 분야를 최대 3개 선택해주세요.",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(
                  height: 64,
                ),
                for (var interest in interests)
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: [
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
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: CupertinoButton(
                child: Text("다음"),
                onPressed: () {
                  _saveInterests();
                },
                color: Theme.of(context).primaryColor,
              ))),
    );
  }
}
