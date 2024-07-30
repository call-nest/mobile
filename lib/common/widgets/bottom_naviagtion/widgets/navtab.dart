import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;
  final int selectedIndex;

  const NavTab(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.icon,
      required this.selectedIcon,
      required this.onTap,
      required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
          child: AnimatedOpacity(
        opacity: isSelected ? 1 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              isSelected ? selectedIcon : icon,
              color: Colors.black,
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      )),
    ));
  }
}
