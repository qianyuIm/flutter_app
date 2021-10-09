import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/color_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/comment/comment_view_model.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/video/comment/comment_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

List<String> _sortItems = ['推荐', '最热', '最新'];

List<int> _sortItemTypes = [1, 2, 3];

class MusicPlayingCommentPage extends StatefulWidget {
  @override
  _MusicPlayingCommentPageState createState() =>
      _MusicPlayingCommentPageState();
}

class _MusicPlayingCommentPageState extends State<MusicPlayingCommentPage>
    with AutomaticKeepAliveClientMixin {
  /// 初始化之后需要根据返回数据判定
  int _sortIndex = 1;
  late MusicPlayerManager _playerManager;
  MusicSong? _currentSong;
  final _commentListKey = GlobalKey<_MusicPlayingCommentListViewState>();
  final _visibilityDetectorKey = Key('music_playing_comment_page_key');
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _playerManager = MusicPlayerManager.of(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0 &&
            _playerManager.currentSong != _currentSong) {
          _currentSong = _playerManager.currentSong;
          _sortIndex = 1;
          LogUtil.v('刷新请求');
          setState(() {});
        }
      },
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildInfo(),
              _buildPinned(),
            ];
          },
          body: _buildListView('${_playerManager.currentSong.id}')),
    );
  }

  Widget _buildInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Inchs.sp6),
        padding:
            EdgeInsets.symmetric(horizontal: Inchs.left, vertical: Inchs.sp4),
        child: Row(
          children: [
            ImageLoadView(
              imagePath: ImageCompressHelper.musicCompress(
                  _playerManager.currentSong.album?.picUrl, 50, 50),
              width: 50,
              height: 50,
              radius: 25,
            ),
            QYSpacing(
              width: 8,
            ),
            Expanded(
              child: Text(_playerManager.currentSong.artistName,
                  style: AppTheme.subtitleCopyStyle(context,
                      color: ColorHelper.playingTitleColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPinned() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          minHeight: 38,
          maxHeight: 44,
          child: MusicPlayingCommentHeader(
            selectIndex: _sortIndex,
            onSelected: (index) {
              _sortIndex = index;
              _commentListKey.currentState?.update(_sortIndex);
            },
          )),
    );
  }

  Widget _buildListView(String resourceId) {
    return MusicPlayingCommentListView(
        key: _commentListKey,
        resourceId: resourceId,
        selectedIndex: _sortIndex);
  }
}

class MusicPlayingCommentHeader extends StatefulWidget {
  final void Function(int index)? onSelected;
  final int selectIndex;
  const MusicPlayingCommentHeader({
    Key? key,
    required this.selectIndex,
    this.onSelected,
  }) : super(key: key);
  @override
  _MusicPlayingCommentHeaderState createState() =>
      _MusicPlayingCommentHeaderState();
}

class _MusicPlayingCommentHeaderState extends State<MusicPlayingCommentHeader> {
  int _selectedIndex = -1;

  @override
  void initState() {
    _selectedIndex = widget.selectIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(MusicPlayingCommentHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex != widget.selectIndex) {
      _selectedIndex = widget.selectIndex;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.symmetric(horizontal: Inchs.left - 4),
      decoration: BoxDecoration(
        color: ColorHelper.playingCardColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Text(
            '评论区',
            style: AppTheme.titleCopyStyle(context, color: Colors.white70),
          ),
          Spacer(),
          Row(
            children: List.generate(_sortItems.length, (index) {
              var selected = _selectedIndex == index;
              var color = selected
                  ? AppTheme.primaryColor(context)
                  : ColorHelper.playingTitleColor;
              return QYBounce(
                onPressed: () {
                  _selectedIndex = index;
                  setState(() {});
                  widget.onSelected?.call(index);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    _sortItems[index],
                    style: AppTheme.subtitleCopyStyle(context, color: color),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class MusicPlayingCommentListView extends StatefulWidget {
  final String resourceId;
  final int selectedIndex;

  const MusicPlayingCommentListView(
      {Key? key, required this.resourceId, required this.selectedIndex})
      : super(key: key);
  @override
  _MusicPlayingCommentListViewState createState() =>
      _MusicPlayingCommentListViewState();
}

class _MusicPlayingCommentListViewState
    extends State<MusicPlayingCommentListView> {
  int _selectedIndex = -1;
  String _resourceId = '';
  int _commentType = 0;
  CommentViewModel? _viewModel;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _resourceId = widget.resourceId;
    super.initState();
  }

  @override
  void didUpdateWidget(MusicPlayingCommentListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_resourceId != widget.resourceId) {
      _selectedIndex = widget.selectedIndex;
      _resourceId = widget.resourceId;
      _viewModel?.initData(
          _sortItemTypes[_selectedIndex], _resourceId, _commentType);
    }
  }

  void update(int index) {
    _selectedIndex = index;
    var sortType = _sortItemTypes[_selectedIndex];
    if (ListOptionalHelper.hasValue(_viewModel?.sortTypeList)) {
      sortType = _viewModel!.sortTypeList[_selectedIndex].sortType;
    }
    _viewModel?.initData(sortType, _resourceId, _commentType);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CommentViewModel>(
      viewModel: CommentViewModel(),
      onModelReady: (viewModel) => viewModel.initData(
          _sortItemTypes[_selectedIndex], _resourceId, _commentType),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        if (viewModel.isBusy) {
          return ViewStateBusyWidget(
            backgroundColor: Colors.transparent,
          );
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!,
              onPressed: () {
                var sortType = _sortItemTypes[_selectedIndex];
                if (ListOptionalHelper.hasValue(viewModel.sortTypeList)) {
                  sortType = viewModel.sortTypeList[_selectedIndex].sortType;
                }
                viewModel.initData(sortType, _resourceId, _commentType);
              });
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(
              message: '暂无评论',
              onPressed: () {
                var sortType = _sortItemTypes[_selectedIndex];
                if (ListOptionalHelper.hasValue(viewModel.sortTypeList)) {
                  sortType = viewModel.sortTypeList[_selectedIndex].sortType;
                }
                viewModel.initData(sortType, _resourceId, _commentType);
              });
        }

        return SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            controller: viewModel.refreshController,
            onLoading: () {
              viewModel.loadMore(_resourceId, _commentType);
            },
            child: ListView.builder(
              padding:
                  EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
              itemCount: viewModel.comments.length,
              itemBuilder: (context, index) {
                var comment = viewModel.comments[index];
                return CommentItem(
                  comment: comment,
                  color: ColorHelper.playingTitleColor,
                );
              },
            ));
      },
    );
  }
}
