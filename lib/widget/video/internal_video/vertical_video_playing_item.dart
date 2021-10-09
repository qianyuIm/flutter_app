import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/color_helper.dart';
import 'package:flutter_app/helper/debounce_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/video/comment/comment_container_page.dart';
import 'package:flutter_app/widget/video/video_favorite_animation_overlay.dart';
import 'package:flutter_app/widget/video/video_ijk_vertical_panel.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_controller.dart';
import 'package:like_button/like_button.dart';

class VerticalVideoPlayingItem extends StatefulWidget {
  final InternalVideo videoItem;
  final Widget videoWidget;
  final double videoHeight;
  final double aspectRatio;
  final VideoPreloadController<InternalVideo> player;
  final AnimationController animationController;
  final int index;
  final void Function(FijkException exception)? onErrorClick;

  const VerticalVideoPlayingItem(
      {Key? key,
      required this.videoItem,
      required this.videoWidget,
      required this.player,
      required this.videoHeight,
      required this.aspectRatio,
      required this.animationController,
      required this.index,
      this.onErrorClick})
      : super(key: key);

  @override
  _VerticalVideoPlayingItemState createState() =>
      _VerticalVideoPlayingItemState();
}

class _VerticalVideoPlayingItemState extends State<VerticalVideoPlayingItem>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  late int _likeConut;

  /// y 轴平移
  late double _diffTranslateY;

  /// 目标高度
  late double _targetHeight;
  late double _diffHeight;
  late double _videoHeight;
  late double _commentMaxHeight;
  @override
  void initState() {
    _targetHeight = Inchs.screenWidth / 16 * 9;
    _commentMaxHeight =
        Inchs.screenHeight - _targetHeight - Inchs.statusBarDiffHeight;
    _videoHeight = widget.videoHeight;
    _diffHeight = (_videoHeight - _targetHeight);
    _diffTranslateY =
        (Inchs.screenHeight - _targetHeight) / 2 - Inchs.statusBarDiffHeight;
    _likeConut = widget.videoItem.data?.praisedCount ?? 0;

    super.initState();
  }

  @override
  void dispose() {
    // _videoTranslateController.dispose();
    super.dispose();
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
                // color: Colors.red,
                width: Inchs.screenWidth,
                height: _videoHeight -
                    widget.animationController.value * _diffHeight,
                child: Center(child: widget.videoWidget)));
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
      child: VideoRightButtonColumn(
        isFavorite: _isLiked,
        favoriteCount: _likeConut,
        commentCount: widget.videoItem.data?.commentCount ?? 0,
        shareCount: widget.videoItem.data?.shareCount ?? 0,
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
            resourceId: widget.videoItem.data?.vid ?? '',
            commentType: CommentType.video,
          );
        },
        onShare: () {},
        onCollection: (isCollection) async {
          /// 数据请求
          DebounceHelper.duration(const Duration(milliseconds: 1500),
              _collectionRequest, [!isCollection]);
          return !isCollection;
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
          // _buildIndex()
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

const double iconSize = 30;

class VideoRightButtonColumn extends StatelessWidget {
  final bool isFavorite;
  final int favoriteCount;
  final int commentCount;
  final int shareCount;
  final bool isSubscribed;

  /// 喜欢点击
  final Future<bool> Function(bool isLiked)? onFavorite;

  /// 评论点击
  final VoidCallback? onComment;

  /// 分享点击
  final VoidCallback? onShare;

  /// 收藏点击
  final Future<bool> Function(bool isCollection)? onCollection;

  const VideoRightButtonColumn(
      {Key? key,
      this.onFavorite,
      this.isFavorite = false,
      this.commentCount = 0,
      this.shareCount = 0,
      this.isSubscribed = false,
      required this.favoriteCount,
      this.onComment,
      this.onShare,
      this.onCollection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50, right: 12),
      width: 56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LikeButton(
              isLiked: isFavorite,
              onTap: onFavorite,
              size: iconSize,
              circleColor: CircleColor(
                  start: ColorHelper.color_3, end: ColorHelper.color_3),
              countPostion: CountPostion.bottom,
              likeCount: favoriteCount,
              countBuilder: (likeCount, isLiked, text) {
                var color = isLiked ? ColorHelper.color_3 : Colors.white;
                Widget result;
                if (likeCount == 0) {
                  result = Text(
                    "love",
                    style: TextStyle(color: color),
                  );
                } else
                  result = Text(
                    text,
                    style: TextStyle(color: color),
                  );
                return result;
              },
              likeCountPadding: EdgeInsets.only(top: 4),
              likeBuilder: (isLike) {
                return isLike == true
                    ? Image.asset(
                        'assets/images/music/video_favorite_icon.webp')
                    : Image.asset(
                        'assets/images/music/video_favorite_icon.webp',
                        color: Colors.white,
                      );
              },
              bubblesColor: const BubblesColor(
                dotPrimaryColor: ColorHelper.color_3,
                dotSecondaryColor: ColorHelper.color_3,
                dotThirdColor: ColorHelper.color_3,
                dotLastColor: ColorHelper.color_3,
              )),
          QYButtom(
            imageAlignment: ImageAlignment.top,
            title: Text(
              StringHelper.formateNumber(commentCount),
              style:
                  AppTheme.subtitleCopyStyle(context,color: Colors.white),
            ),
            image: Image.asset(
              ImageHelper.wrapMusicWebp('video_comment_icon'),
              width: iconSize,
            ),
            onPressed: (state) {
              onComment?.call();
            },
          ),
          QYButtom(
            imageAlignment: ImageAlignment.top,
            title: Text(
              StringHelper.formateNumber(shareCount),
              style:
                  AppTheme.subtitleCopyStyle(context,color: Colors.white),
            ),
            image: Image.asset(
              ImageHelper.wrapMusicWebp('video_share_icon'),
              width: iconSize,
            ),
            onPressed: (state) {
              onShare?.call();
            },
          ),
          LikeButton(
              isLiked: isSubscribed,
              onTap: onCollection,
              size: iconSize,
              circleColor: CircleColor(
                  start: ColorHelper.color_3, end: ColorHelper.color_3),
              countPostion: CountPostion.bottom,
              likeCount: 0,
              countBuilder: (likeCount, isLiked, text) {
                var result = isLiked ? '已收藏' : '收藏';
                return Center(
                  child: Text(
                    result,
                    style: AppTheme.subtitleCopyStyle(context,
                        color: Colors.white),
                  ),
                );
              },
              likeCountPadding: EdgeInsets.only(top: 4),
              likeBuilder: (isLike) {
                return isLike == true
                    ? Image.asset(
                        ImageHelper.wrapMusicPng(
                            'video_collection_selected_icon'),
                        color: Colors.white,
                      )
                    : Image.asset(
                        ImageHelper.wrapMusicPng(
                            'video_collection_normal_icon'),
                        color: Colors.white,
                      );
              },
              bubblesColor: const BubblesColor(
                dotPrimaryColor: ColorHelper.color_3,
                dotSecondaryColor: ColorHelper.color_3,
                dotThirdColor: ColorHelper.color_3,
                dotLastColor: ColorHelper.color_3,
              )),
        ],
      ),
    );
  }
}
