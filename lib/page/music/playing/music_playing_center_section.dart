import 'package:flutter/material.dart';
import 'package:flutter_app/page/music/playing/music_playing_cover.dart';
import 'package:flutter_app/page/music/playing/music_playing_lyric.dart';

class MusicPlayingCenterSection extends StatefulWidget {
  @override
  _MusicPlayingCenterSectionState createState() => _MusicPlayingCenterSectionState();
}

class _MusicPlayingCenterSectionState extends State<MusicPlayingCenterSection> {
  static bool _showLyric = false;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:  _showLyric ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
         return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Center(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Center(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
      },
      firstChild: GestureDetector(
        onTap: () {
           setState(() {
              _showLyric = !_showLyric;
            });
        },
        child: MusicPlayingCover(),
      ),secondChild: MusicPlayingLyric(
        onTap: () {
          setState(() {
              _showLyric = !_showLyric;
            });
        },
      ),
    );
  }
}