import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/music/music_download_button.dart';
import 'package:flutter_app/widget/music/music_like_button.dart';


class MusicPlayingOperationBar extends StatelessWidget {
  final MusicSong song;

  const MusicPlayingOperationBar({Key? key, required this.song})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: Inchs.sp10, bottom: Inchs.sp10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MusicLikeButton(song: song),
          MusicDownloadButton(
            song: song,
          ),
          Stack(
            children: [
              /// 扩展Stack宽度
              Container(width: 46),
              Image.asset(
                ImageHelper.wrapMusicPng(
                  'music_playing_sing_num',
                ),
                width: 28,
                height: 28,
              ),
              Positioned(
                left: 20,
                top: 0,
                child: Text(
                  '999+',
                  style: AppTheme.subtitleStyle(context)
                      .copyWith(color: Colors.white, fontSize: 9),
                ),
              )
            ],
          ),
          Stack(
            children: [
              /// 扩展Stack宽度
              Container(width: 46),
              Image.asset(
                ImageHelper.wrapMusicPng(
                  'music_playing_cmt_num',
                ),
                width: 28,
                height: 28,
              ),
              Positioned(
                left: 20,
                top: 0,
                child: Text(
                  '999+',
                  style: AppTheme.subtitleStyle(context)
                      .copyWith(color: Colors.white, fontSize: 9),
                ),
              )
            ],
          ),
          InkWell(
            onTap: () {
              LogUtil.v('more');
            },
            child: Image.asset(
              ImageHelper.wrapMusicPng(
                'music_playing_more',
              ),
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
    );
  }
}
