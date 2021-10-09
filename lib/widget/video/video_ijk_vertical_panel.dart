import 'dart:async';
import 'dart:math';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';

typedef FijkVerticalErrorCallback = void Function(FijkException exception);

FijkPanelWidgetBuilder fijkSinglePanelWidgetBuilder(
    {Key? key, final FijkVerticalErrorCallback? onErrorClick}) {
  return (FijkPlayer player, FijkData data, BuildContext context, Size viewSize,
      Rect texturePos) {
    return VideoFijkVerticalPanel(
      key: key,
      player: player,
      onErrorClick: onErrorClick,
    );
  };
}

class VideoFijkVerticalPanel extends StatefulWidget {
  final FijkPlayer player;
  final FijkVerticalErrorCallback? onErrorClick;

  const VideoFijkVerticalPanel(
      {Key? key, required this.player, this.onErrorClick})
      : super(key: key);

  @override
  _VideoFijkVerticalPanelState createState() => _VideoFijkVerticalPanelState();
}

class _VideoFijkVerticalPanelState extends State<VideoFijkVerticalPanel> {
  FijkPlayer get player => widget.player;

  Duration _duration = Duration();
  Duration _currentPos = Duration();
  Duration _bufferPos = Duration();

  bool _playing = false;
  bool _prepared = false;

  ///
  bool _buffering = false;
  String? _exception;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;

  StreamSubscription? _bufferPosSubs;
  StreamSubscription? _bufferingSubs;

  Timer? _hideTimer;
  // bool _hideStuff = true;
  // double _volume = 1.0;
  static const FijkSliderColors sliderColors = FijkSliderColors(
      cursorColor: Colors.transparent,
      playedColor: Color.fromARGB(200, 240, 90, 50),
      baselineColor: Color.fromARGB(100, 20, 20, 20),
      bufferedColor: Color.fromARGB(180, 200, 200, 200));

  @override
  void initState() {
    super.initState();

    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;
    _buffering = player.isBuffering;

    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        _currentPos = v;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });
    _bufferingSubs = player.onBufferStateUpdate.listen((v) {
      setState(() {
        _buffering = v;
      });
    });
  }

  void _playerValueChanged() {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }

    bool playing = (value.state == FijkState.started);
    bool prepared = value.prepared;
    String? exception = value.exception.message;
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
        _exception = exception;
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
    _hideTimer?.cancel();
    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
    _bufferingSubs?.cancel();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        // _hideStuff = true;
      });
    });
  }

  

  

  Widget _buildSlider(BuildContext context) {
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue =
        _seekPos > 0 ? _seekPos : _currentPos.inMilliseconds.toDouble();
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);
    return _duration.inMilliseconds == 0
        ? Center()
        : Padding(
            padding: EdgeInsets.only(right: 0, left: 0),
            child: FijkSlider(
              colors: sliderColors,
              value: currentValue,
              cacheValue: _bufferPos.inMilliseconds.toDouble(),
              min: 0.0,
              max: duration,
              onChanged: (v) {
                _startHideTimer();
                setState(() {
                  _seekPos = v;
                });
              },
              onChangeEnd: (v) {
                setState(() {
                  player.seekTo(v.toInt());
                  print("seek to $v");
                  _currentPos = Duration(milliseconds: _seekPos.toInt());
                  _seekPos = -1;
                });
              },
            ),
          );
  }

  Widget _buildPanel(BuildContext context) {
    return Container(
        // color: Colors.red.withAlpha(100),
        child: Stack(
          children: [
            _exception != null
                ? _buildError()
                : ((_prepared || player.state == FijkState.initialized) &&
                        !_buffering)
                    ? SizedBox.shrink()
                    : _buildLoading(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 8 + Inchs.bottomBarHeight,
                child: Stack(
                  children: [
                    _buildSlider(context),
                    Container(
                      height: Inchs.bottomBarHeight,
                      // color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildLoading() {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white)),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: InkWell(
        onTap: () {
          widget.onErrorClick?.call(player.value.exception);
        },
        child: Container(
          width: 200,
          height: 50,
          // color: Colors.yellow,
          child: Center(
            child: Text(
              '点击重试',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = Rect.fromLTWH(0, 0, Inchs.screenWidth, Inchs.screenHeight);
    return Positioned.fromRect(
      rect: rect,
      child: IgnorePointer(
          ignoring: _exception == null ? true : false,
          child: _buildPanel(context)),
    );
  }
}
