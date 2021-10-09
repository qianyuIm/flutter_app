import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_rank.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

/// 类型
const _tab_titles = ['每日榜', '节目榜', '新晋电台榜', '热门电台榜'];

class MusicDJProgramRankPage extends StatefulWidget {
  @override
  _MusicDJProgramRankPageState createState() => _MusicDJProgramRankPageState();
}

class _MusicDJProgramRankPageState extends State<MusicDJProgramRankPage>
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
            MusicDJProgramRankItemPage(djProgramType: 0),
            MusicDJProgramRankItemPage(djProgramType: 1),
            MusicDJProgramRankItemPage(djProgramType: 2),
            MusicDJProgramRankItemPage(djProgramType: 3),
          ],
        ),
      )
    ]);
  }
}

class MusicDJProgramRankItemPage extends StatefulWidget {
  final int djProgramType;

  const MusicDJProgramRankItemPage({Key? key, required this.djProgramType})
      : super(key: key);

  @override
  _MusicDJProgramRankItemPageState createState() =>
      _MusicDJProgramRankItemPageState();
}

class _MusicDJProgramRankItemPageState extends State<MusicDJProgramRankItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicDJProgramRankViewModel>(
      viewModel: MusicDJProgramRankViewModel(widget.djProgramType),
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
                imageWidth: 80, imageHeight: 80),
            _buildTopThreeItem(topThreeRank[0],
                imageWidth: 100, imageHeight: 100),
            _buildTopThreeItem(topThreeRank[2],
                imageWidth: 70, imageHeight: 70),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildTopThreeItem(MusicDjRank djRank,
      {double imageWidth = 70, double imageHeight = 70}) {
    var name = djRank.program?.name ?? djRank.name;
    var nick = djRank.program?.dj?.nickname ?? djRank.creatorName;
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        
      },
      child: Container(
      width: imageWidth,
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
                  imageWidth: imageWidth, imageHeight: imageHeight)
            ],
          ),
          QYSpacing(
            height: 4,
          ),
          Text(
            name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleStyle(context).copyWith(fontSize: 14),
          ),
          QYSpacing(
            height: 4,
          ),
          Text(
            nick ?? '',
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
        
      },
      child: Container(
      padding: EdgeInsets.only(right: Inchs.right, top: 6, bottom: 6),
      child: Row(
        children: [
          _buildLeading(djRank),
          QYSpacing(
            width: 8,
          ),
          _buildImage(djRank),
          QYSpacing(
            width: 8,
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
      child: Column(
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
      {double imageWidth = 70, double imageHeight = 70}) {
    var imagePath = djRank.program?.coverUrl ?? djRank.picUrl;
    return ImageLoadView(
      imagePath:
          ImageCompressHelper.musicCompress(imagePath, imageWidth, imageHeight),
      width: imageWidth,
      height: imageHeight,
      radius: 10,
    );
  }

  /// 右侧
  Widget _buildTrailing(MusicDjRank djRank) {
    var name = djRank.program?.name ?? djRank.name;
    var count = djRank.program?.listenerCount ?? djRank.playCount;
    var nick = djRank.program?.dj?.nickname ?? djRank.creatorName;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
        ),
        QYSpacing(
          height: 8,
        ),
        Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: AppTheme.subtitleColor(context),
            ),
            Text(StringHelper.formateNumber(count)),
            QYSpacing(
              width: 8,
            ),
            Expanded(
              child: Text(nick ?? ''),
            )
          ],
        ),
      ],
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
