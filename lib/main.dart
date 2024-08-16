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
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'features/authentication/repository/auth_repository.dart';
import 'features/authentication/viewmodel/auth_viewmodel.dart';

import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // initializeNotification();

  // ios 권한 요청
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  messaging.getToken().then((String? token){
    assert(token != null);
    print('Push Messaging token: $token');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print("Received Message: ${message.notification?.title}");
  });

  runApp(const MyApp());
}

Future<void> sendTokentoServer(String token) async{
  final url = Uri.parse("${Constants.baseUrl}users/token");
  final response = await http.post(
    url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'token': token,
    }),
  );

  if(response.statusCode == 200){
    print('Token sent to server');
  } else {
    throw Exception('Failed to send token to server');
  }
}

Future<void> _firebaseMessagingBarckgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void initializeNotification() async {
  // 알림 초기화
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBarckgroundHandler);

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
                ManageViewModel(manageRepository: ManageRepository()))
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
