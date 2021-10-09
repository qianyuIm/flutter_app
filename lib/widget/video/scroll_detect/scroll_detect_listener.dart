import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'scroll_detect_manager.dart';
import 'scroll_detect_meta.dart';

/// for: https://github.com/wuba/magpie_fly/blob/8bfc005b1c74056108e8ec6c1c78f67ceb71bdb8/example/lib/demo/video/video_feed_demo.dart

class ScrollDetectListener<T> extends StatelessWidget {
  ///
  /// 滚动监测
  ///
  ///@param extentSize  单步长度
  ///@param offset 顶部高度
  ///@param initializedDetect 是否初始化就开始监测
  ///@param percentIn 单个反应面积比例
  ScrollDetectListener({
    Key? key,
    required Widget child,
    required Function(
            List<ScrollDetectMeta<T>> metas, ScrollDetectManager<T> manager)
        onVisible,
    double extentSize = 10.0,
    double percentIn = 0.8,
    double offset = 0,
    bool initializedDetect = true,
    NotificationListenerCallback? onNotification,
  })  : assert(percentIn > 0 && percentIn <= 1, 'percent should be (0,1]'),
        assert(offset > 0, 'offset should >0'),
        _notification = _ScrollNotification<T>(
          config: _Config<T>(
              callback: onVisible,
              initializedDetect: initializedDetect,
              percentIn: percentIn,
              offset: offset,
              extentSize: extentSize,
              onNotification: onNotification),
          child: child,
        );

  final _ScrollNotification _notification;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScrollDetectManager<T>(),
      child: _notification,
    );
  }
}

class _Config<T> {
  final Function(
      List<ScrollDetectMeta<T>> metas, ScrollDetectManager<T> manager) callback;
  final double extentSize;
  /// 初始化就开始监测
  final bool initializedDetect;

  /// when the view is "visible" on screen
  final double percentIn;

  /// take care of AppBar height if exists
  final double offset;

  /// [onNotification] for [NotificationListener]
  final NotificationListenerCallback? onNotification;

  _Config(
      {required this.callback,
      required this.extentSize,
      required this.initializedDetect,
      required this.percentIn,
      required this.offset,
      this.onNotification});
}

class _ScrollNotification<T> extends StatelessWidget {
  

  const _ScrollNotification(
      {Key? key, 
      required this.child, 
      required this.config})
      : super(key: key);

  final Widget child;
  final _Config<T> config;

  @override
  Widget build(BuildContext context) {
    if (config.initializedDetect) {
      Future.delayed(Duration(milliseconds: 200), () {
        _internalHit(context, config);
      }).catchError((_) => null);
    }
    return NotificationListener(
      child: child,
      onNotification: (ScrollNotification notification) {
        if (!(notification is ScrollEndNotification)) {
          return config.onNotification?.call(notification) ?? false;
        }
        Future.microtask(() {
          return _internalHit(context, config);
        }).then((_) {
          if (!_) {
            Future.delayed(Duration(milliseconds: 300), () {
              var result = _internalHit(context, config);
              if (!result) {}
            }).catchError((_) => null);
          }
        }).catchError((_) => null);
        return config.onNotification?.call(notification) ?? false;
      },
    );
  }

  bool _internalHit(BuildContext context, _Config<T> config) {
    var height = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width / 2;
    List<ScrollDetectMeta<T>> targets = [];
    for (var y = 0.0; y < height; y += config.extentSize) {
      var meta = _getMeta<ScrollDetectMeta<T>>(
          context, x, y, config.percentIn, config.offset);
      if (meta != null && !targets.contains(meta)) {
        targets.add(meta);
      }
    }

    try {
      var manager = Provider.of<ScrollDetectManager<T>>(context,listen: false);
      config.callback(targets, manager);
    } catch (e) {
      LogUtil.v('error => $e');
    }
    return targets.length > 0;
  }

  D? _getMeta<D>(
      BuildContext context, double x, double y, double percentIn, double top) {
    var renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset(x, y));
    var result = HitTestResult();
    WidgetsBinding.instance?.hitTest(result, offset);

    dynamic invalidOne;
    for (var i in result.path) {
      if (!(i.target is RenderMetaData)) {
        continue;
      }
      var d = i.target as RenderMetaData;
      if (d.child == invalidOne) {
        continue;
      }
      var data = d.metaData;
      // if (!predicate(data)) {
      //   invalidOne = d.child;
      //   continue;
      // }
      if (d.child == invalidOne) {
        continue;
      }
      var p = d.child?.localToGlobal(Offset.zero) ?? Offset.zero;
      if (p.dy + (1 - percentIn) * d.child!.size.height - top < 0) {
        invalidOne = d.child;
        continue;
      }
      return data as D;
    }
    return null;
  }
}
