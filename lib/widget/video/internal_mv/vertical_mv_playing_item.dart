import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/debounce_helper.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/widget/video/comment/comment_container_page.dart';
import 'package:flutter_app/widget/video/internal_video/vertical_video_playing_item.dart';
import 'package:flutter_app/widget/video/video_favorite_animation_overlay.dart';
import 'package:flutter_app/widget/video/video_ijk_vertical_panel.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_controller.dart';

class VerticalMVPlayingItem extends StatefulWidget {
  final InternalMv mvItem;
  final Widget mvWidget;
  final double aspectRatio;
  final VideoPreloadController<InternalMv> player;
  final AnimationController animationController;
  final int index;
  final void Function(FijkException exception)? onErrorClick;

  const VerticalMVPlayingItem(
      {Key? key,
      required this.mvItem,
      required this.mvWidget,
      required this.player,
      required this.aspectRatio,
      required this.animationController,
      required this.index,
      this.onErrorClick})
      : super(key: key);
  @override
  _VerticalMVPlayingItemState createState() => _VerticalMVPlayingItemState();
}

class _VerticalMVPlayingItemState extends State<VerticalMVPlayingItem> {
  /// y 轴平移
  late double _diffTranslateY;

  /// 目标高度
  late double _targetHeight;
  late double _videoHeight;
  late double _commentMaxHeight;
  bool _isLiked = false;
  late int _likeConut;
  late Future<InternalMv> _future;

  @override
  void initState() {
    _future = loadMvDetails(widget.mvItem);
    _targetHeight = Inchs.screenWidth / widget.aspectRatio;
    _commentMaxHeight =
        Inchs.screenHeight - _targetHeight - Inchs.statusBarDiffHeight;
    _videoHeight = _targetHeight;
    _diffTranslateY = (Inchs.screenHeight - _targetHeight) / 2 -
        Inchs.statusBarDiffHeight;
    _likeConut = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<InternalMv> loadMvDetails(InternalMv internalMv) async {
    if (internalMv.detail == null) {
      return Future.wait([
        MusicApi.loadMVDetaiData(widget.mvItem.id),
        MusicApi.loadMVDetaiInfoData(widget.mvItem.id)
      ]).then((value) {
        var first = value.first as InternalMvDetail;
        var second = value.last as InternalMvDetailInfo;
        first.info = second;
        internalMv.detail = first;
        return internalMv;
      });
    }
    return internalMv;
  }

  /// 视频
  Widget _buildVideo() {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return Transform.translate(
            offset:
                Offset(0, -widget.animationController.value * _diffTranslateY),
            child: Container(
                width: Inchs.screenWidth,
                height: _videoHeight,
                child: Center(child: widget.mvWidget)));
      },
    );
  }

  /// 暂停按钮
  Widget _buildPauseIcon() {
    return AnimatedOpacity(
      opacity: widget.player.showPauseIcon.value ? 0.8 : 0,
      duration: Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.play_circle_fill,
          size: 88,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  /// 蒙层
  Widget _buildOverlay() {
    return VideoFavoriteAnimationOverlay(
      onDoubleTap: () {
        LogUtil.v('=====双击');

        /// 更新状态
        if (_isLiked) return;
        _likeConut += 1;
        _isLiked = true;
        setState(() {});
      },
      onSingleTap: () async {
        if (widget.player.playController.value.state == FijkState.started) {
          await widget.player.pause();
        } else {
          await widget.player.play();
        }
      },
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  /// 按钮
  Widget _buildButtonColumn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FutureBuilder<InternalMv>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data;
            return VideoRightButtonColumn(
              isFavorite: data?.detail?.info?.liked ?? false,
              favoriteCount: data?.detail?.info?.likedCount ?? 0,
              commentCount: data?.detail?.info?.commentCount ?? 0,
              shareCount: data?.detail?.info?.shareCount ?? 0,
              isSubscribed: data?.detail?.subed ?? false,
              onFavorite: (isFavorite) async {
                /// 数据请求
                DebounceHelper.duration(const Duration(milliseconds: 1500),
                    _favoriteRequest, [!isFavorite]);
                return !isFavorite;
              },
              onComment: () {
                showCommentModalBottomSheet(
                  context: context,
                  secondAnimationController: widget.animationController,
                  duration: widget.animationController.duration,
                  maxHeighgt: _commentMaxHeight,
                  resourceId: '${widget.mvItem.id}',
                  commentType: CommentType.mv,
                );
                
              },
              onShare: () {},
              onCollection: (isCollection) async {
                /// 数据请求
                DebounceHelper.duration(const Duration(milliseconds: 1500),
                    _collectionRequest, [!isCollection]);
                return !isCollection;
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFijkPanel() {
    return VideoFijkVerticalPanel(
      player: widget.player.playController,
      onErrorClick: (exception) {
        widget.onErrorClick?.call(exception);
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: _buildVideo(),
          ),
          _buildPauseIcon(),
          _buildOverlay(),
          _buildButtonColumn(),
          _buildFijkPanel(),
        ],
      ),
    );
  }

  /// 喜欢 or 取消喜欢 请求
  _favoriteRequest(bool isFavorite) {
    // var success = await MusicApi.loadResourceLikeData(isLiked, 5436712, 1);
    LogUtil.v('isLiked => $isFavorite');

    /// 请求是否成功  成功不做任何操作失败的话刷新状态
    return isFavorite;
  }

  /// 收藏 or 取消收藏 请求
  _collectionRequest(bool isCollection) {
    // var success = await MusicApi.loadResourceLikeData(isLiked, 5436712, 1);
    LogUtil.v('isLiked => $isCollection');

    /// 请求是否成功  成功不做任何操作失败的话刷新状态
    return isCollection;
  }
}
