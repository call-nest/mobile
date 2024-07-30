import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PersistentTabBar extends SliverPersistentHeaderDelegate{

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
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
              child: Text("완성 작품")),
          Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20),
              child: Text("모집 작품")),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent {
    return 47;
  }

  @override
  double get minExtent {
      return 47;
  }
}