import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String appName = 'Flutter Ecommerce App';
  static const String baseUrl = "http://192.168.123.103:8000/";

  static const interests = [
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

  static const categories = [
    "전체",
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

  static final Constants _instance = Constants._internal();

  factory Constants() {
    return _instance;
  }

  Constants._internal() {}

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get userId => _prefs.getInt('userId') ?? 0;
}
