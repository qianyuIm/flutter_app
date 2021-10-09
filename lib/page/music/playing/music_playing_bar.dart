import 'package:audioplayers/audioplayers.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/clear_ink_well.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MusicPlayingBar extends StatefulWidget {
  @override
  _MusicPlayingBarState createState() => _MusicPlayingBarState();
}

class _MusicPlayingBarState extends State<MusicPlayingBar> {
  @override
  Widget build(BuildContext context) {
    MusicPlayerManager playerManager = MusicPlayerManager.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: Inchs.sp10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QYBounce(
            onPressed: () {
              playerManager.setPlayMode(playerManager.playMode.next);
              setState(() {});
            },
            child: Container(
              child: Image.asset(playerManager.playModeImage,width: 28,color: Colors.white70,),
            ),
          ),
          ClearInkWell(
            onTap: () {
              playerManager.skipToPrevious();
            },
            child: Image.asset(
                ImageHelper.wrapMusicPng(
                  'music_playing_prev',
                ),
                width: 28,
                color: Colors.white70),
          ),
          Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70, width: 1),
              ),
              child: StreamBuilder<PlayerState>(
                initialData: playerManager.playerState,
                stream: playerManager.onPlayerStateChanged,
                builder: (context, snapshot) {
                  var audioState = snapshot.data;

                  LogUtil.v('playerState => $audioState');
                  if (playerManager.isBuffering) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor(context),
                      ),
                    );
                  }
                  return ClearInkWell(
                    onTap: () {
                      if (audioState == PlayerState.PLAYING) {
                        playerManager.pause();
                      }
                      if (audioState == PlayerState.PAUSED) {
                        playerManager.resume();
                      }
                      if (audioState == PlayerState.STOPPED) {
                        playerManager.play();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: !playerManager.isPrepare
                          ? Image.asset(
                              ImageHelper.wrapMusicPng(
                                'music_playing_pause',
                              ),
                              width: 40,
                              color: Colors.white70)
                          : Image.asset(
                              ImageHelper.wrapMusicPng(
                                'music_playing_play',
                              ),
                              width: 40,
                              color: Colors.white70),
                    ),
                  );
                },
              )),
          ClearInkWell(
            onTap: () {
              playerManager.skipToNext();
            },
            child: Transform.rotate(
              angle: -math.pi,
              child: Image.asset(
                ImageHelper.wrapMusicPng(
                  'music_playing_prev',
                ),
                width: 28,
                color: Colors.white70,
              ),
            ),
          ),
          QYBounce(
            onPressed: () {
              LogUtil.v('点击更多');
            },
            child: Image.asset(
              ImageHelper.wrapMusicPng(
                'music_playing_src',
              ),
              color: Colors.white70,
              width: 28,
            ),
          ),
        ],
      ),
    );
  }
}
