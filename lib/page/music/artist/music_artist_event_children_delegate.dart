import 'package:flutter/material.dart';

int _kMusicArtistEventDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;
typedef HeadAndTailLocationCallback = Function(int firstIndex, int lastIndex);

class MusicArtistEventChildrenDelegate extends SliverChildBuilderDelegate {

  const MusicArtistEventChildrenDelegate(
    NullableIndexedWidgetBuilder builder, {
      this.findHeadAndTailLocationCallback,
    ChildIndexGetter? findChildIndexCallback,
    int? childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback = _kMusicArtistEventDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(builder,
            childCount: childCount,
            findChildIndexCallback: findChildIndexCallback,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset);
  /// 查找第一个位置和最后一个位置
  final HeadAndTailLocationCallback? findHeadAndTailLocationCallback;


  ///监听 在可见的列表中 显示的第一个位置和最后一个位置
  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    findHeadAndTailLocationCallback?.call(firstIndex,lastIndex);
    return super.estimateMaxScrollOffset(
        firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}
