import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/widget/image_load_view.dart';

class MusicPlayingCover extends StatefulWidget {
  @override
  _MusicPlayingCoverState createState() => _MusicPlayingCoverState();
}

class _MusicPlayingCoverState extends State<MusicPlayingCover> {
  StreamSubscription<MusicPlayerItem>? _subscription;
  @override
  void initState() {
    final manager = MusicPlayerManager.of(context);
    _subscription = manager.onPlayerItemChanged.listen((event) {
      LogUtil.v('改变');
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var song = MusicPlayerManager.of(context).currentSong;
    return Container(
      child: Center(
          child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
        child: ImageLoadView(
          key: ValueKey(song.id),
          imagePath:
              ImageCompressHelper.musicCompress(song.album?.picUrl, 100, 100),
          width: Inchs.adapter(230),
          height: Inchs.adapter(230),
          radius: 10,
        ),
      )),
    );
  }
}
