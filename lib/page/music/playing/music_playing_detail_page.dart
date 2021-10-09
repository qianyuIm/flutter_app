
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/helper/color_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/page/music/playList/music_playlist_song_item.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_playing_view_model.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/qy_toast.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MusicPlayingDetailPage extends StatefulWidget {
  @override
  _MusicPlayingDetailPageState createState() => _MusicPlayingDetailPageState();
}

class _MusicPlayingDetailPageState extends State<MusicPlayingDetailPage>
    with AutomaticKeepAliveClientMixin {
  late MusicPlayerManager _playerManager;
  final _visibilityDetectorKey = Key('music_playing_detail_page_key');
  MusicSong? _currentSong;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _playerManager = MusicPlayerManager.of(context);
    super.initState();
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
          LogUtil.v('刷新页面');
          setState(() {});
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: Inchs.left - 4, right: Inchs.right - 4),
        child: CustomScrollView(
          slivers: [
            MusicPlayingDetailHeader(),
            SliverStickyHeader(
              header: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                    color: ColorHelper.playingCardColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0))),
                alignment: Alignment.centerLeft,
                child: Text(
                  '包含这首歌的歌单',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.titleCopyStyle(context,
                      color: ColorHelper.playingTitleColor),
                ),
              ),
              sliver: MusicPlayingSimiPlaylistItem(
                source: _playerManager.playingSource,
                song: _playerManager.currentSong,
              ),
            ),
            SliverStickyHeader(
                header: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                      color: ColorHelper.playingCardColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0))),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '喜欢这首歌的也在听',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.titleCopyStyle(context,
                        color: ColorHelper.playingTitleColor),
                  ),
                ),
                sliver: MusicPlayingSimiSongtItem(
                  source: _playerManager.playingSource,
                  song: _playerManager.currentSong,
                )),
          ],
        ),
      ),
    );
  }
}

class MusicPlayingDetailHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var playerManager = MusicPlayerManager.of(context);
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.symmetric(vertical: Inchs.sp6),
      decoration: BoxDecoration(
          color: ColorHelper.playingCardColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: [
          _buildSource(context, playerManager),
          _buildArtists(context, playerManager),
          _buildalbum(context, playerManager),
        ],
      ),
    ));
  }

  /// 来源
  Widget _buildSource(BuildContext context, MusicPlayerManager playerManager) {
    if (playerManager.playingSource.display) {
      var color = ColorHelper.playingTitleColor;
      return QYBounce(
        absorbOnMove: true,
        onPressed: () {
          LogUtil.v('点击来源');
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Inchs.sp8),
          child: Row(
            children: [
              Text(
                '来源:',
                style: AppTheme.subtitleCopyStyle(context, color: color),
              ),
              QYSpacing(
                width: 4,
              ),
              Text(
                playerManager.playingSource.soleName!,
                style: AppTheme.subtitleCopyStyle(context, color: color),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: color,
              )
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  /// 歌手
  Widget _buildArtists(BuildContext context, MusicPlayerManager playerManager) {
    var artists = playerManager.currentSong.artists;
    if (!ListOptionalHelper.hasValue(artists)) return SizedBox.shrink();
    var color = ColorHelper.playingTitleColor;
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        // 判断个数
        if (artists!.length == 1) {
          LogUtil.v('跳转歌手详情');
        } else {
          LogUtil.v('更多歌手');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Inchs.sp8),
        child: Row(
          children: [
            Text(
              '歌手:',
              style: AppTheme.subtitleCopyStyle(context, color: color),
            ),
            QYSpacing(
              width: 4,
            ),
            Expanded(
                child: Text(playerManager.currentSong.artistName,
                    style: AppTheme.subtitleCopyStyle(context, color: color))),
            Icon(
              Icons.chevron_right,
              color: color,
            )
          ],
        ),
      ),
    );
  }

  /// 专辑
  Widget _buildalbum(BuildContext context, MusicPlayerManager playerManager) {
    var album = playerManager.currentSong.album;
    if (album == null) return SizedBox.shrink();
    var color = ColorHelper.playingTitleColor;
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('专辑详情');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Inchs.sp8),
        child: Row(
          children: [
            Text(
              '专辑:',
              style: AppTheme.subtitleCopyStyle(context, color: color),
            ),
            QYSpacing(
              width: 4,
            ),
            Expanded(
                child: Text(album.name ?? '',
                    style: AppTheme.subtitleCopyStyle(context, color: color))),
            Icon(
              Icons.chevron_right,
              color: color,
            )
          ],
        ),
      ),
    );
  }
}

class MusicPlayingSimiPlaylistItem extends StatefulWidget {
  final MusicSong song;
  final MusicPlayingSource source;

  const MusicPlayingSimiPlaylistItem(
      {Key? key, required this.song, required this.source})
      : super(key: key);

  @override
  _MusicPlayingSimiPlaylistItemState createState() =>
      _MusicPlayingSimiPlaylistItemState();
}

class _MusicPlayingSimiPlaylistItemState
    extends State<MusicPlayingSimiPlaylistItem> {
  late double _imageSize;
  MusicPlayingSimiPlaylistViewModel? _viewModel;
  late MusicSong _currentSong;
  late MusicPlayingSource _currentSource;
  @override
  void initState() {
    _imageSize =
        (Inchs.screenWidth - 2 * Inchs.sp6 - Inchs.right - Inchs.left) / 3;
    _currentSong = widget.song;
    _currentSource = widget.source;
    super.initState();
  }

  @override
  void didUpdateWidget(MusicPlayingSimiPlaylistItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.song != _currentSong || widget.source != _currentSource) {
      LogUtil.v('需要重新开始网络请求了');
      _currentSong = widget.song;
      _currentSource = widget.source;
      _viewModel?.initData(_currentSource, _currentSong.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicPlayingSimiPlaylistViewModel>(
      viewModel: MusicPlayingSimiPlaylistViewModel(),
      onModelReady: (viewModel) =>
          viewModel.initData(_currentSource, _currentSong.id),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        if (viewModel.isBusy) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: ViewStateBusyWidget(
              backgroundColor: ColorHelper.playingCardColor,
            ),
          ));
        } else if (viewModel.isError) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: () {
                  viewModel.initData(_currentSource, _currentSong.id);
                }),
          ));
        } else if (viewModel.isEmpty) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text(
              '暂无歌单',
              style: AppTheme.titleCopyStyle(context,
                  color: ColorHelper.playingTitleColor),
            ),
          ));
        }
        var itemCount =
            viewModel.playlists.length > 3 ? 3 : viewModel.playlists.length;
        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: Inchs.sp4, left: 4, right: 4),
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            height: _imageSize + 60,
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: Inchs.sp6,
                  crossAxisSpacing: Inchs.sp6,
                  mainAxisExtent: _imageSize + 50),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                var playlist = viewModel.playlists[index];
                return QYBounce(
                  absorbOnMove: true,
                  onPressed: () {
                    LogUtil.v('点击歌单');
                  },
                  child: Container(
                    child: Column(
                      children: [
                        ImageLoadView(
                          imagePath: ImageCompressHelper.musicCompress(
                              playlist.coverImgUrl, _imageSize, _imageSize),
                          width: _imageSize,
                          height: _imageSize,
                          radius: 5,
                        ),
                        QYSpacing(
                          height: 4,
                        ),
                        Text(
                          playlist.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.titleCopyStyle(context,
                              color: ColorHelper.playingTitleColor,
                              fontSize: 14),
                        ),
                        QYSpacing(
                          height: 4,
                        ),
                        Text(
                          playlist.creator?.nickname ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.subtitleCopyStyle(context,
                              color: ColorHelper.playingTitleColor,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class MusicPlayingSimiSongtItem extends StatefulWidget {
  final MusicSong song;
  final MusicPlayingSource source;

  const MusicPlayingSimiSongtItem(
      {Key? key, required this.song, required this.source})
      : super(key: key);

  @override
  _MusicPlayingSimiSongtItemState createState() =>
      _MusicPlayingSimiSongtItemState();
}

class _MusicPlayingSimiSongtItemState extends State<MusicPlayingSimiSongtItem> {
  MusicPlayingSimiSongViewModel? _viewModel;
  late MusicSong _currentSong;
  late MusicPlayingSource _currentSource;
  @override
  void initState() {
    _currentSong = widget.song;
    _currentSource = widget.source;
    super.initState();
  }

  @override
  void didUpdateWidget(MusicPlayingSimiSongtItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.song != _currentSong || widget.source != _currentSource) {
      LogUtil.v('重新网络请求');
      _currentSong = widget.song;
      _currentSource = widget.source;
      _viewModel?.initData(_currentSource, _currentSong.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicPlayingSimiSongViewModel>(
      viewModel: MusicPlayingSimiSongViewModel(),
      onModelReady: (viewModel) =>
          viewModel.initData(_currentSource, _currentSong.id),
      builder: (context, viewModel, child) {
        _viewModel = viewModel;
        if (viewModel.isBusy) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: ViewStateBusyWidget(
              backgroundColor: ColorHelper.playingCardColor,
            ),
          ));
        } else if (viewModel.isError) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: () {
                  viewModel.initData(_currentSource, _currentSong.id);
                }),
          ));
        } else if (viewModel.isEmpty) {
          return SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(bottom: Inchs.sp6),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text(
              '暂无歌曲',
              style: AppTheme.titleCopyStyle(context,
                  color: ColorHelper.playingTitleColor),
            ),
          ));
        }

        var name = widget.song.name ?? '';
        name = name + "相关推荐";
        var source = MusicPlayingSource(widget.song.id,
            soleName: name, soleType: MusicPlayingSourceType.similarSong);

        return SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: ColorHelper.playingCardColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
            child: Column(
              children: List.generate(viewModel.songs.length, (index) {
                var song = viewModel.songs[index];
                return MusicPlaylistTile(
                  source: source,
                  data: viewModel.songs,
                  song: song,
                  index: index,
                  titleColor: ColorHelper.playingTitleColor,
                  subtitleColor: ColorHelper.playingTitleColor,
                  playingColor: AppTheme.primaryColor(context),
                  padding: EdgeInsets.symmetric(vertical: Inchs.sp10),
                  onPressed: () async {
                    if (song.isPlayable) {
                      var playerManager = MusicPlayerManager.of(context);
                      var canPlaySongs = viewModel.songs.where((element) => element.isPlayable).toList();
                      await playerManager.playWithSongs(
                          source, List.from(canPlaySongs), index);
                    } else {
                      QYToast.showError(context, '暂无音乐版权');
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
