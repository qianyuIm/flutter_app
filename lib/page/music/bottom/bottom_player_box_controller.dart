import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/page/music/bottom/music_playing_list_dialog.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music/music_progress_tracking_container.dart';
import 'package:flutter_app/widget/qy_bounce.dart';

class BottomPlayerBoxController extends StatelessWidget {
  final Widget child;
  final bool bottomPadding;
  const BottomPlayerBoxController(
      {Key? key, required this.child, this.bottomPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        BottomPlayingContainer(
          bottomPadding: bottomPadding,
        ),
      ],
    );
  }
}

/// 50
const double kBottomPlayerControllerHeight = 50;
const String kBottomPlayingContainerHeroTag = "BottomPlayingContainerHeroTag";

class BottomPlayingContainer extends StatefulWidget {
  final bool bottomPadding;

  const BottomPlayingContainer({Key? key, required this.bottomPadding})
      : super(key: key);

  @override
  _BottomPlayingContainerState createState() => _BottomPlayingContainerState();
}

class _BottomPlayingContainerState extends State<BottomPlayingContainer> {
  late final MusicPlayerManager _playerManager;
  late CarouselController _carouselController;
  MusicPlayerItem? _currentItem;
  StreamSubscription<MusicPlayerItem>? _subscription;
  CarouselPageChangedReason _reason = CarouselPageChangedReason.timed;
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _playerManager = MusicPlayerManager.of(context);
    _future = _initialize();
    _playerManager.onDataSourceChangedNotifier
        ?.addListener(_onDataValueChanged);
    _subscription =
        _playerManager.onPlayerItemChanged.distinct().listen((item) {
      if (!mounted) return;
      if (_reason == CarouselPageChangedReason.manual) return;
      if (_currentItem == item) return;
      if (_currentItem?.source == item.source) {
        _carouselController.jumpToPage(item.index);
      } else {
        setState(() {});
      }
      _currentItem = item;
    });
  }

  @override
  void dispose() {
    _playerManager.onDataSourceChangedNotifier
        ?.removeListener(_onDataValueChanged);
    _subscription?.cancel();
    super.dispose();
  }

  Future<bool> _initialize() async {
    return _playerManager.initialize();
  }

  /// 数据改变通知
  void _onDataValueChanged() {
    LogUtil.v('底部数据改变 => ${_playerManager.onDataSourceChangedNotifier?.value}');
    if (_playerManager.onDataSourceChangedNotifier?.value == false) {
      _currentItem = null;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_playerManager.hasData) {
            return _buildContent();
          }
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Hero(
          tag: kBottomPlayingContainerHeroTag,
          child: _buildMusicContent(),
        ),
        if (widget.bottomPadding)
          Container(
            height: Inchs.bottomBarHeight,
            color:
                AppTheme.bottomNavigationBarThemeData(context).backgroundColor,
          )
      ],
    );
  }

  Widget _buildMusicContent() {
    return Container(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        color: AppTheme.bottomNavigationBarThemeData(context).backgroundColor,
        child: Row(
          children: [
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  height: kBottomPlayerControllerHeight,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  initialPage: _playerManager.currentIndex,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    if (reason == CarouselPageChangedReason.manual) {
                      _reason = CarouselPageChangedReason.manual;
                      LogUtil.v('请求数据');
                      _playerManager.playIndex(index).then(
                          (value) => _reason = CarouselPageChangedReason.timed);
                    } else {
                      LogUtil.v('不请求数据');
                    }
                  },
                ),
                items: _playerManager.currentPlaySongs
                    .map((song) => BottomPlayingItem(
                          song: song,
                          index: _playerManager.currentPlaySongs.indexOf(song),
                        ))
                    .toList(),
              ),
            ),
            _buildPause(),
            _buildMenu()
          ],
        ));
  }

  Widget _buildPause() {
    return StreamBuilder<PlayerState>(
      initialData: _playerManager.playerState,
      stream: _playerManager.onPlayerStateChanged,
      builder: (context, snapshot) {
        var audioState = snapshot.data;
        if (_playerManager.isBuffering) {
          return Container(
            height: 24,
            width: 24,
            margin: EdgeInsets.only(right: 12),
            padding: EdgeInsets.all(4),
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor(context),
            ),
          );
        }
        return QYBounce(
          onPressed: () {
            if (audioState == PlayerState.PLAYING) {
              _playerManager.pause();
            }
            if (audioState == PlayerState.PAUSED) {
              _playerManager.resume();
            }
            if (audioState == PlayerState.STOPPED) {
              _playerManager.play();
            }
          },
          child: Container(
            // color: Colors.red,
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Icon(
              (audioState == PlayerState.PAUSED ||
                      audioState == PlayerState.STOPPED)
                  ? Icons.play_circle_fill
                  : Icons.pause_circle_filled,
              size: 26,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenu() {
    return QYBounce(
      onPressed: () {
        MusicPlayingDialog.show(context);
      },
      child: Icon(
        Icons.menu,
        size: 26,
      ),
    );
  }
}

class BottomPlayingItem extends StatefulWidget {
  final MusicSong song;
  final int index;

  const BottomPlayingItem({Key? key, required this.song, required this.index})
      : super(key: key);

  @override
  _BottomPlayingItemState createState() => _BottomPlayingItemState();
}

class _BottomPlayingItemState extends State<BottomPlayingItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late MusicPlayerManager _playerManager;
  StreamSubscription<PlayerState>? _stateStreamSubscription;
  @override
  void initState() {
    super.initState();
    _playerManager = MusicPlayerManager.of(context);
    _animationController =
        AnimationController(duration: Duration(seconds: 25), vsync: this);
    if (_playerManager.isPlayingFor(widget.song)) {
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
    _stateStreamSubscription =
        _playerManager.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (_playerManager.isPlayingFor(widget.song)) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        Navigator.of(context).pushNamed(MyRouterName.playing);
      },
      child: Container(
        height: 50,
        child: _buildInfo(),
      ),
    );
  }

  Widget _buildInfo() {
    return StreamBuilder<PlayerState>(
        initialData: _playerManager.playerState,
        stream: _playerManager.onPlayerStateChanged,
        builder: (context, snapshot) {
          return Row(
            children: [
              RotationTransition(
                  alignment: Alignment.center,
                  turns: _animationController,
                  child: ImageLoadView(
                    imagePath: ImageCompressHelper.musicCompress(
                        widget.song.album?.picUrl, 40, 40),
                    width: 40,
                    height: 40,
                    radius: 20,
                  )),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 6, right: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        child: Text(
                          '${widget.song.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Material(
                        child: MusicProgressTrackingContainer(
                          manager: _playerManager,
                          song: widget.song,
                          builder: (context) => _SubTitleOrLyric(widget.song),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

/// 副标题或者歌词
class _SubTitleOrLyric extends StatelessWidget {
  final MusicSong song;

  _SubTitleOrLyric(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerManager = MusicPlayerManager.of(context);
    if (!playerManager.hasLyric || !playerManager.isPlayingFor(song)) {
      return Text(
        song.subTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final line = playerManager.lyric!
        .getLineByTimeStamp(playerManager.position.inMilliseconds, 0)
        ?.line;

    if (line == null || line.isEmpty) {
      return Text(
        playerManager.previouLyric ?? song.subTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      playerManager.previouLyric = line;
    }

    return Text(
      line,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
