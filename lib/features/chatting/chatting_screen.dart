import 'package:defaults/features/chatting/detail_chatting_screen.dart';
import 'package:defaults/features/chatting/viewmodels/chatting_viewmodel.dart';
import 'package:defaults/features/chatting/widgets/chatting_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChattingScreen extends StatefulWidget {
  static const String routeUrl = '/chatting';
  static const String routeName = 'chatting';

  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreen();
}

class _ChattingScreen extends State<ChattingScreen> {
  late ChattingViewModel _chattingViewModel;

  late int userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
    _chattingViewModel = Provider.of<ChattingViewModel>(listen: false, context);
  }

  Future<void> _getUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    userId = _prefs.getInt('userId')!;
    _chattingViewModel.getChattingList(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.12,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Chatting', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(child: Consumer<ChattingViewModel>(
              builder: (context, chattingViewModel, child) {
                return ListView.builder(
                  itemCount: chattingViewModel.chattingList.length,
                  itemBuilder: (context, index) {
                    final message = chattingViewModel.chattingList[index];
                    return InkWell(
                      onTap: () {
                        context.push(DetailChattingScreen.routeUrl, extra: {
                          "userId" : userId,
                          "senderId": userId,
                          "otherId": userId == message.senderId ? message.recipientId : message.senderId,
                        });
                      },
                      child: ChattingListWidget(
                        id: message.id,
                        content: message.content,
                        time: message.timestamp.toString(),
                      ),
                    );
                  },
                );
              },
            )),
          ],
        ));
  }
}
