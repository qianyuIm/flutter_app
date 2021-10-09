import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/video/vertical_mv_view_model.dart';
import 'package:flutter_app/widget/video/internal_mv/vertical_mv_playing_item.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_controller.dart';
import 'package:flutter_app/widget/video/video_manager/video_preload_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VerticalMVPage extends StatefulWidget {
  final int area;
  final int order;
  final int type;
  final int initialIndex;
  final List<InternalMv> internalMVs;

  const VerticalMVPage(
      {Key? key,
      required this.area,
      required this.order,
      required this.type,
      required this.initialIndex,
      required this.internalMVs})
      : super(key: key);

  @override
  _VerticalMVPageState createState() => _VerticalMVPageState();
}

class _VerticalMVPageState extends State<VerticalMVPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late RefreshController _refreshController;
  final PageController _pageController = PageController();
  VideoPreloadManager<InternalMv> _videoPreloadManager =
      VideoPreloadManager<InternalMv>();
  late VerticalMVViewModel _viewModel;
  final duration = Duration(milliseconds: 400);
  late AnimationController _mvTranslateController;
  late double _aspectRatio;
  @override
  void initState() {
    /// 暂停音乐播放
    var playerManager = MusicPlayerManager.of(context);
    playerManager.pause();
    _aspectRatio = 16 / 9;
    _viewModel = VerticalMVViewModel(widget.internalMVs,
        area: widget.area, type: widget.type, order: widget.order);
    _mvTranslateController =
        AnimationController(vsync: this, duration: duration);
    WidgetsBinding.instance?.addObserver(this);
    _refreshController = RefreshController(initialRefresh: false);

    _videoPreloadManager.init(
      initialIndex: widget.initialIndex,
      pageController: _pageController,
      initialList: _viewModel.internalMVs
          .map((ele) => VideoPreloadController<InternalMv>(
                index: _viewModel.internalMVs.indexOf(ele),
                beforeInit: (data) async {
                  LogUtil.v(
                      '开始请求视频地址 => ${_viewModel.internalMVs.indexOf(ele)}');
                  if (data.mvUrl?.url == null) {
                    /// 请求video url
                    return await _viewModel.loadMVUrlData(data, data.id);
                  } else {
                    return data.mvUrl!.url!;
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
            .map((ele) => VideoPreloadController<InternalMv>(
                  index: _viewModel.internalMVs.indexOf(ele),
                  beforeInit: (data) async {
                    LogUtil.v(
                        '开始请求视频地址 => ${_viewModel.internalMVs.indexOf(ele)}');
                    if (data.mvUrl?.url == null) {
                      /// 请求video url
                      return await _viewModel.loadMVUrlData(data, data.id);
                    } else {
                      return data.mvUrl!.url!;
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
    _mvTranslateController.dispose();
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
                cacheExtent: 0,
                addAutomaticKeepAlives: false,
                physics: PageScrollPhysics(),
                controller: _pageController,
                itemCount: _videoPreloadManager.videoCount,
                itemExtent: Inchs.screenHeight,
                itemBuilder: (context, index) {
                  var player = _videoPreloadManager.playerOfIndex(index)!;
                  var mvItem = _videoPreloadManager.videos[index];

                  FijkFit fit = FijkFit(
                    sizeFactor: 1.0,
                    aspectRatio: _aspectRatio,
                    alignment: Alignment.center,
                  );
                  Widget mvWidget = AspectRatio(
                    aspectRatio: _aspectRatio,
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

                  return VerticalMVPlayingItem(
                    animationController: _mvTranslateController,
                    mvItem: mvItem,
                    mvWidget: mvWidget,
                    player: player,
                    aspectRatio: _aspectRatio,
                    index: index,
                  );
                },
              ),
            ),
            AnimatedBuilder(
              animation: _mvTranslateController,
              builder: (context, child) {
                return Opacity(
                  opacity: 1.0 - _mvTranslateController.value,
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
