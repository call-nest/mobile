import 'dart:io';

import 'package:defaults/features/home/viewmodels/file_viewModel.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const categories = ["영상", "음악", "디자인", "사진"];

class PostCompleteScreen extends StatefulWidget {
  static const routeUrl = '/postCompleteScreen';
  static const routeName = 'postCompleteScreen';

  const PostCompleteScreen({super.key});

  @override
  State<PostCompleteScreen> createState() => _PostCompleteScreenState();
}

class _PostCompleteScreenState extends State<PostCompleteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _youtubeUrlController = TextEditingController();

  String fileName = "";
  String category = "";

  int userId = 2;

  late File file;
  late final FileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<FileViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  Future<void> _getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {
        fileName = file.path.split('/').last;
      });
    } else {
      print("파일을 선택하지 않았습니다.");
    }
  }

  Future<void> _uploadFile() async {
    await viewModel.uploadFile(_titleController.text, _contentController.text, userId, file);
    context.pop();
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('파일 가져오기'),
                      onTap: () {
                        _getFile();
                        // Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("업로드 요청"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text("제목",
                  style: TextStyle(fontSize: 20, color: Colors.black))),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "제목을 입력해주세요",
              border: OutlineInputBorder(),
            ),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text("내용",
                  style: TextStyle(fontSize: 20, color: Colors.black))),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              hintText: "내용을 입력해주세요",
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "카테고리",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Spacer(),
              DropdownButton(
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value.toString();
                  });
                },
              ),
            ],
          ),
          ListTile(
            title: Text(fileName == "" ? "요청 자료 업로드해주세요." : fileName,
                style: TextStyle(fontSize: 20, color: Colors.black)),
            trailing: IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {
                _showPicker(context);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                _uploadFile();
              },
              child: Text("요청하기"),
            ),
          ),
        ],
      ),
    );
  }
}
