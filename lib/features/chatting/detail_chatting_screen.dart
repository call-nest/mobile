import 'package:defaults/features/chatting/viewmodels/chatting_viewmodel.dart';
import 'package:defaults/features/chatting/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailChattingScreen extends StatefulWidget {
  static const String routeUrl = '/detailChatting';
  static const routeName = "detailChatting";

  final int userId;
  final int senderId;
  final int otherId;

  const DetailChattingScreen(
      {super.key, required this.userId, required this.senderId, required this.otherId});

  @override
  State<DetailChattingScreen> createState() => _DetailChattingScreenState();
}

class _DetailChattingScreenState extends State<DetailChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late ChattingViewModel _chattingViewModel;

  @override
  void initState() {
    super.initState();
    _chattingViewModel = Provider.of<ChattingViewModel>(context, listen: false);
    _chattingViewModel.getChatting(widget.senderId, widget.otherId);
    _chattingViewModel.connectWebSocket(widget.userId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chattingViewModel.disconnectWebSocket();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chattingViewModel.sendMessage(widget.userId, widget.otherId, _messageController.text);
      _chattingViewModel.sendWebSocket(widget.otherId, _messageController.text);
      _messageController.clear();

      // 메시지 전송 후 스크롤 제일 밑으로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          _chattingViewModel.recipientInfo?.id == widget.userId
              ? _chattingViewModel.senderInfo!.nickname
              : _chattingViewModel.recipientInfo!.nickname,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<ChattingViewModel>(
          builder: (context, chattingViewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: chattingViewModel.messages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final message = chattingViewModel.messages[index];
                      final userId = widget.userId;
                      return ChatBubble(
                        message: message.content,
                        isMe: userId == message.senderId,
                        time: message.timestamp,
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: (){
                          _sendMessage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
