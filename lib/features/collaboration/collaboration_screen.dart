import 'package:defaults/features/collaboration/viewmodel/collaboration_viewmodel.dart';
import 'package:defaults/features/collaboration/widget/persistent_tab_bar.dart';
import 'package:defaults/features/collaboration/widget/widget_collaboration_item.dart';
import 'package:defaults/features/community/detail_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollaborationScreen extends StatefulWidget {
  const CollaborationScreen({super.key});

  @override
  State<CollaborationScreen> createState() => _CollaborationScreenState();
}

class _CollaborationScreenState extends State<CollaborationScreen>
    with SingleTickerProviderStateMixin {
  late CollaborationViewModel _collaborationViewModel;

  late TabController _tabController =
  TabController(length: 2, vsync: this, initialIndex: 0);

  late int userId;

  @override
  void initState() {
    super.initState();
    _collaborationViewModel =
        Provider.of<CollaborationViewModel>(context, listen: false);

    _initUserItem();
  }

  Future<void> _initUserItem() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId")!;

    await _collaborationViewModel.receivedViewModel(userId);
    await _collaborationViewModel.requestViewModel(userId);
  }

  void _goToDetailPosts(int postId) {
    context.push(
        DetailPostScreen.routeUrl, extra: {"postId": postId, "userId": userId});
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                  _buildAppBar(),
                  SliverPersistentHeader(
                    delegate: PersistentTabBar(),
                    pinned: true,
                  )
                ];
              },
              body: TabBarView(
                children: [
                  _buildRequestCollaboration(),
                  _buildReceivedCollaboration()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      centerTitle: true,
      title: const Text('Collaboration'),
    );
  }

  Widget _buildReceivedCollaboration() {
    return Consumer<CollaborationViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.receivedCollaborations.length,
            itemBuilder: (context, index) {
              final item = viewModel.receivedCollaborations[index];
              return WidgetCollaborationItem(title: item.postTitle,
                  name: item.receiverNickname,
                  date: item.collaboration.createdAt.toString(),
                  state: item.collaboration.status.toString(),
                  type: "receive");
            },
          );
        });
  }

  Widget _buildRequestCollaboration() {
    return Consumer<CollaborationViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.requestCollaborations.length,
            itemBuilder: (context, index) {
              final item = viewModel.requestCollaborations[index];
              return InkWell(
                onTap: () {
                  _goToDetailPosts(item.collaboration.postId);
                },
                child: WidgetCollaborationItem(
                    title: item.postTitle,
                    name: item.receiverNickname,
                    date: item.collaboration.createdAt.toString(),
                    state: item.collaboration.status.toString(),
                    type: "request"),
              );
            },
          );
        });
  }
}
