import 'package:flutter/material.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/border_container.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicSongHelper {
  /// 标示
  static Widget identifie(BuildContext context, MusicSong song) {
    List<Widget> children = [];

    /// 是否可播放
    if (!song.isPlayable) {
      if (song.noCopyrightRcmd != null) {
        var color = AppTheme.of(context).disabledColor;
        Widget child = Row(
          children: [
            BorderContainer(data: '无音质', color: color),
            QYSpacing(
              width: 2,
            ),
            Text(
              song.noCopyrightRcmd?.typeDesc ?? '',
              style: AppTheme.subtitleCopyStyle(context,
                  fontSize: 11, color: color),
            ),
             QYSpacing(
              width: 2,
            ),
            Text(
              '|',
              style: AppTheme.subtitleCopyStyle(context,
                  fontSize: 11, color: color),
            )
          ],
        );
        return Container(child: child);
      }
      return SizedBox.shrink();
    }
    var color = AppTheme.primaryColor(context);

    /// 判断vip
    if (song.isVipAudition) {
      Widget vipChild = Row(
        children: [
          BorderContainer(data: 'VIP', color: color),
          QYSpacing(
            width: 2,
          ),
          BorderContainer(data: '试听', color: color),
        ],
      );
      children.add(vipChild);
    }
    if (song.hasNondestructiveQuality) {
      Widget child = BorderContainer(data: 'SQ', color: color);
      children.add(child);
    }
    return Container(
      child: Row(
        children: children,
      ),
    );
  }
}
