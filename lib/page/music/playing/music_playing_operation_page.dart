import 'package:flutter/material.dart';
import 'package:flutter_app/page/music/playing/music_playing_bar.dart';
import 'package:flutter_app/page/music/playing/music_playing_center_section.dart';
import 'package:flutter_app/page/music/playing/music_playing_cover.dart';
import 'package:flutter_app/page/music/playing/music_playing_operation_bar.dart';
import 'package:flutter_app/page/music/playing/music_playing_progress_slider.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicPlayingOperationPage extends StatefulWidget {
  @override
  _MusicPlayingOperationPageState createState() =>
      _MusicPlayingOperationPageState();
}

class _MusicPlayingOperationPageState extends State<MusicPlayingOperationPage> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var playerManager = MusicPlayerManager.of(context);
    return Container(
      child: SafeArea(
        top: false,
        child: Column(
        children: [
          QYSpacing(height: 10,),
          Expanded(child: MusicPlayingCenterSection(),),
          MusicPlayingOperationBar(
            song: playerManager.currentSong,
          ),
          MusicPlayingProgressSlider(),
          MusicPlayingBar()
        ],
      ),
      )
    );
  }
}
