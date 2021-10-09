import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';


class MusicPlayingTitle extends StatefulWidget {
  @override
  _MusicPlayingTitleState createState() => _MusicPlayingTitleState();
}

class _MusicPlayingTitleState extends State<MusicPlayingTitle> {
  late MusicPlayerManager _playerManager;
  @override
  void initState() {
    _playerManager = MusicPlayerManager.of(context);
    _playerManager.onPlayerItemChanged.listen((event) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
        child: Padding(
          padding: EdgeInsets.only(left: Inchs.left - 8, right: Inchs.right),
          child: Row(
            children: [
              QYBounce(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: Image.asset(
                  ImageHelper.wrapMusicPng(
                    'music_playing_nav_down',
                  ),
                  width: 24,
                  height: 24,
                ),
                )
              ),
              Spacer(),
              Container(
                  width: Inchs.adapter(200),
                  child: Column(
                    children: [
                      Text(
                        _playerManager.currentSong.title,
                        style: AppTheme.titleStyle(context)
                            .copyWith(color: Colors.white, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _playerManager.currentSong.subTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.subtitleStyle(context)
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              
              Spacer(),
              QYBounce(
                onPressed: () {
                  LogUtil.v('点击分享');
                },
                child: Image.asset(
                ImageHelper.wrapMusicPng(
                  'music_playing_nav_share',
                ),
                width: 26,
                height: 26,
              ),
              )
            ],
          ),
        ));
  }
}

