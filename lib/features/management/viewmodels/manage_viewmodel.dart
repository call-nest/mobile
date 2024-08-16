import 'package:defaults/features/management/models/files.dart';
import 'package:defaults/features/management/repository/manage_repository.dart';
import 'package:flutter/cupertino.dart';

class ManageViewModel extends ChangeNotifier {
  final ManageRepository manageRepository;

  ManageViewModel({required this.manageRepository});

  List<Files> _files = [];

  List<Files> get files => _files;

  late Files _file;
  get file => _file;

  Future<void> getFiles() async {
    try {
      _files = await manageRepository.getFiles();
      notifyListeners();
    }catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<void> updateFile(int fileId, int status) async {
    try {
      _file = await manageRepository.updateFile(fileId, status);
      notifyListeners();
    }catch(e){
      throw Exception('Failed to update file, status code: ${e}');
    }
  }

}