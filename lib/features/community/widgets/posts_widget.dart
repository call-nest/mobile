import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsWidget extends StatelessWidget {
  final String title;
  final String content;
  final String writer;
  final bool isRecruit;
  final String createdAt;
  final String? updatedAt;
  final bool isDeleted;

  const PostsWidget(
      {super.key,
      required this.title,
      required this.content,
      required this.writer,
      required this.isRecruit,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  createdAt,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  writer,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    isRecruit ? "모집중" : "마감",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}
