import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:provider/provider.dart';

class MusicPlayingProgressSlider extends StatefulWidget {
  @override
  _MusicPlayingProgressSliderState createState() =>
      _MusicPlayingProgressSliderState();
}

class _MusicPlayingProgressSliderState
    extends State<MusicPlayingProgressSlider> {
  double progress = 0.0;
  bool startSlider = false;
  late MusicPlayerManager _playerManager;
  @override
  void initState() {
    _playerManager = MusicPlayerManager.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: Inchs.left, vertical: Inchs.sp10),
        child: StreamBuilder(
          stream: _playerManager.onPlayerPositionChanged,
          builder: (context, snapshot) {
            return Row(
              children: [
                _buildPosition(),
                QYSpacing(
                  width: 4,
                ),
                Expanded(
                  child: _buildProgress(),
                ),
                QYSpacing(
                  width: 4,
                ),
                _buildDuration()
              ],
            );
          },
        ));
  }

  Widget _buildPosition() {
    return Text(
      _playerManager.positionText,
      style: AppTheme.subtitleCopyStyle(context, color: Colors.white70),
    );
  }

  Widget _buildDuration() {
    return Text(
      _playerManager.durationText,
      style: AppTheme.subtitleCopyStyle(context, color: Colors.white70),
    );
  }

  Widget _buildProgress() {
    final primaryColor = Colors.white;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.24),
        trackHeight: 3,
        overlayColor: primaryColor.withOpacity(0.12),
        thumbColor: primaryColor,
        overlayShape: RoundSliderOverlayShape(
          //可继承SliderComponentShape自定义形状
          overlayRadius: 10, //滑块外圈大小
        ),
        thumbShape: RoundSliderThumbShape(
          //可继承SliderComponentShape自定义形状
          disabledThumbRadius: 5, //禁用是滑块大小
          enabledThumbRadius: 5, //滑块大小
        ),
      ),
      child: Slider(
        value: _playerManager.playProgress,
        onChangeStart: (value) {
          _playerManager.pause();
        },
        onChanged: (value) {
          _playerManager.seek(value);
        },
        onChangeEnd: (value) {
          _playerManager.resume();
        },
      ),
    );
  }
}
