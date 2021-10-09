import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_top_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicTopSongContainerPage extends StatefulWidget {
  @override
  _MusicTopSongContainerPageState createState() =>
      _MusicTopSongContainerPageState();
}

class _MusicTopSongContainerPageState extends State<MusicTopSongContainerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildTabs(), Expanded(child: _buildBody())],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppTheme.scaffoldBackgroundColor(context),
      height: 48,
      child: TabBar(controller: _tabController,isScrollable: true, onTap: (value) {}, tabs: [
        Tab(
          text: S.of(context).recommend,
        ),
        Tab(
          text: S.of(context).zh,
        ),
        Tab(
          text: S.of(context).ea,
        ),
        Tab(
          text: S.of(context).kr,
        ),
        Tab(
          text: S.of(context).jp,
        )
      ]),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        MusicTopSongItemPage(
          type: 0,
        ),
        MusicTopSongItemPage(
          type: 7,
        ),
        MusicTopSongItemPage(
          type: 96,
        ),
        MusicTopSongItemPage(
          type: 8,
        ),
        MusicTopSongItemPage(
          type: 16,
        ),
      ],
    );
  }
}

class MusicTopSongItemPage extends StatefulWidget {
  final int type;

  const MusicTopSongItemPage({Key? key, required this.type}) : super(key: key);

  @override
  _MusicTopSongItemPageState createState() => _MusicTopSongItemPageState();
}

class _MusicTopSongItemPageState extends State<MusicTopSongItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicTopSongViewModel>(
      viewModel: MusicTopSongViewModel(widget.type),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty || viewModel.songs.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return CustomScrollView(
          slivers: [
            _buildPinnedHeader(viewModel.songs.length),
            SliverPadding(padding: EdgeInsets.only(top: Inchs.sp6)),
            _buildList(viewModel.songs)
          ],
        );
      },
    );
  }

  Widget _buildPinnedHeader(int length) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          maxHeight: 44,
          minHeight: 44,
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
            child: Row(
              children: [
                QYButtom(
                  onPressed: (_) {
                    LogUtil.v('播放全部');
                  },
                  padding: EdgeInsets.zero,
                  imageMargin: 8,
                  image: Icon(
                    Icons.play_circle_outline,
                  ),
                  title: Text(
                    '播放全部',
                    style: AppTheme.titleStyle(context),
                  ),
                ),
                QYSpacing(
                  width: 2,
                ),
                Text(
                  '(共$length首)',
                  style: AppTheme.subtitleStyle(context),
                ),
                Spacer(),
              ],
            ),
          )),
    );
  }

  Widget _buildList(List<MusicSong> songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, int index) {
        var song = songs[index];
        return SongTile(
          song: song,
          onPressed: () {
            LogUtil.v('object');
          },
        );
      }, childCount: songs.length),
    );
  }
}

class SongTile extends StatelessWidget {
  final MusicSong song;
  final VoidCallback? onPressed;

  const SongTile({Key? key, required this.song, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Inchs.sp6, bottom: Inchs.sp10),
      padding: EdgeInsets.symmetric(horizontal: Inchs.left),
      child: Stack(
        children: [
          QYBounce(
            absorbOnMove: true,
            onPressed: onPressed,
            child: Container(
              padding: EdgeInsets.only(right: 100),
              child: Row(
                children: [
                  _buildLeading(),
                  QYSpacing(
                    width: 10,
                  ),
                  Expanded(child: _buildTitle(context))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildTrailing(context),
          )
        ],
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      child: ImageLoadView(
        imagePath:
            ImageCompressHelper.musicCompress(song.album?.picUrl, 40, 40),
        width: 40,
        height: 40,
        radius: 5,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleStyle(context).copyWith(fontSize: 15),
          ),
          QYSpacing(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  song.subTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (song.hasMV)
            QYBounce(
                absorbOnMove: true,
                onPressed: () {
                  LogUtil.v('点击视频');
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    ImageHelper.wrapMusicPng(
                      'music_play_list_video',
                    ),
                    color: AppTheme.iconColor(context),
                    width: 24,
                  ),
                )),
          QYSpacing(
            width: 4,
          ),
          QYBounce(
              absorbOnMove: true,
              onPressed: () {
                LogUtil.v('点击更多');
              },
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                child: Image.asset(
                  ImageHelper.wrapMusicPng(
                    'music_play_list_more',
                  ),
                  color: AppTheme.iconColor(context),
                  width: 24,
                ),
              )),
        ],
      ),
    );
  }
}
