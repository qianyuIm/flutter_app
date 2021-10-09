import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/page/video/video/internal_video_multi_IJK_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/video/scroll_detect/scroll_detect_consumer.dart';
import 'package:flutter_app/widget/video/scroll_detect/scroll_detect_manager.dart';
import 'package:flutter_app/widget/video/video_ijk_single_panel.dart';
import 'package:provider/provider.dart';

class InternalVideoIJKSelector extends StatelessWidget {
  final int index;
  final InternalVideo internalVideo;
  final InternalVideoIJKMultiManager multiManager;
  const InternalVideoIJKSelector({
    Key? key,
    required this.index,
    required this.internalVideo,
    required this.multiManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollDetectSelector<InternalVideo>(
      index: index,
      data: internalVideo,
      builder: (context, playIndex, child) {
        var isPlay = playIndex == index;
        
        return InternalVideoRecommendIJKItem(
          isPlay: isPlay,
          internalVideo: internalVideo,
          index: index,
          multiManager: multiManager,
        );
      },
    );
  }
}

class InternalVideoRecommendIJKItem extends StatefulWidget {
  final bool isPlay;
  final InternalVideo internalVideo;
  final int index;
  final InternalVideoIJKMultiManager multiManager;
  const InternalVideoRecommendIJKItem(
      {Key? key,
      required this.isPlay,
      required this.internalVideo,
      required this.index,
      required this.multiManager})
      : super(key: key);

  @override
  _InternalVideoRecommendIJKItemState createState() =>
      _InternalVideoRecommendIJKItemState();
}

class _InternalVideoRecommendIJKItemState
    extends State<InternalVideoRecommendIJKItem> {
  FijkPlayer? _player;
  late double _maxWidth;
  late double _maxHeight;
  late double _aspectRatio;
  late ScrollDetectManager<InternalVideo> _scrollDetectManager;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollDetectManager =
        Provider.of<ScrollDetectManager<InternalVideo>>(context, listen: false);
    _maxWidth = (Inchs.screenWidth - Inchs.left - Inchs.right);
    _maxHeight = widget.internalVideo.itemImageHeight(_maxWidth);
    _aspectRatio = widget.internalVideo.aspectRatio(_maxWidth, _maxHeight);
    // int mills = widget.index <= 3 ? 100 : 500;
    _timer = Timer(Duration(milliseconds: 100), () async {
      _player = FijkPlayer();
      await _player?.setDataSource(widget.internalVideo.data!.urlInfo!.url!);
      await _player?.setLoop(0);
      widget.multiManager.update(_player!, widget.index);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(InternalVideoRecommendIJKItem oldWidget) {
    if (oldWidget.internalVideo != widget.internalVideo) {
      updatePlayer();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> updatePlayer() async {
    LogUtil.v('重新加载控制器');
    await _player?.reset();
    await _player?.setDataSource(widget.internalVideo.data!.urlInfo!.url!);
    await _player?.setLoop(0);
    LogUtil.v('reset => ${_player?.state}');
    widget.multiManager.update(_player!, widget.index);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.multiManager.remove(_player!, widget.index);
    super.dispose();
  }

  /// 延时执行 看有什么方式可以避免的
  void _play() async {
    if (_player?.state == FijkState.initialized) {
      await _player?.prepareAsync().then((value) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (widget.isPlay && _scrollDetectManager.playIndex == widget.index) {
            widget.multiManager.play(_player!);
          }
        });
      });
    } else {
      if (widget.isPlay && _scrollDetectManager.playIndex == widget.index) {
        widget.multiManager.play(_player!);
      }
    }
  }
  void _managerPlay() async {
    if (_player?.state == FijkState.initialized) {
      await _player?.prepareAsync().then((value) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (widget.isPlay && _scrollDetectManager.playIndex == widget.index) {
            widget.multiManager.play(_player!);
          }
        });
      });
    } else {
      widget.multiManager.play(_player!);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    // LogUtil.v('构建 => ${widget.index} => ${widget.internalVideo.itemTitle}');
    final itemColor = AppTheme.cardColor(context);
    return Container(
      margin:
          EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: itemColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideo(widget.internalVideo),
          const QYSpacing(
            height: 4,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3, right: 3),
            child: Text(
              widget.internalVideo.itemTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.titleStyle(context),
            ),
          ),
          const QYSpacing(
            height: 4,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              '${widget.internalVideo.itemSubTitle} =>>> ${widget.index}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.subtitleCopyStyle(context,fontSize: 12),
            ),
          ),
          const QYSpacing(
            height: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildVideo(InternalVideo video) {
    FijkFit fit = FijkFit(
      sizeFactor: 1.0,
      aspectRatio: _aspectRatio,
      alignment: Alignment.center,
    );
    if (widget.isPlay) {
      _play();
    }
    // 加上图片会卡顿怎么弄？？？？？
    return AspectRatio(
        aspectRatio: (_maxWidth / _maxHeight),
        child: Stack(
          children: [
            //     ImageLoadView(
            //   imagePath: ImageCompressHelper.musicSingCompress(
            //       widget.internalVideo.itemPicUrl, _maxWidth, _maxHeight),
            //   shape: BoxShape.rectangle,
            //   width: _maxWidth,
            //   height: _maxHeight,
            // ),
            _player != null
                ? FijkView(
                    color: AppTheme.cardColor(context),
                    panelBuilder: fijkSinglePanelWidgetBuilder(
                      onSingleClick: (isStart) {
                        if (isStart) {
                          _managerPlay();
                        } else {
                          widget.multiManager.managerPause();
                        }
                      },
                    ),
                    player: _player!,
                    fit: fit,
                  )
                : Container(
                    color: AppTheme.cardColor(context),
                  )
          ],
        ));
  }
}
