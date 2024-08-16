import 'dart:io';

import 'package:defaults/features/home/repository/file_repository.dart';
import 'package:flutter/widgets.dart';

import '../models/post_file.dart';

class FileViewModel extends ChangeNotifier {
  final FileRepository fileRepository;

  FileViewModel({required this.fileRepository});

  List<PostFile> _files = [];
  List<PostFile> get files => _files;

  Future<void> uploadFile(String title, String description, int userId, File file) async {
    try{
      await fileRepository.postFileFromJson(title, description, userId, file);
      notifyListeners();
    }catch (e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }

  Future<void> getFiles() async{
    try{
      _files = await fileRepository.getFiles().then((value) => value.where((element) => element.status == 1).toList());
      notifyListeners();
    }catch(e){
      throw Exception('Failed to load posts, status code: ${e}');
    }
  }
}
