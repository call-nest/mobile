import 'dart:convert';

import 'package:defaults/common/splash_screen.dart';
import 'package:defaults/common/widgets/bottom_naviagtion/main_navigation_screen.dart';
import 'package:defaults/features/authentication/interests_screen.dart';
import 'package:defaults/features/authentication/login_screen.dart';
import 'package:defaults/features/authentication/signup_screen.dart';
import 'package:defaults/features/authentication/tutorial_screen.dart';
import 'package:defaults/features/chatting/chatting_screen.dart';
import 'package:defaults/features/collaboration/collaboration_screen.dart';
import 'package:defaults/features/community/detail_post_screen.dart';
import 'package:defaults/features/community/search_screen.dart';
import 'package:defaults/features/community/write_post_screen.dart';
import 'package:defaults/features/home/home_item_screen.dart';
import 'package:defaults/features/home/show_youtube_screen.dart';
import 'package:defaults/features/profile/user_modify_profile_screen.dart';
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
      path: UserModifyProfileScreen.routeUrl,
      name: UserModifyProfileScreen.routeName,
      builder: (context, state) {
        final userInfoMap = state.extra as Map<String, dynamic>;
        return UserModifyProfileScreen(
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
      builder: (context, state) => const WritePostScreen()),
  GoRoute(
      path: DetailPostScreen.routeUrl,
      name: DetailPostScreen.routeName,
      builder: (context, state) {
        final postId = state.extra as Map<String, int>;
        return DetailPostScreen(postId: postId["postId"]!);
      }),

  GoRoute(path: HomeItemScreen.routeUrl,
  name : HomeItemScreen.routeName,
  builder: (context, state){
    final post = state.extra as Map<String, String>;
    return HomeItemScreen(
      writer: post["writer"]!,
      title: post["title"]!,
      content: post["content"]!,
      date: post["date"]!
    );
  }),

  GoRoute(path: ShowYoutubeScreen.routeUrl, name: ShowYoutubeScreen.routeName,
  builder: (context, state){
    final post = state.extra as Map<String, String>;
    return ShowYoutubeScreen(
      writer: post["writer"]!,
      title: post["title"]!,
      content: post["content"]!,
      youtubeUrl: post["youtubeUrl"]!,
      createdAt: post["createdAt"]!,
      profile: post["profile"]!
    );
  }),
]);
