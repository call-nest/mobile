import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PersistentTabBar extends SliverPersistentHeaderDelegate{

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.symmetric(
              horizontal: BorderSide(
                  color: Colors.grey.shade200, width: 1)),
        ),
        child: TabBar(
          indicatorColor: Theme.of(context).appBarTheme.backgroundColor,
          labelPadding: EdgeInsets.only(bottom: 10),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.black,
          tabs: [
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 20),
                child: Text("협업 요청")),
            Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 20),
                child: Text("받은 요청")),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent {
    return 50;
  }

  @override
  double get minExtent {
      return 50;
  }
}