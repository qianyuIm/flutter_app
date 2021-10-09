import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';

class MusicLikeButton extends StatelessWidget {
  final MusicSong song;
  const MusicLikeButton({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        LogUtil.v('喜欢');
      },
      icon: Image.asset(ImageHelper.wrapMusicPng('music_playing_love',
          )),
    );
  }
}
