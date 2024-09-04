import 'dart:convert';

import 'package:defaults/common/splash_screen.dart';
import 'package:defaults/common/widgets/bottom_naviagtion/main_navigation_screen.dart';
import 'package:defaults/features/authentication/interests_screen.dart';
import 'package:defaults/features/authentication/login_screen.dart';
import 'package:defaults/features/authentication/signup_screen.dart';
import 'package:defaults/features/authentication/tutorial_screen.dart';
import 'package:defaults/features/chatting/chatting_screen.dart';
import 'package:defaults/features/chatting/detail_chatting_screen.dart';
import 'package:defaults/features/collaboration/collaboration_screen.dart';
import 'package:defaults/features/community/detail_post_screen.dart';
import 'package:defaults/features/community/models/detail_posts.dart';
import 'package:defaults/features/community/modify_screen.dart';
import 'package:defaults/features/community/search_screen.dart';
import 'package:defaults/features/community/write_post_screen.dart';
import 'package:defaults/features/home/home_item_screen.dart';
import 'package:defaults/features/home/post_complete_screen.dart';
import 'package:defaults/features/home/detail_home_screen.dart';
import 'package:defaults/features/management/management_screen.dart';
import 'package:defaults/features/profile/user_modify_profile_screen.dart';
import 'package:defaults/features/profile/user_profile_screen.dart';
import 'package:defaults/features/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(initialLocation: SplashScreen.routeUrl, routes: [
  GoRoute(
      path: LoginScreen.routeUrl,
      name: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: SignUpScreen.routeUrl,
      name: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen()),
  GoRoute(
      path: InterestsScreen.routeUrl,
      name: InterestsScreen.routeName,
      builder: (context, state) => const InterestsScreen()),
  GoRoute(
      path: TutorialScreen.routeUrl,
      name: TutorialScreen.routeName,
      builder: (context, state) => const TutorialScreen()),
  GoRoute(
      path: SplashScreen.routeUrl,
      name: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen()),
  GoRoute(
    path: "/:tab(home|community|collabo|profile)",
    name: MainNavigationScreen.routeName,
    builder: (context, state) {
      final tab = state.pathParameters['tab'];
      return MainNavigationScreen(tab: tab!);
    },
  ),
  GoRoute(
    path : "/userProfile/:userId",
    name : UserProfileScreen.routeName,
    builder: (context, state){
      final userId = state.pathParameters["userId"];
      return UserProfileScreen(userId: int.parse(userId!));
    }
  ),
  GoRoute(
      path: UserModifyProfileScreen.routeUrl,
      name: UserModifyProfileScreen.routeName,
      builder: (context, state) {
        final userInfoMap = state.extra as Map<String, dynamic>;
        final userId = userInfoMap["userId"];
        return UserModifyProfileScreen(
          userId : userId,
          userName: userInfoMap["userName"],
          introduce: userInfoMap["introduce"],
          profile: userInfoMap["profile"],
          interests: List<String>.from(jsonDecode(userInfoMap["interests"])),
        );
      }),
  GoRoute(
      path: SettingsScreen.routeUrl,
      name: SettingsScreen.routeName,
      builder: (context, state) => const SettingsScreen()),
  GoRoute(
      path: SearchScreen.routeUrl,
      name: SearchScreen.routeName,
      builder: (context, state) => const SearchScreen()),
  GoRoute(
      path: ChattingScreen.routeUrl,
      name: ChattingScreen.routeName,
      builder: (context, state) => const ChattingScreen()),
  GoRoute(
      path: WritePostScreen.routeUrl,
      name: WritePostScreen.routeName,
      builder: (context, state) {
        final userId = state.extra as Map<String, int>;
        return WritePostScreen(userId: userId["userId"]!);
      }),
  GoRoute(
      path: DetailPostScreen.routeUrl,
      name: DetailPostScreen.routeName,
      builder: (context, state) {
        final postId = state.extra as Map<String, int>;
        final userId = state.extra as Map<String, int>;
        return DetailPostScreen(postId: postId["postId"]!, userId: userId["userId"]!);
      }),
  GoRoute(path: ModifyScreen.routeUrl,
  name : ModifyScreen.routeName,
  builder: (context, state){
    final detailPosts = state.extra as DetailPosts;
    return ModifyScreen(detailPosts: detailPosts,);
  }),
  GoRoute(
      path: HomeItemScreen.routeUrl,
      name: HomeItemScreen.routeName,
      builder: (context, state) {
        final post = state.extra as Map<String, String>;
        return HomeItemScreen(
            writer: post["writer"]!,
            title: post["title"]!,
            content: post["content"],
            profileUrl: post["profileUrl"]!,
            date: post["date"]!);
      }),
  GoRoute(
      path: DetailHomeScreen.routeUrl,
      name: DetailHomeScreen.routeName,
      builder: (context, state) {
        final post = state.extra as Map<String, String?>;
        return DetailHomeScreen(
          userId: post["userId"]!,
          title: post["title"]!,
          content: post["content"]!,
          createdAt: post["createdAt"]!,
          profile: post["profile"]!,
          fileUrl: post["fileUrl"],
        );
      }),
  GoRoute(
      path: PostCompleteScreen.routeUrl,
      name: PostCompleteScreen.routeName,
      builder: (context, state) => const PostCompleteScreen()),

  GoRoute(
    path: ManagementScreen.routeUrl,
    name: ManagementScreen.routeName,
    builder: (context, state) => const ManagementScreen(),
  ),

  GoRoute(path: DetailChattingScreen.routeUrl,
  name: DetailChattingScreen.routeName,
  builder: (context, state){
    final extra = state.extra as Map<String, dynamic>;
    final userId = extra["userId"] as int;
    final senderId = extra["senderId"] as int;
    final otherId = extra["otherId"] as int;
    return DetailChattingScreen(userId: userId, senderId: senderId, otherId: otherId);
  })
]);
