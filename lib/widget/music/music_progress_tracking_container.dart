import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';

/// 监听音乐播放状态
class MusicProgressTrackingContainer extends StatefulWidget {
  final MusicPlayerManager manager;
  final MusicSong song;
  final WidgetBuilder builder;

  const MusicProgressTrackingContainer({
    Key? key,
    required this.manager,
    required this.song,
    required this.builder, 
   
  }) : super(key: key);
  @override
  _MusicProgressTrackingContainerState createState() =>
      _MusicProgressTrackingContainerState();
}

class _MusicProgressTrackingContainerState
    extends State<MusicProgressTrackingContainer> with SingleTickerProviderStateMixin {
  StreamSubscription<Duration>? _streamSubscription;
  late Ticker _ticker;
  @override
  void initState() {
    
    super.initState();
    _streamSubscription = widget.manager.onPlayerPositionChanged.listen((event) { 
      _onPositionChanged();
    });
    
  }
  void _onPositionChanged() {
    setState(() {});
  }
  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
