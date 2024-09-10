import 'package:defaults/common/constants.dart';
import 'package:defaults/features/collaboration/models/detail_collaboration.dart';
import 'package:dio/dio.dart';

import '../../community/models/collaboration.dart';

class CollaborationRepository {
  final Dio _dio = Dio();

  Future<List<Datum>?> receivedCollaboration(int receivedUserId) async {
    final url =
        "${Constants.baseUrl}collaborations/$receivedUserId/received_collaborations";
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;

        List<dynamic> dataList = jsonResponse['data'];

        List<Datum> collaborations = dataList.map((e) => Datum.fromJson(e)).toList();

        return collaborations;
      } else {
        throw Exception("Failed to load collaboration");
      }
    } catch (e) {
      throw Exception("Failed to load collaboration");
    }
  }

  Future<List<Datum>> requestCollaboration(int requestUserId) async {
    final url =
        "${Constants.baseUrl}collaborations/$requestUserId/user_collaborations";
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;

        List<dynamic> dataList = jsonResponse['data'];

        List<Datum> collaborations = dataList.map((e) => Datum.fromJson(e)).toList();

        return collaborations;
      } else {
        throw Exception("Failed to load collaboration");
      }
    } catch (e) {
      throw Exception("Failed to load collaboration");
    }
  }
}
