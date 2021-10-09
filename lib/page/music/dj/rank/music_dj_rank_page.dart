import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_rank.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

/// 类型
const _tab_titles = ['每日榜', '热门榜', '新人榜'];

class MusicDJRankPage extends StatefulWidget {
  @override
  _MusicDJRankPageState createState() => _MusicDJRankPageState();
}

class _MusicDJRankPageState extends State<MusicDJRankPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tab_titles.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          child: TabBar(
        controller: _tabController,
        onTap: (value) {
          _tabController.animateTo(value);
        },
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppTheme.titleColor(context),
        unselectedLabelColor: AppTheme.subtitleColor(context),
        labelStyle: AppTheme.titleStyle(context),
        unselectedLabelStyle: AppTheme.subtitleStyle(context),
        indicatorWeight: 3,
        tabs: _tab_titles
            .map((e) => Tab(
                  text: e,
                ))
            .toList(),
      )),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            MusicDJRankItemPage(djRankType: 0),
            MusicDJRankItemPage(djRankType: 1),
            MusicDJRankItemPage(djRankType: 2),
          ],
        ),
      )
    ]);
  }
}

class MusicDJRankItemPage extends StatefulWidget {
  final int djRankType;

  const MusicDJRankItemPage({Key? key, required this.djRankType})
      : super(key: key);

  @override
  _MusicDJRankItemPageState createState() => _MusicDJRankItemPageState();
}

class _MusicDJRankItemPageState extends State<MusicDJRankItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicDJRankViewModel>(
      viewModel: MusicDJRankViewModel(widget.djRankType),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.djRanks.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return ListView.builder(
          itemCount: viewModel.djRanks.length,
          itemBuilder: (context, index) {
            if (index < 3) {
              if (index == 0) {
                var topThreeRank = viewModel.djRanks.sublist(0, 3);
                return _buildTopThreeRank(topThreeRank);
              }
              return SizedBox.shrink();
            } else {
              var djRank = viewModel.djRanks[index];
              return _buildItem(djRank);
            }
          },
        );
      },
    );
  }

  Widget _buildTopThreeRank(List<MusicDjRank> topThreeRank) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: Inchs.left),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTopThreeItem(topThreeRank[1],
                imageWidthHeight: 70),
            _buildTopThreeItem(topThreeRank[0],
                imageWidthHeight: 80),
            _buildTopThreeItem(topThreeRank[2],
                imageWidthHeight: 60),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildTopThreeItem(MusicDjRank djRank,
      {double imageWidthHeight = 60}) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('用户ID => ${djRank.id}');
        Navigator.of(context).pushNamed(MyRouterName.music_user_home,arguments: djRank.id);
      },
      child: Container(
      width: imageWidthHeight + 20,
      child: Column(
        children: [
          Text(
            '${djRank.rank}',
            style: AppTheme.titleStyle(context).copyWith(
                fontSize: 20, color: AppTheme.of(context).primaryColor),
          ),
          QYSpacing(
            height: 4,
          ),
          _rankIcon(djRank),
          QYSpacing(
            height: 4,
          ),
          Stack(
            children: [
              _buildImage(djRank,
                  imageWidthHeight: imageWidthHeight),
                  if (djRank.avatarDetail != null)
                Positioned(
                  bottom: 5,
                  right: 0,
                    child: ImageLoadView(
                  imagePath: djRank.avatarDetail?.identityIconUrl ?? '',
                  width: 15,
                  height: 15,
                )),
            ],
          ),
          QYSpacing(
            height: 4,
          ),
          Text(
            djRank.nickName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleStyle(context).copyWith(fontSize: 14),
          ),
          QYSpacing(
            height: 4,
          ),
          Text(
            '${StringHelper.formateNumber(djRank.userFollowedCount)}粉丝',
            style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildItem(MusicDjRank djRank) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('用户ID => ${djRank.id}');
        Navigator.of(context).pushNamed(MyRouterName.music_user_home,arguments: djRank.id);
      },
      child: Container(
      margin: EdgeInsets.only(right: Inchs.right, top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLeading(djRank),
          QYSpacing(
            width: 4,
          ),
          Stack(
            children: [
              _buildImage(djRank),
              if (djRank.avatarDetail != null)
                Positioned(
                  bottom: 5,
                  right: 0,
                    child: ImageLoadView(
                  imagePath: djRank.avatarDetail?.identityIconUrl ?? '',
                  width: 15,
                  height: 15,
                )),
            ],
          ),
          QYSpacing(
            width: 6,
          ),
          Expanded(
            child: _buildTrailing(djRank),
          )
        ],
      ),
    ),
    );
  }

  /// 左侧
  Widget _buildLeading(MusicDjRank djRank) {
    return Container(
      width: 50,
      // color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${djRank.rank}'),
          QYSpacing(
            height: 4,
          ),
          _rankIcon(djRank)
        ],
      ),
    );
  }

  Widget _buildImage(MusicDjRank djRank,
      {double imageWidthHeight = 60}) {
    var imagePath = djRank.avatarUrl;
    return ImageLoadView(
      imagePath:
          ImageCompressHelper.musicCompress(imagePath, imageWidthHeight, imageWidthHeight),
      width: imageWidthHeight,
      height: imageWidthHeight,
      radius: imageWidthHeight / 2,
    );
  }

  /// 右侧
  Widget _buildTrailing(MusicDjRank djRank) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            djRank.nickName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
          ),
          QYSpacing(
            height: 4,
          ),
          Text('${StringHelper.formateNumber(djRank.userFollowedCount)}粉丝')
        ],
      ),
    );
  }

  Widget _rankIcon(MusicDjRank djRank) {
    if (djRank.lastRank == -1) {
      return Image.asset(
        ImageHelper.wrapMusicPng('music_dj_toplist_rank_new'),
        width: 20,
        height: 8,
      );
    } else if (djRank.lastRank == djRank.rank) {
      return Image.asset(
        ImageHelper.wrapMusicPng('music_dj_toplist_rank_equal'),
        width: 20,
        height: 8,
      );
    } else if (djRank.lastRank > djRank.rank) {
      return Container(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.wrapMusicPng('music_dj_toplist_rank_down'),
              width: 20,
              height: 8,
            ),
            Text('${djRank.lastRank - djRank.rank}')
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.wrapMusicPng('music_dj_toplist_rank_up'),
              width: 20,
              height: 8,
            ),
            Text('${djRank.rank - djRank.lastRank}')
          ],
        ),
      );
    }
  }
}
