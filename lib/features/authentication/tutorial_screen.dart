import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Direction { left, right }

enum Page { first, second }

class TutorialScreen extends StatefulWidget {
  static const String routeUrl = '/tutorial';
  static const routeName = "tutorial";

  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  Direction _direction = Direction.right;

  Page _showingPage = Page.first;

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      if (_direction == Direction.right) return;
      setState(() {
        _direction = Direction.right;
      });
    } else {
      if (_direction == Direction.left) return;
      setState(() {
        _direction = Direction.left;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_direction == Direction.right) {
      setState(() {
        _showingPage = Page.first;
      });
    } else {
      setState(() {
        _showingPage = Page.second;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _onPanUpdate(details);
      },
      onPanEnd: _onPanEnd,
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text('Welcome to the app',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(
                    'This is a tutorial screen. You can swipe left or right to see the next page.',
                    style: TextStyle(fontSize: 16)),

              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text('Second page',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(
                    'This is the second page. You can swipe left or right to see the previous page.',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            crossFadeState: _showingPage == Page.first
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Container(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showingPage == Page.second ? 1 : 0,
              child: CupertinoButton(
                color: Theme.of(context).primaryColor,
                onPressed: (){
                  context.go("/home");
                },
                child: Text("시작하기"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
