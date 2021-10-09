import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:colour/colour.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/page/music/bottom/bottom_player_box_controller.dart';
import 'package:flutter_app/page/music/playList/music_playlist_song_item.dart';
import 'package:flutter_app/page/music/playList/music_playlist_subscriber_item.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/scroll_controller_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/animated_widget.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music/music_transparent_flexible_space_bar.dart';
import 'package:flutter_app/widget/music/music_transparent_header.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/qy_toast.dart';
import 'package:marquee/marquee.dart';

///歌单详情信息 header 高度 120
const double kHeaderContentHeight = 120;

/// 40 + 44
const double kHeaderContentBottom = (kHeaderContentBottomHeight + 40.0);

/// 20
const double kHeaderContentLeft = 20;

/// 20
const double kHeaderContentRight = 20;

double kHeaderContentLineMaxWidth = (Inchs.screenWidth -
    kHeaderContentLeft -
    kHeaderContentRight -
    kHeaderContentHeight -
    50);

/// 44
const double kHeaderContentBottomHeight = 44;

const double kExpandedHeight =
    (kHeaderContentHeight + kHeaderContentBottom + kToolbarHeight + 10);
const double kTriggerHeight = kHeaderContentHeight + kToolbarHeight;

class MusicPlaylistDetailPage extends StatefulWidget {
  final int playlistId;

  const MusicPlaylistDetailPage({Key? key, required this.playlistId})
      : super(key: key);

  @override
  _MusicPlaylistDetailPageState createState() =>
      _MusicPlaylistDetailPageState();
}

class _MusicPlaylistDetailPageState extends State<MusicPlaylistDetailPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomPlayerBoxController(
          child: ProviderWidget2<ScrollControllerViewModel,
              MusicPlayListDetailViewModel>(
        viewModel1:
            ScrollControllerViewModel(_scrollController, kTriggerHeight),
        viewModel2: MusicPlayListDetailViewModel(widget.playlistId),
        onModelReady: (viewModel1, viewModel2) {
          viewModel1.init();
          viewModel2.initData();
        },
        builder: (context, viewModel1, viewModel2, child) {
          if (viewModel2.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel2.isError) {
            return ViewStateErrorWidget(
                error: viewModel2.viewStateError!,
                onPressed: viewModel2.initData);
          } else if (viewModel2.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel2.initData);
          }
          return CustomScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(viewModel2.playlist, viewModel1.trigger),
              MusicPlaylistBody(
                playlist: viewModel2.playlist,
              )
            ],
          );
        },
      )),
    );
  }

  Widget _buildAppBar(MusicPlayList playlist, bool trigger) {
    Widget? title;
    if (trigger) {
      title = Container(
        alignment: Alignment.center,
        width: Inchs.adapter(220),
        height: 40,
        child: Marquee(
          key: Key("_Marquee"),
          blankSpace: 40.0,
          pauseAfterRound: const Duration(seconds: 3),
          fadingEdgeStartFraction: 0.1,
          fadingEdgeEndFraction: 0.3,
          text: playlist.name ?? '',
          velocity: 20.0,
        ),
      );
    } else {
      title = Container(
        alignment: Alignment.center,
        width: Inchs.adapter(240),
        child: Text('歌单'),
      );
    }

    return MusicTransparentHeader(
      stretch: true,
      title: ScaleAnimatedSwitcher(child: title),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: AppTheme.appBarTheme(context)
          .titleTextStyle
          ?.copyWith(color: Colors.white),
      expandedHeight: kExpandedHeight,
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(playlist.coverImgUrl,
                kHeaderContentHeight, kHeaderContentHeight),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ],
      ),
      content: Container(
        width: Inchs.screenWidth - kHeaderContentLeft - kHeaderContentRight,
        height: kHeaderContentHeight,
        child: MusicPlaylistHeaderContent(playList: playlist),
      ),
      contentPadding: EdgeInsets.only(left: 0, bottom: kHeaderContentBottom),
      stretchModes: [
        MusicTransparentStretchMode.fadeContent,
        MusicTransparentStretchMode.zoomBackground
      ],
      bottom: MusicPlaylistBottom(
        playlist: playlist,
        onPressedReload: () {
          setState(() {});
        },
      ),
    );
  }
}

class MusicPlaylistHeaderContent extends StatelessWidget {
  final MusicPlayList playList;

  const MusicPlaylistHeaderContent({Key? key, required this.playList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ImageLoadView(
              imagePath: ImageCompressHelper.musicCompress(playList.coverImgUrl,
                  kHeaderContentHeight, kHeaderContentHeight),
              width: kHeaderContentHeight,
              height: kHeaderContentHeight,
              radius: 5,
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colour('333333', 0.4),
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Image.asset(
                        ImageHelper.wrapMusicPng('music_play_list_play_arrow'),
                        width: 12,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        StringHelper.formateNumber(playList.playCount),
                        style: AppTheme.subtitleStyle(context)
                            .copyWith(fontSize: 11, color: Colors.white70),
                      )
                    ],
                  )),
            )
          ],
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Container(
              height: kHeaderContentHeight,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: kHeaderContentHeight - 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playList.name ?? '',
                            style: AppTheme.titleStyle(context)
                                .copyWith(fontSize: 17, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              ImageLoadView(
                                imagePath: ImageCompressHelper.musicCompress(
                                    playList.creator?.avatarUrl, 24, 24),
                                width: 24,
                                height: 24,
                                shape: BoxShape.circle,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Text(
                                  playList.creator?.nickname ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.subtitleStyle(context)
                                      .copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const Spacer(),

                    /// https://blog.csdn.net/lhj_android/article/details/116233547
                    Container(
                      height: 30,
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: kHeaderContentLineMaxWidth,
                                maxHeight: 30),
                            child: Text(
                              StringHelper.shifterFormateBlank(
                                  playList.description ?? '暂无简介'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.subtitleStyle(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}

class MusicPlaylistBottom extends StatelessWidget
    implements PreferredSizeWidget {
  final MusicPlayList playlist;

  /// 点击全部之后更新页面使用
  final VoidCallback onPressedReload;

  const MusicPlaylistBottom(
      {Key? key, required this.playlist, required this.onPressedReload})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kHeaderContentBottomHeight);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Material(
            color: AppTheme.scaffoldBackgroundColor(context),
            child: SizedBox.fromSize(
                size: preferredSize,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: Inchs.left, right: Inchs.right),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          QYBounce(
                            onPressed: () async {
                              if (playlist.trackSongs != null) {
                                LogUtil.v('播放全部');

                                var canPlaySongs = playlist.trackSongs!
                                    .where((element) => element.isPlayable)
                                    .toList();
                                if (canPlaySongs.isEmpty) {
                                  QYToast.showError(context, '暂无音乐可以播放');
                                } else {
                                  var playerManager =
                                      MusicPlayerManager.of(context);
                                  var source = MusicPlayingSource(playlist.id,
                                      soleName: playlist.name,
                                      soleType:
                                          MusicPlayingSourceType.playlist);
                                  playerManager
                                      .playWithSongs(
                                          source, List.from(canPlaySongs), 0)
                                      .then((value) {
                                    onPressedReload.call();
                                  });
                                }
                              }
                            },
                            child: Icon(
                              Icons.play_circle_outline,
                              color: AppTheme.primaryColor(context),
                            ),
                          ),
                          QYSpacing(
                            width: 4,
                          ),
                          Text('播放全部', style: AppTheme.titleStyle(context)),
                          QYSpacing(
                            width: 4,
                          ),
                          Text(ListOptionalHelper.hasValue(playlist.trackIds)
                              ? '(${playlist.trackIds!.length.toString()})'
                              : ''),
                        ],
                      ),
                      QYBounce(
                        absorbOnMove: true,
                        onPressed: () {
                          LogUtil.v('下载全部');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            ImageHelper.wrapMusicPng(
                              'music_play_list_download',
                            ),
                            width: 18,
                            color: AppTheme.titleColor(context),
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }
}

class MusicPlaylistBody extends StatefulWidget {
  final MusicPlayList playlist;

  const MusicPlaylistBody({Key? key, required this.playlist}) : super(key: key);

  @override
  _MusicPlaylistBodyState createState() => _MusicPlaylistBodyState();
}

class _MusicPlaylistBodyState extends State<MusicPlaylistBody> {
  late MusicPlayList _playlist;
  late MusicPlayerManager _playerManager;
  StreamSubscription<PlayerState>? _stateStreamSubscription;

  @override
  void initState() {
    _playlist = widget.playlist;
    _playerManager = MusicPlayerManager.of(context);
    _stateStreamSubscription =
        _playerManager.onPlayerStateChanged.listen((event) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> ids = [];
    if (ListOptionalHelper.hasValue(_playlist.trackIds)) {
      ids = _playlist.trackIds!.map((e) => e.id).toList();
    }
    return ProviderWidget<MusicPlayListItemViewModel>(
      viewModel: MusicPlayListItemViewModel(ids, _playlist),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return SliverToBoxAdapter(child: ViewStateBusyWidget());
        } else if (viewModel.isError) {
          return SliverToBoxAdapter(
              child: ViewStateErrorWidget(
                  error: viewModel.viewStateError!,
                  onPressed: viewModel.initData));
        } else if (viewModel.isEmpty) {
          return SliverToBoxAdapter(
              child: ViewStateEmptyWidget(onPressed: viewModel.initData));
        }
        var source = MusicPlayingSource(_playlist.id,
            soleName: _playlist.name,
            soleType: MusicPlayingSourceType.playlist);
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == viewModel.songs.length) {
              return MusicPlaylistSubscriberItem(
                playList: _playlist,
              );
            }
            MusicSong song = viewModel.songs[index];
            var canPlaySongs =
                viewModel.songs.where((element) => element.isPlayable).toList();
            return MusicPlaylistTile(
              source: source,
              data: viewModel.songs,
              song: song,
              index: index,
              onPressed: () async {
                if (song.isPlayable) {
                  var playerManager = MusicPlayerManager.of(context);
                  var playIndex = canPlaySongs.indexOf(song);
                  await playerManager
                      .playWithSongs(source, List.from(canPlaySongs), playIndex)
                      .then((value) {
                    setState(() {});
                  });
                } else {
                  QYToast.showError(context, '暂无音乐版权');
                }
              },
            );
          }, childCount: viewModel.songs.length + 1),
        );
      },
    );
  }
}
