import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/home/music_per_new_song.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/pulse_animation_widget.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicPersonalizedNewSongPage extends StatefulWidget {
  @override
  _MusicPersonalizedNewSongPageState createState() =>
      _MusicPersonalizedNewSongPageState();
}

class _MusicPersonalizedNewSongPageState
    extends State<MusicPersonalizedNewSongPage> {
  late MusicPlayerManager _playerManager;
  StreamSubscription<PlayerState>? _stateStreamSubscription;
  /// 标识当前是否播放 来更新页面
  bool _isCurrentPlaying = false;
  @override
  void initState() {
    _playerManager = MusicPlayerManager.of(context);

    /// 添加状态改变的回调 减少刷新
    _stateStreamSubscription =
        _playerManager.onPlayerStateChanged.listen((event) {
      if (!mounted) return;
      if (_playerManager.playingSource.soleType ==
          MusicPlayingSourceType.perNewSong) {
        _isCurrentPlaying = true;
        setState(() {});
      } else {
        if (!_isCurrentPlaying) return;
        _isCurrentPlaying = false;
        setState(() {});
      }
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
    return ProviderWidget<MusicPersonalizedNewSongViewModel>(
      viewModel: MusicPersonalizedNewSongViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.perNewSongs.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadr(viewModel.perNewSongs),
            _buildContent(context, viewModel.perNewSongs)
          ],
        );
      },
    );
  }

  Widget _buildHeadr(List<MusicPerNewSong> perNewSongs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).recommended_new_song,
            style: AppTheme.titleStyle(context),
          ),
          QYButtom(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4),
            height: 26,
            title: Text(S.of(context).more),
            imageAlignment: ImageAlignment.right,
            image: Icon(
              Icons.chevron_right,
              size: 20,
              color: AppTheme.subtitleColor(context),
            ),
            imageMargin: 0,
            border: Border.all(color: AppTheme.iconColor(context)),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_) {
              Navigator.of(context).pushNamed(MyRouterName.music_new_container);
            },
          )
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<MusicPerNewSong> perNewSongs) {
    return Container(
      height: 140,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 16, right: 16),
        itemCount: perNewSongs.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 70,
            mainAxisExtent: Inchs.screenWidth - 50,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4),
        itemBuilder: (context, index) {
          var perNewSong = perNewSongs[index];
          return _buildContentItem(context, perNewSongs, index, perNewSong);
        },
      ),
    );
  }

  Widget _buildContentItem(
      BuildContext context,
      List<MusicPerNewSong> perNewSongs,
      int index,
      MusicPerNewSong perNewSong) {
    var isPlaying = _playerManager.isPlayingFor(perNewSong.song!,
        soleId: MusicPlayerManager.perNewSongSoleId);
    return Container(
      child: Stack(
        children: [
          QYBounce(
              absorbOnMove: true,
              onPressed: () async {
                var songs = perNewSongs.map((e) => e.song!).toList();
                if (songs.isNotEmpty) {
                  var source = MusicPlayingSource(
                      MusicPlayerManager.perNewSongSoleId,
                      soleType: MusicPlayingSourceType.perNewSong,
                      soleName: '首页推荐新音乐');
                  await _playerManager.playWithSongs(source, songs, index);
                }
              },
              child: Container(
                padding: EdgeInsets.only(right: 40),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageLoadView(
                          imagePath: ImageCompressHelper.musicCompress(
                              perNewSong.picUrl, 60, 60),
                          width: 60,
                          height: 60,
                          radius: 5,
                        ),
                        Center(
                            child: PulseAnimationWidget(
                          animation: isPlaying,
                        ))
                      ],
                    ),
                    QYSpacing(
                      width: 4,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            perNewSong.song?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          QYSpacing(
                            height: 4,
                          ),
                          Text(
                            perNewSong.song?.subTitle ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          if (perNewSong.song?.hasMV == true)
            Align(
                alignment: Alignment.centerRight,
                child: QYBounce(
                  absorbOnMove: true,
                  onPressed: () {
                    LogUtil.v('点击视频');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      ImageHelper.wrapMusicPng(
                        'music_play_list_video',
                      ),
                      width: 24,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
