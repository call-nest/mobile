import 'dart:io';

import 'package:flutter/material.dart';

class ContentViewer extends StatelessWidget {

  final String filePath;
  final String mimeType;

  const ContentViewer({super.key, required this.filePath, required this.mimeType});

  @override
  Widget build(BuildContext context) {
    if (mimeType.startsWith("image/")){
      return Image.file(File(filePath));
    }else if (mimeType.startsWith('video/')){
      return Container();
    }else{
      return Text("Unsupported file type");
    }
  }
}
