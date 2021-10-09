import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

/// 骨架list
class SkeletonList extends StatelessWidget {
  const SkeletonList(
      {Key? key,
      this.padding = const EdgeInsets.all(8),
      this.length = 6,
      required this.builder})
      : super(key: key);

  final EdgeInsetsGeometry padding;
  final int length;
  final IndexedWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1200),
        baseColor: isDark ? Colors.grey[700]! : Colors.grey[350]!,
        highlightColor: isDark ? Colors.grey[500]! : Colors.grey[200]!,
        child: Padding(
          padding: padding,
          child: Column(
            children: List.generate(length, (index) => builder(context, index)),
          ),
        ),
      ),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  

  const SkeletonGrid(
      {Key? key,
      required this.crossAxisCount,
      this.mainAxisSpacing = 0,
      this.crossAxisSpacing = 0,
      this.itemCount = 10,
      required this.itemBuilder,
      required this.staggeredTileBuilder})
      : super(key: key);

  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedStaggeredTileBuilder staggeredTileBuilder;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1200),
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[350]!,
      highlightColor: isDark ? Colors.grey[500]! : Colors.grey[200]!,
      child: StaggeredGridView.countBuilder(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          staggeredTileBuilder: staggeredTileBuilder),
    );
  }
}

/// 骨架小控件
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;

  SkeletonBox(
      {required this.width, required this.height, this.isCircle: false});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Divider.createBorderSide(context, width: 0.7);
    return Container(
      width: width,
      height: height,
      decoration: SkeletonDecoration(isCircle: isCircle, isDark: isDark),
    );
  }
}

/// 骨架形状
class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    isCircle: false,
    isDark: false,
  }) : super(
          color: !isDark ? Colors.grey[350] : Colors.grey[700],
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        );
}

/// 骨架底部 线条
class BottomBorderDecoration extends BoxDecoration {
  BottomBorderDecoration()
      : super(border: Border(bottom: BorderSide(width: 0.3)));
}
