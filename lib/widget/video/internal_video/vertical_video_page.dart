import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/video/vertical_video_view_model.dart';
import 'package:flutter_app/widget/video/internal_video/vertical_video_playing_item.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_manager.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_controller.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class VerticalVideoPage extends StatefulWidget {
  final int categoryId;
  final List<InternalVideo> videos;
  final int initialIndex;
  const VerticalVideoPage(
      {Key? key,
      required this.categoryId,
      required this.videos,
      required this.initialIndex})
      : super(key: key);

  @override
  _VerticalVideoPageState createState() => _VerticalVideoPageState();
}

class _VerticalVideoPageState extends State<VerticalVideoPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late RefreshController _refreshController;
  final PageController _pageController = PageController();
  VideoPreloadManager<InternalVideo> _videoPreloadManager =
      VideoPreloadManager<InternalVideo>();
  late VerticalVideoViewModel _viewModel;
  final _maxWidth = Inchs.screenWidth;
  final duration = Duration(milliseconds: 400);
  late AnimationController _videoTranslateController;
  @override
  void initState() {
    /// 暂停音乐播放
    var playerManager = MusicPlayerManager.of(context);
    playerManager.pause();
    _viewModel = VerticalVideoViewModel(widget.categoryId, widget.videos);
    _videoTranslateController =
        AnimationController(vsync: this, duration: duration);
    WidgetsBinding.instance?.addObserver(this);
    _refreshController = RefreshController(initialRefresh: false);

    _videoPreloadManager.init(
      initialIndex: widget.initialIndex,
      pageController: _pageController,
      initialList: _viewModel.videos
          .map((ele) => VideoPreloadController<InternalVideo>(
                index: _viewModel.videos.indexOf(ele),
                beforeInit: (data) async {
                  
                  LogUtil.v('开始请求视频地址 => ${_viewModel.videos.indexOf(ele)}');
                  if (data.data?.urlInfo?.url == null) {
                    /// 请求video url
                    return await _viewModel.loadVideoUrlData(
                        data, data.data?.vid ?? '-1');
                  } else {
                    return data.data!.urlInfo!.url!;
                  }
                },
                data: ele,
                builder: (data) {
                  return FijkPlayer();
                },
              ))
          .toList(),
      videoProvider: (index, list) async {
        LogUtil.v('触发加载更多');
        var moreList = await _viewModel.loadMore();
        if (moreList?.length == 0 || moreList == null) {
          return null;
        }
        return moreList
            .map((ele) => VideoPreloadController<InternalVideo>(
                  index: _viewModel.videos.indexOf(ele),
                  beforeInit: (data) async {
                    
                    if (data.data?.urlInfo?.url == null) {
                      /// 请求video url
                      return await _viewModel.loadVideoUrlData(
                          data, data.data?.vid ?? '-1');
                    } else {
                      return data.data!.urlInfo!.url!;
                    }
                  },
                  data: ele,
                  builder: (data) {
                    return FijkPlayer();
                  },
                ))
            .toList();
      },
    );

    _videoPreloadManager.addListener(_videoPreloadManagerListener);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(widget.initialIndex);
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      _videoPreloadManager.currentPlayer.pause();
    } else {
      _videoPreloadManager.currentPlayer.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _videoTranslateController.dispose();
    _videoPreloadManager.removeListener(_videoPreloadManagerListener);
    _videoPreloadManager.currentPlayer.dispose();
    LogUtil.v('怎么释放 =》》》》》_videoPreloadManager');
    _refreshController.dispose();
    //  _videoPreloadManager.dispose();
    super.dispose();
  }

  void _videoPreloadManagerListener() {
    setState(() {});
    /// 更新底部刷新状态
    if (_refreshController.isLoading) {
      if (!_videoPreloadManager.isLoadMore && _videoPreloadManager.hasMore) {
        _refreshController.loadComplete();
      } else if (!_videoPreloadManager.hasMore) {
        _refreshController.loadNoData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Stack(
      children: [
         SmartRefresher(
              enablePullUp: true,
              enablePullDown: false,
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              controller: _refreshController,
              child: ListView.builder(
                addAutomaticKeepAlives: false,
                physics: PageScrollPhysics(),
                controller: _pageController,
                itemCount: _videoPreloadManager.videoCount,
                itemExtent: Inchs.screenHeight,
                itemBuilder: (context, index) {
                  var player = _videoPreloadManager.playerOfIndex(index)!;
                  var videoItem = _videoPreloadManager.videos[index];

                  final maxHeight =
                      videoItem.verticalItemImageHeight(_maxWidth);
                  var aspectRatio =
                      videoItem.verticalAspectRatio(_maxWidth, maxHeight);
                  FijkFit fit = FijkFit(
                    sizeFactor: 1.0,
                    aspectRatio: aspectRatio,
                    alignment: Alignment.center,
                  );
                  Widget videoWidget = AspectRatio(
                    aspectRatio: aspectRatio,
                    child: FijkView(
                      panelBuilder:
                          (player, data, context, viewSize, texturePos) {
                        /// 移除默认控制面板
                        return Container(
                          color: Colors.transparent,
                        );
                      },
                      player: player.playController,
                      fit: fit,
                      // cover: AssetImage("assets/images/loading.png"),
                    ),
                  );

                  return VerticalVideoPlayingItem(
                      player: player,
                      animationController: _videoTranslateController,
                      videoItem: videoItem,
                      videoWidget: videoWidget,
                      videoHeight: maxHeight,
                      aspectRatio: aspectRatio,
                      index: index,
                      onErrorClick: (exception) {
                        LogUtil.v('刷新当前的Item');
                        _videoPreloadManager.playerOfIndex(index)?.refresh();
                      },);
                },
              ),
        ),
        AnimatedBuilder(
          animation: _videoTranslateController,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - _videoTranslateController.value,
              child: SafeArea(
                  child: Container(
                height: Inchs.navigation_height,
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 24,
                      color: Colors.white,
                    ),
                  ],
                ),
              )),
            );
          },
        ),
      ],
    ));
  }
}
