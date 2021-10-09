import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/music_song_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/pulse_animation_widget.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicPlaylistTile extends StatelessWidget {
  final List<MusicSong> data;

  /// 来源
  final MusicPlayingSource source;

  final MusicSong song;
  final int index;
  final VoidCallback? onPressed;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? playingColor;
  final Color? disabledColor;
  final EdgeInsetsGeometry? padding;
  MusicPlaylistTile(
      {Key? key,
      required this.source,
      required this.data,
      required this.song,
      required this.index,
      this.onPressed,
      EdgeInsetsGeometry? padding,
      this.titleColor,
      this.subtitleColor,
      this.playingColor,
      this.disabledColor})
      : this.padding = padding ??
            EdgeInsets.symmetric(horizontal: Inchs.left, vertical: Inchs.sp8),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    MusicPlayerManager playerManager =
        MusicPlayerManager.of(context);
    var titleColor = this.titleColor ?? AppTheme.titleColor(context);
    var subtitleColor = this.subtitleColor ?? AppTheme.subtitleColor(context);
    var playingColor = this.playingColor ?? AppTheme.primaryColor(context);
    if (!song.isPlayable) {
      titleColor = this.disabledColor ?? AppTheme.of(context).disabledColor;
      subtitleColor = this.disabledColor ?? AppTheme.of(context).disabledColor;
    }
    return Container(
      padding: padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          QYBounce(
            absorbOnMove: true,
            onPressed: onPressed,
            child: Container(
              padding: EdgeInsets.only(right: 50),
              child: Row(
                children: [
                  _buildLeading(context, playerManager, song, index,
                      playingColor, subtitleColor),
                  Expanded(
                      child: _buildMiddle(context, playerManager, song,
                          titleColor, subtitleColor, playingColor)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildTrailing(subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(BuildContext context, MusicPlayerManager playerManager,
      MusicSong song, int index, Color playingColor, Color subtitleColor) {
    var color = subtitleColor;
    if (playerManager.equalWith(song,soleId: source.soleId, )) {
      color = playingColor;
    }
    return PulseAnimationWidget(
      animation: playerManager.isPlayingFor(song, soleId: source.soleId),
      height: 10,
      width: 1,
      color: playingColor,
      unAnimationBuilder: (context) {
        return Text(
          '${index + 1}',
          style:
              AppTheme.subtitleCopyStyle(context, fontSize: 16, color: color),
        );
      },
    );
  }

  Widget _buildMiddle(
      BuildContext context,
      MusicPlayerManager playerManager,
      MusicSong song,
      Color titleColor,
      Color subtitleColor,
      Color playingColor) {
    var color = titleColor;
    if (playerManager.equalWith( song,soleId: source.soleId,)) {
      color = playingColor;
    }
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleStyle(context).copyWith(color: color),
          ),
          QYSpacing(
            height: 6,
          ),
          Row(
            children: [
              MusicSongHelper.identifie(context, song),
              QYSpacing(
            width: 3,
          ),
              Expanded(
                child: Text(
                  song.subTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.subtitleStyle(context)
                      .copyWith(color: subtitleColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(Color subtitleColor) {
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
                    width: 24,
                    color: subtitleColor,
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
                  width: 24,
                  color: subtitleColor,
                ),
              )),
        ],
      ),
    );
  }
}
