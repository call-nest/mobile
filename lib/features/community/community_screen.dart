import 'package:defaults/features/community/detail_post_screen.dart';
import 'package:defaults/features/community/models/posts.dart';
import 'package:defaults/features/community/search_screen.dart';
import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:defaults/features/community/widgets/posts_widget.dart';
import 'package:defaults/features/community/write_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  ScrollController _scrollController = ScrollController();
  late PostViewModel viewModels;

  String selectedFilter = "All";
  bool isLoading = false;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    viewModels = Provider.of<PostViewModel>(context, listen: false);
    viewModels.getPosts(pageIndex);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      isLoading = true;
    });
    pageIndex++;
    await viewModels.getPosts(pageIndex);
    setState(() {
      isLoading = false;
    });
  }

  void _goToWritePost() {
    context.push(WritePostScreen.routeUrl);
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
        title: const Text("Community"),
        actions: [
          DropdownButton(
            items: ["All", "Following", "Popular"]
                .map((e) => DropdownMenuItem(child: Text(e), value: e))
                .toList(),
            value: selectedFilter,
            onChanged: (value) {
              setState(() {
                selectedFilter = value.toString();
              });
            },
          ),
          IconButton(
            onPressed: () {
              context.push(SearchScreen.routeUrl);
            },
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.paperPlane),
          ),
        ],
      ),
      // Consumer 는 ViewModel 의 데이터가 변경될 때마다 화면을 다시 그리게 해준다.
      body: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          if (isLoading && viewModel.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.posts.isEmpty) {
            return const Center(child: Text("No posts available"));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: viewModel.posts.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < viewModel.posts.length) {
                final post = viewModel.posts[index];
                return InkWell(
                  onTap: () {
                    context.push(DetailPostScreen.routeUrl,
                        extra: {"postId": post.id});
                  },
                  child: PostsWidget(
                    title: post.title,
                    content: post.content,
                    writer: post.writerNickname,
                    isRecruit: post.isRecruit,
                    createdAt: post.createdAt.substring(0, 10),
                    updatedAt: post.updatedAt,
                    isDeleted: post.isDeleted,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToWritePost(),
        child: FaIcon(FontAwesomeIcons.penNib),
      ),
    );
  }
}
