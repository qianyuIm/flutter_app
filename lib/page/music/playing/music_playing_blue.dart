import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'dart:ui' as ui;

class MusicPlayingBlue extends StatefulWidget {
  @override
  _MusicPlayingBlueState createState() => _MusicPlayingBlueState();
}

class _MusicPlayingBlueState extends State<MusicPlayingBlue> {
  StreamSubscription<MusicPlayerItem>? _subscription;

  @override
  void initState() {
    final manager = MusicPlayerManager.of(context);
    _subscription = manager.onPlayerItemChanged.listen((event) {
      LogUtil.v('我是我是');
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
    final manager = MusicPlayerManager.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
          manager.currentSong.album?.picUrl,
          80,
          80,
        )),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Opacity(
            opacity: 0.5,
            child: Container(
            color: Colors.black,
          ),
          )
        )
      ],
    );
  }
}
