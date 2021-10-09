import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

typedef FijkSinglePanelCallback = void Function(bool isStart);

FijkPanelWidgetBuilder fijkSinglePanelWidgetBuilder(
    {Key? key, final FijkSinglePanelCallback? onSingleClick}) {
  return (FijkPlayer player, FijkData data, BuildContext context, Size viewSize,
      Rect texturePos) {
    return VideoFijkSinglePanel(
        key: key,
        player: player,
        data: data,
        viewSize: viewSize,
        texturePos: texturePos,
        onSingleClick: onSingleClick,);
  };
}

class VideoFijkSinglePanel extends StatefulWidget {
  final FijkPlayer player;
  final FijkData data;
  final Size viewSize;
  final Rect texturePos;
  final FijkSinglePanelCallback? onSingleClick;

  const VideoFijkSinglePanel({
    Key? key,
    required this.player,
    required this.data,
    required this.viewSize,
    required this.texturePos,
    this.onSingleClick,
  }) : super(key: key);

  @override
  _VideoFijkSinglePanelState createState() => _VideoFijkSinglePanelState();
}

class _VideoFijkSinglePanelState extends State<VideoFijkSinglePanel> {
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
  bool _hideStuff = true;

  double _volume = 1.0;
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

  void _playOrPause() {
    if (_playing == true) {
      if (widget.onSingleClick != null) {
        widget.onSingleClick!.call(false);
      } else {
        player.pause();
      }
    } else {
      if (widget.onSingleClick != null) {
        widget.onSingleClick!.call(true);
      } else {
        player.start();
      }
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
        _hideStuff = true;
      });
    });
  }

  void _cancelAndRestartTimer() {
    if (_hideStuff == true) {
      _startHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  Widget _buildVolumeButton() {
    IconData iconData;
    if (_volume <= 0) {
      iconData = Icons.volume_off_rounded;
    } else {
      iconData = Icons.volume_up_outlined;
      
    }
    return IconButton(
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      onPressed: () {
        setState(() {
          _volume = _volume > 0 ? 0.0 : 1.0;
          player.setVolume(_volume);
        });
      },
    );
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
      color: Colors.transparent,
      child: _exception != null
          ? _buildError()
          : ((_prepared || player.state == FijkState.initialized) && !_buffering)
              ? _buildPlay()
              : _buildLoading(),
    );
  }

  Widget _buildPlay() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.7,
      duration: Duration(milliseconds: 400),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(),
            IconButton(
                iconSize: 70,
                icon: Icon(_playing ? Icons.pause_circle_filled_outlined : Icons.play_circle_filled_outlined,
                    color: Colors.white),
                padding: EdgeInsets.all(10),
                onPressed: _playOrPause),
            Positioned(
              right: 10,
              top: 10,
              child: _buildVolumeButton(),
            ),
          ],
        ),
      ),
    );
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
    return Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.error,
        size: 30,
        color: Color(0x99FFFFFF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height)
        : Rect.fromLTRB(
            max(0.0, widget.texturePos.left),
            max(0.0, widget.texturePos.top),
            min(widget.viewSize.width, widget.texturePos.right),
            min(widget.viewSize.height, widget.texturePos.bottom));
    return Positioned.fromRect(
      rect: rect,
      child: GestureDetector(
        onTap: _cancelAndRestartTimer,
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      _cancelAndRestartTimer();
                    },
                    child: _buildPanel(context)),
              ),
              // _buildBottomBar(context),
              Container(
                // color: Colors.red.withAlpha(80),
                height: 8,
                child: Stack(children: [
                  _buildSlider(context),
                  Container(color: Colors.transparent,),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
