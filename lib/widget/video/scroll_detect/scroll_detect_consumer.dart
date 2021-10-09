import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scroll_detect_manager.dart';
import 'scroll_detect_meta.dart';

class ScrollDetectSelector<T> extends StatelessWidget {

  const ScrollDetectSelector(
      {Key? key, 
      required this.index, 
      required this.data,
      required this.builder})
      : super(key: key);

  final int index;

  final T data;

  // final Widget Function(
  //     BuildContext context, ScrollDetectManager<T> manager, Widget? child) builder;

  final Widget Function(
      BuildContext context, int playIndex, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return Selector<ScrollDetectManager<T>,int>(
      selector: (context, manager) {
        return manager.playIndex;
      },
      shouldRebuild: (previous, next) {
        return index == next;
      },
      builder: (context, value, child) {
        return MetaData(
          metaData: ScrollDetectMeta<T>(data,index),
          child: builder(context,value,child),
        );
      },
    );
    // return Consumer<ScrollDetectManager<T>>(
    //   builder: (context, value, child) {
    //     return MetaData(
    //       metaData: ScrollDetectMeta<T>(data,index),
    //       child: builder(context,value,child),
    //     );
    //   },
    // );
    
  }
}
