import 'package:defaults/features/community/viewmodels/post_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

class WritePostScreen extends StatefulWidget {
  static const String routeUrl = '/writePost';
  static const String routeName = 'writePost';

  final int userId;

  const WritePostScreen({super.key, required this.userId});

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late PostViewModel _postViewModel;

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty && selectedCategory != null) {
      _postViewModel.writePost(widget.userId, _titleController.text, _contentController.text, selectedCategory!);
      Navigator.of(context).pop();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Write Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  "Post Title",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  "Post Content",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                maxLines: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: DropdownButton(
                  hint: Text(
                    "카테고리를 설정해주세요.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  isExpanded: true,
                  items: Constants.interests
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value.toString();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitPost();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
