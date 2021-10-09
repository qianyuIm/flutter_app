import 'dart:math';

import 'package:flutter/material.dart';

class MusicPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  
  final double minHeight;
  final double maxHeight;
  final Widget child;

  MusicPersistentHeaderDelegate({required this.minHeight,required this.maxHeight, required this.child});
  

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
      return SizedBox.expand(child: child,);
    }
  
    @override
    double get maxExtent => max(maxHeight, minHeight);
  
    @override
    double get minExtent => minHeight;
  
    @override
    bool shouldRebuild(MusicPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight  || child != oldDelegate.child ;
  }
  
}