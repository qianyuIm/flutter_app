import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';

import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:provider/provider.dart';

class UserFavoriteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var playlistViewModel = context.watch<UserPlaylistViewModel>();
    return Container(
        margin:
            EdgeInsets.only(left: Inchs.left, right: Inchs.right, bottom: 5),
        child: Card(
          child: Container(
              child: Stack(
            alignment: Alignment.center,
            children: [
              QYBounce(
                absorbOnMove: true,
                onPressed: () {
                  LogUtil.v('喜欢');
                },
                child: Row(
                  children: [
                    _buildLeading(playlistViewModel.favoritePlaylist),
                    Expanded(
                      child: _buildTitle(
                          context, playlistViewModel.favoritePlaylist),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _buildTrailing(context),
              )
            ],
          )),
        ));
  }

  Widget _buildLeading(MusicPlayList? favoritePlaylist) {
    Widget? child;
    if (favoritePlaylist != null) {
      child = ImageLoadView(
        imagePath: ImageCompressHelper.musicCompress(
            favoritePlaylist.coverImgUrl, 50, 50),
        width: 50,
        height: 50,
        radius: 5,
      );
    } else {
      child = ImageLoadView(
        imagePath: ImageHelper.wrapMusicPng('icon_user_favorite_placeholder'),
        imageType: ImageLoadType.assets,
        width: 50,
        height: 50,
        radius: 5,
      );
    }

    return Container(
      padding: EdgeInsets.all(15),
      child: child,
    );
  }

  Widget _buildTitle(BuildContext context, MusicPlayList? favoritePlaylist) {
    var trackCount =
        (favoritePlaylist != null) ? favoritePlaylist.trackCount : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).user_like_music,
          style: AppTheme.titleStyle(context),
        ),
        QYSpacing(
          height: 4,
        ),
        Text('$trackCount 首')
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击心动');
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.iconColor(context)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            S.of(context).user_heartbeat,
            style: AppTheme.subtitleCopyStyle(context, fontSize: 11),
          )),
    );
  }
}
