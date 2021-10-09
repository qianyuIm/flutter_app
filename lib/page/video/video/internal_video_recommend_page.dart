import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/model/music/video_category.dart';
import 'package:flutter_app/page/video/video/internal_video_multi_IJK_manager.dart';
import 'package:flutter_app/page/video/video/internal_video_recommend_ijk_Item.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/video/internal_video_view_model.dart';
import 'package:flutter_app/widget/video/scroll_detect/scroll_detect_listener.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

class InternalVideoRecommendPage extends StatefulWidget {
  final VideoCategory category;

  const InternalVideoRecommendPage({Key? key, required this.category})
      : super(key: key);
  @override
  _InternalVideoRecommendPageState createState() =>
      _InternalVideoRecommendPageState();
}

class _InternalVideoRecommendPageState extends State<InternalVideoRecommendPage>
    with AutomaticKeepAliveClientMixin {
  late InternalVideoIJKMultiManager _multiManager;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _multiManager = InternalVideoIJKMultiManager();
    super.initState();
  }

  @override
  void dispose() {
    _multiManager.activePause();
    LogUtil.v('推荐 => 移除了');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ProviderWidget<InternalVideoViewModel>(
        viewModel: InternalVideoViewModel(widget.category.categoryId),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError && viewModel.videos.isEmpty) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: viewModel.initData);
          } else if (viewModel.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }
          return VisibilityDetector(
              key: Key('_InternalVideoRecommendPageState'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1.0) {
                  /// 暂停音乐播放
                  var playerManager = MusicPlayerManager.of(context);
                  playerManager.pause();
                  _multiManager.activePlay();
                }
                if (info.visibleFraction == 0.0) {
                  _multiManager.activePause();
                }
              },
              child: ScrollDetectListener<InternalVideo>(
                offset: Inchs.navigation_height,
                percentIn: 1.0,
                extentSize: 100,
                onVisible: (metas, manager) {
                  // if (viewModel.refreshController.isRefresh ||
                  //     viewModel.refreshController.isLoading) return;
                  var videoItem = manager.data;
                  if (metas.length > 0) {
                    var meta = metas[0];
                    var targetData = viewModel.videos[meta.index];
                    if (videoItem == null || (videoItem != targetData)) {
                      manager.update(meta.index, targetData);
                    }
                  } else if (videoItem != null) {
                    manager.update(-1, null);
                  }
                },
                child: SmartRefresher(
                    enablePullUp: true,
                    controller: viewModel.refreshController,
                    onRefresh: () async {
                      viewModel.refresh();
                    },
                    onLoading: viewModel.loadMore,
                    child: ListView.builder(
                      cacheExtent: 1,
                      itemCount: viewModel.videos.length,
                      itemBuilder: (context, index) {
                        return InternalVideoIJKSelector(
                          index: index,
                          internalVideo: viewModel.videos[index],
                          multiManager: _multiManager,
                        );
                      },
                    )),
              ));
        },
      ),
    );
  }
}
