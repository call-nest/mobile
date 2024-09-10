import 'package:defaults/features/collaboration/models/detail_collaboration.dart';
import 'package:flutter/material.dart';

import '../../community/models/collaboration.dart';
import '../repository/collaboration_repository.dart';

class CollaborationViewModel extends ChangeNotifier {
  final CollaborationRepository collaborationRepository;

  CollaborationViewModel({required this.collaborationRepository});

  // List 형태로 수정
  List<Datum> _receivedCollaborations = [];
  List<Datum> _requestCollaborations = [];

  // 리스트로 Getter 수정
  List<Datum> get receivedCollaborations =>
      _receivedCollaborations;

  List<Datum> get requestCollaborations => _requestCollaborations;

  Future<void> receivedViewModel(int receivedUserId) async {
    try {
      // 리스트로 데이터를 처리
      final response =
          await collaborationRepository.receivedCollaboration(receivedUserId);

      // 데이터가 있는 경우
      if (response != null && response.isNotEmpty) {
        _receivedCollaborations = response;
      } else {
        _receivedCollaborations = [];
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get received collaboration, status code: $e');
    }
  }

  Future<void> requestViewModel(int requestUserId) async {
    try {
      final response =
          await collaborationRepository.requestCollaboration(requestUserId);

      _requestCollaborations = response;

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get request collaboration, status code: $e');
    }
  }
}
