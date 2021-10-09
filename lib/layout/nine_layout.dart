import 'package:flutter/material.dart';

/// 九宫格布局
class NineLayout extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final int count;

  /// 间距
  final double axisSpacing;

  const NineLayout(
      {Key? key,
      required this.width,
      required this.count,
      required this.axisSpacing,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _NineLayoutDelegate(
          context: context,
          count: count,
          width: width,
          axisSpacing: axisSpacing),
      children: children,
    );
  }
}

class _NineLayoutDelegate extends FlowDelegate {
  final BuildContext context;
  final double width;
  final int count;
  final double axisSpacing;

  _NineLayoutDelegate(
      {required this.context,
      required this.width,
      required this.count,
      required this.axisSpacing})
      : assert(count > 0, 'count 不能小于0');

  var columns = 3;
  var rows = 3;
  double itemW = 0;
  double itemH = 0;
  double totalW = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = 0.0;
    var y = 0.0;

    /// 需要重新计算,解决刷新值为0的问题
    getItemSize();
    getColumnsNumber(count);
    totalW = (itemW * rows) + (axisSpacing * (rows - 1));

    //计算每一个子widget的位置
    for (int i = 0; i < count; i++) {
      var w = context.getChildSize(i)!.width + x;
      if (w <= totalW) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + axisSpacing;
      } else {
        x = 0;
        y += context.getChildSize(i)!.height + axisSpacing;
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + axisSpacing;
      }
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }

  getColumnsNumber(int length) {
    if (length <= 3) {
      rows = length;
      columns = 1;
    } else if (length <= 6) {
      rows = 3;
      columns = 2;
      if (length == 4) {
        rows = 2;
      }
    } else {
      rows = 3;
      columns = 3;
    }
  }

  getItemSize() {
    if (count == 1) {
      itemW = width;
      itemH = itemW / 2;
    } else if (count == 2) {
      itemW = (width - axisSpacing) / 2;
      itemH = itemW;
    } else if (count == 3) {
      itemW = (width - 2 * axisSpacing) / 3;
      itemH = itemW;
    } else if (count == 4) {
      itemW = (width - axisSpacing) / 2;
      itemH = itemW - 20;
    } else {
      itemW = (width - 2 * axisSpacing) / 3;
      itemH = itemW;
    }
  }
  @override
  getConstraintsForChild(int i, BoxConstraints constraints) {
    getItemSize();
    return BoxConstraints(
        minWidth: itemW, minHeight: itemH, maxWidth: itemW, maxHeight: itemH);
  }
  @override
  getSize(BoxConstraints constraints) {
    getColumnsNumber(count);
    getItemSize();
    double h = (columns * itemH) + ((columns - 1) * axisSpacing);
    totalW = (itemW * rows) + (axisSpacing * (rows - 1));
    return Size(totalW, h);
  }
}
