import 'package:defaults/features/community/repository/post_repository.dart';
import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:defaults/features/profile/repository/user_repository.dart';
import 'package:defaults/features/profile/viewmodel/user_viewmodel.dart';
import 'package:defaults/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'features/authentication/repository/auth_repository.dart';
import 'features/authentication/viewmodel/auth_viewmodel.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // initializeNotification();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBarckgroundHandler(RemoteMessage message) async{
  print('Handling a background message: ${message.messageId}');
}

void initializeNotification() async{
  // 알림 초기화
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBarckgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(const AndroidNotificationChannel('high_importance_channel',
  'high_importance_notification', importance: Importance.max));

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
        ChangeNotifierProvider(create: (context) => AuthViewModel(authRepository: AuthRepository())),
        ChangeNotifierProvider(create: (context) => UserViewModel(userRepository: UserRepository())),
        ChangeNotifierProvider(create: (context) => PostViewModel(postRepository : PostRepository()))
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
