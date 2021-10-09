import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_secondary_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:shimmer/shimmer.dart';

/// 歌手排行榜
class MusicArtistRankingListPage extends StatefulWidget {
  @override
  _MusicArtistRankingListPageState createState() =>
      _MusicArtistRankingListPageState();
}

List<String> _tabTitles = ['华语', '欧美', '韩国', '日本'];

class _MusicArtistRankingListPageState extends State<MusicArtistRankingListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歌手排行榜'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            child: TabBar(
              indicatorColor: AppTheme.subtitleColor(context),
              labelColor: AppTheme.titleColor(context),
              unselectedLabelColor: AppTheme.subtitleColor(context),
              labelStyle: AppTheme.titleStyle(context),
              unselectedLabelStyle: AppTheme.subtitleStyle(context),
              controller: _tabController,
              // isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: _tabTitles
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MusicArtistRankingListItem(
            type: 1,
          ),
          MusicArtistRankingListItem(
            type: 2,
          ),
          MusicArtistRankingListItem(
            type: 3,
          ),
          MusicArtistRankingListItem(
            type: 4,
          ),
        ],
      ),
    );
  }
}

class MusicArtistRankingListItem extends StatefulWidget {
  final int type;

  const MusicArtistRankingListItem({Key? key, required this.type})
      : super(key: key);

  @override
  _MusicArtistRankingListItemState createState() =>
      _MusicArtistRankingListItemState();
}

class _MusicArtistRankingListItemState extends State<MusicArtistRankingListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LogUtil.v('object => ${widget.type}');
    return ProviderWidget<MusicArtistRankingListViewModel>(
      viewModel: MusicArtistRankingListViewModel(widget.type),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }

        var top = [
          viewModel.artists[0],
          viewModel.artists[1],
          viewModel.artists[2]
        ];

        var list =
            viewModel.artists.getRange(3, viewModel.artists.length).toList();
        return CustomScrollView(
          slivers: [
            _buildTopThree(top),
            _buildList(list),
          ],
        );
      },
    );
  }

  /// 前三
  Widget _buildTopThree(List<MusicArtist> artists) {
    return SliverToBoxAdapter(
        child: Container(
      padding:
          EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(artists.length, (index) {
          return _buildTopThreeItem(artists[index], index);
        }).toList(),
      ),
    ));
  }

  Widget _buildTopThreeItem(MusicArtist artist, int index) {
    double maxWidth =
        (Inchs.screenWidth - Inchs.left - Inchs.right - 16) / 3;

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MyRouterName.music_artist, arguments: artist.id);
      },
      child: Container(
        width: maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      artist.picUrl, 100, 100),
                  width: maxWidth,
                  height: maxWidth,
                  radius: 5,
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Image.asset(
                      ImageHelper.wrapMusicPng('music_artist_rank_${index + 1}',
                          ),
                      width: 30),
                ),
              ],
            ),
            QYSpacing(
              height: 4,
            ),
            Text(
              artist.fullName(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
            ),
            QYSpacing(
              height: 2,
            ),
            Text(
              '热度: ${artist.score}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<MusicArtist> artists) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildListItem(artists[index], index),
            childCount: artists.length),
      ),
    );
  }

  Widget _buildListItem(MusicArtist artist, int index) {
    var reduce = artist.lastRank - (index + 3);
    var isReduce = reduce < 0;
    Color color = isReduce ? Colors.blue : Colors.red;
    color = (reduce == 0) ? AppTheme.subtitleColor(context) : color;
    String variable = isReduce ? '$reduce' : '+$reduce';
    variable = (reduce == 0) ? '-0' : variable;

    /// 临时解决法老图片问题
    var imagePath = ImageCompressHelper.musicCompress(artist.picUrl, 60, 60);
    if (artist.id == 865007) {
      imagePath =
          ImageCompressHelper.musicSingCompress(artist.picUrl, 200, 200);
    }
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MyRouterName.music_artist, arguments: artist.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 4),
        child: Row(
          children: [
            Column(
              children: [
                Text('${index + 4}'),
                Text(
                  variable,
                  style: AppTheme.subtitleStyle(context).copyWith(color: color),
                )
              ],
            ),
            QYSpacing(
              width: 6,
            ),
            ImageLoadView(
              imagePath: imagePath,
              width: 60,
              height: 60,
              radius: 30,
            ),
            QYSpacing(
              width: 6,
            ),
            Expanded(
              child: Text(
                artist.fullName(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
              ),
            ),
            QYSpacing(
              width: 6,
            ),
            Text(
              '热度: ${artist.score}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// 骨架图
class MusicArtistSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Shimmer.fromColors(
        period: const Duration(milliseconds: 1200),
        baseColor: isDark ? Colors.grey[700]! : Colors.grey[350]!,
        highlightColor: isDark ? Colors.grey[500]! : Colors.grey[200]!,
        child: Column(
          children: [],
        ));
  }
}
