import 'dart:convert';

import 'package:defaults/features/community/repository/post_repository.dart';
import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:defaults/features/home/repository/file_repository.dart';
import 'package:defaults/features/home/viewmodels/file_viewModel.dart';
import 'package:defaults/features/management/repository/manage_repository.dart';
import 'package:defaults/features/management/viewmodels/manage_viewmodel.dart';
import 'package:defaults/features/profile/repository/user_repository.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:defaults/firebase_options.dart';
import 'package:defaults/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'PushNotification.dart';
import 'common/constants.dart';
import 'features/authentication/repository/auth_repository.dart';
import 'features/authentication/viewmodel/auth_viewmodel.dart';

import 'package:http/http.dart' as http;

import 'features/chatting/repository/chatting_repository.dart';
import 'features/chatting/viewmodels/chatting_viewmodel.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// 반드시 main 함수 외부에 작성 (= 최상위 수준 함수여야 함)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null)
    print('Handling a background message ${message.messageId}');
}

Future<void> setupInteractedMessage() async {
  // 앱이 종료된 상태에서 열릴 때 getInitialMessage 호출
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // 앱이 백그라운드 상태일 때, 푸시 알림을 탭할 때 RemoteMessage cjfl
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

// FCM 에서 전송한 data 처리, 알림 처리
void _handleMessage(RemoteMessage message) {
  Future.delayed(const Duration(seconds: 1), () {
    navigatorKey.currentState!.pushNamed("/message", arguments: message);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  PushNotification.init();
  PushNotification.localNotiInit();

  // ios 권한 요청
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payload = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payload);
    }
  });

  final prefs = Constants();

  await prefs.init();

  runApp(const MyApp());
}

Future<void> sendTokentoServer(String token) async {
  final url = Uri.parse("${Constants.baseUrl}users/token");
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'token': token,
    }),
  );

  if (response.statusCode == 200) {
    print('Token sent to server');
  } else {
    throw Exception('Failed to send token to server');
  }
}

void initializeNotification() async {
  // 알림 초기화
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AuthViewModel(authRepository: AuthRepository())),
        ChangeNotifierProvider(
            create: (context) =>
                UserViewModel(userRepository: UserRepository())),
        ChangeNotifierProvider(
            create: (context) =>
                PostViewModel(postRepository: PostRepository())),
        ChangeNotifierProvider(
            create: (context) =>
                FileViewModel(fileRepository: FileRepository())),
        ChangeNotifierProvider(
            create: (context) =>
                ManageViewModel(manageRepository: ManageRepository())),
        ChangeNotifierProvider(
            create: (context) =>
                ChattingViewModel(chattingRepository: ChattingRepository()))
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          primaryColor: Color(0xFFFF784b),
        ),
      ),
    );
  }
}
