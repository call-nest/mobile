import 'package:defaults/common/widgets/bottom_naviagtion/widgets/navtab.dart';
import 'package:defaults/features/collaboration/collaboration_screen.dart';
import 'package:defaults/features/community/community_screen.dart';
import 'package:defaults/features/profile/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../features/home/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeUrl = '/mainNavigation';
  static const routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({super.key, required this.tab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "community",
    "xxx",
    "collabo",
    "profile"
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int idx) {
    context.go("/${_tabs[idx]}");
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
              offstage: _selectedIndex != 1, child: const CommunityScreen()),
          // Offstage(
          //   offstage: _selectedIndex != 2,
          //   child: Container(
          //     color: Colors.green,
          //     child: Center(
          //       child: Text("xxx"),
          //     ),
          //   ),
          // ),
          Offstage(offstage: _selectedIndex != 3, child: const CollaborationScreen()),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTab(
                  text: "Home",
                  isSelected: _selectedIndex == 0,
                  icon: FontAwesomeIcons.house,
                  selectedIcon: FontAwesomeIcons.house,
                  onTap: () => _onTap(0),
                  selectedIndex: _selectedIndex),
              NavTab(
                  text: "Community",
                  isSelected: _selectedIndex == 1,
                  icon: FontAwesomeIcons.users,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  onTap: () => _onTap(1),
                  selectedIndex: _selectedIndex),
              SizedBox(height: 24),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     width: 45,
              //     height: 45,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
              SizedBox(height: 24),
              NavTab(
                  text: "Collabo",
                  isSelected: _selectedIndex == 3,
                  icon: FontAwesomeIcons.handshake,
                  selectedIcon: FontAwesomeIcons.solidHandshake,
                  onTap: () => _onTap(3),
                  selectedIndex: _selectedIndex),
              NavTab(
                  text: "Profile",
                  isSelected: _selectedIndex == 4,
                  icon: FontAwesomeIcons.user,
                  selectedIcon: FontAwesomeIcons.solidUser,
                  onTap: () => _onTap(4),
                  selectedIndex: _selectedIndex),
            ],
          ),
        ),
      ),
    );
  }
}
