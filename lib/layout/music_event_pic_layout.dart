import 'package:flutter/material.dart';

/// 动态图片布局
class MusicEventPicLayout extends StatelessWidget {
  /// 间距
  final double axisSpacing;

  /// 子视图
  final List<Widget> children;

  /// 个数
  final int count;

  /// 最大宽度
  final double maxWidth;

  /// 当只有一个时的宽度
  final double singleWidth;

  /// 当只有一个时的高度
  final double singleHeight;

  const MusicEventPicLayout(
      {Key? key,
      required this.axisSpacing,
      required this.count,
      required this.maxWidth,
      required this.singleWidth,
      required this.singleHeight,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _MusicEventPicLayoutDelegate(
          maxWidth: maxWidth,
          singleWidth: singleWidth,
          singleHeight: singleHeight,
          count: count,
          axisSpacing: axisSpacing),
      children: children,
    );
  }
}

class _MusicEventPicLayoutDelegate extends FlowDelegate {
  final int count;
  final double axisSpacing;

  /// 最大宽度
  final double maxWidth;

  /// 当只有一个时的宽度
  final double singleWidth;

  /// 当只有一个时的高度
  final double singleHeight;

  _MusicEventPicLayoutDelegate(
      {required this.maxWidth,
      required this.singleWidth,
      required this.singleHeight,
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
  Size getSize(BoxConstraints constraints) {
    getColumnsNumber(count);
    getItemSize();
    double h = (columns * itemH) + ((columns - 1) * axisSpacing);
    totalW = (itemW * rows) + (axisSpacing * (rows - 1));
    return Size(totalW, h);
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    getItemSize();
    return BoxConstraints(
        minWidth: itemW, minHeight: itemH, maxWidth: itemW, maxHeight: itemH);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }

  /// 获取单个size
  getItemSize() {
    if (count == 1) {
      itemW = singleWidth;
      itemH = singleHeight;
    } else {
      itemW = (maxWidth - 2 * axisSpacing) / 3;
      itemH = itemW;
    }
  }

  /// 获取行数和列数
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
}
