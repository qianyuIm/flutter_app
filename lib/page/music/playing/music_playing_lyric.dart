import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/music/music_lyric.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/music/music_progress_tracking_container.dart';
import 'dart:ui' as ui;

const _kEnablePaintDebug = false;

class MusicPlayingLyric extends StatelessWidget {
  final VoidCallback? onTap;

  const MusicPlayingLyric({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var playerManager = MusicPlayerManager.of(context);

    if (playerManager.hasLyric) {
      return MusicProgressTrackingContainer(
        manager: playerManager,
        song: playerManager.currentSong,
        builder: (context) {
          return _buildLyric(context, playerManager);
        },
      );
    } else {
      return Center(
        child: Text(
          playerManager.lyricMessage,
          style: AppTheme.titleCopyStyle(context,
              color: AppTheme.primaryColor(context)),
        ),
      );
    }
  }

  Widget _buildLyric(BuildContext context, MusicPlayerManager playerManager) {
    if (playerManager.hasLyric) {
      return LayoutBuilder(
        builder: (context, constraints) {
          var normalColor = Colors.white70;
          LogUtil.v('我来了');
          return ShaderMask(
            shaderCallback: (rect) {
              return ui.Gradient.linear(Offset(rect.width / 2, 0),
                  Offset(rect.width / 2, constraints.maxHeight), [
                const Color(0x00FFFFFF),
                normalColor,
                normalColor,
                const Color(0x00FFFFFF),
              ], [
                0.0,
                0.15,
                0.85,
                1
              ]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _Lyric(
                lyric: playerManager.lyric!,
                lyricLineStyle: AppTheme.subtitleCopyStyle(context,
                    color: Colors.white70, height: 2, fontSize: 16),
                highlight: AppTheme.primaryColor(context),
                position: playerManager.position.inMilliseconds,
                size: Size(
                    constraints.maxWidth,
                    constraints.maxHeight == double.infinity
                        ? 0
                        : constraints.maxHeight),
                playing: playerManager.isPlaying,
                onTap: onTap,
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          playerManager.lyricMessage,
          style: AppTheme.titleCopyStyle(context,
              color: AppTheme.primaryColor(context)),
        ),
      );
    }
  }
}

class _Lyric extends StatefulWidget {
  _Lyric({
    required this.lyric,
    this.lyricLineStyle,
    this.position,
    this.textAlign = TextAlign.center,
    this.highlight = Colors.red,
    required this.size,
    this.onTap,
    required this.playing,
  }) : assert(lyric.size > 0);

  final TextStyle? lyricLineStyle;

  final MusicLyricContent lyric;

  final TextAlign textAlign;

  final int? position;

  final Color? highlight;

  final Size size;

  final VoidCallback? onTap;

  /// player is playing
  final bool playing;
  @override
  _LyricState createState() => _LyricState();
}

class _LyricState extends State<_Lyric> with TickerProviderStateMixin {
  LyricPainter? lyricPainter;

  AnimationController? _flingController;

  AnimationController? _lineController;

  //歌词色彩渐变动画
  AnimationController? _gradientController;
  bool dragging = false;

  bool _consumeTap = false;

  @override
  void initState() {
    super.initState();
    lyricPainter = LyricPainter(
      widget.lyricLineStyle!,
      widget.lyric,
      textAlign: widget.textAlign,
      highlight: widget.highlight,
    );
    _scrollToCurrentPosition(widget.position);
  }

  @override
  void didUpdateWidget(_Lyric oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lyric != oldWidget.lyric) {
      lyricPainter = LyricPainter(
        widget.lyricLineStyle!,
        widget.lyric,
        textAlign: widget.textAlign,
        highlight: widget.highlight,
      );
    }
    if (widget.position != oldWidget.position) {
      _scrollToCurrentPosition(widget.position);
    }

    if (widget.playing != oldWidget.playing) {
      if (!widget.playing) {
        _gradientController?.stop();
      } else {
        _gradientController?.forward();
      }
    }
  }

  /// scroll lyric to current playing position
  void _scrollToCurrentPosition(int? milliseconds, {bool animate = true}) {
    if (lyricPainter!.height == -1) {
      WidgetsBinding.instance!.addPostFrameCallback((d) {
        if (mounted) _scrollToCurrentPosition(milliseconds, animate: false);
      });
      return;
    }

    final int line = widget.lyric
        .findLineByTimeStamp(milliseconds!, lyricPainter!.currentLine);

    if (lyricPainter!.currentLine != line && !dragging) {
      final double offset = lyricPainter!.computeScrollTo(line);

      if (animate) {
        _lineController?.dispose();
        _lineController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
        )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _lineController!.dispose();
              _lineController = null;
            }
          });
        final Animation<double> animation = Tween<double>(
                begin: lyricPainter!.offsetScroll,
                end: lyricPainter!.offsetScroll + offset)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(_lineController!);
        animation.addListener(() {
          lyricPainter!.offsetScroll = animation.value;
        });
        _lineController!.forward();
      } else {
        lyricPainter!.offsetScroll += offset;
      }

      _gradientController?.dispose();
      final entry = widget.lyric[line];
      final startPercent = (milliseconds - entry.position) / entry.duration;
      _gradientController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (entry.duration * (1 - startPercent)).toInt()),
      );
      _gradientController!.addListener(() {
        lyricPainter!.lineGradientPercent = _gradientController!.value;
      });
      if (widget.playing) {
        _gradientController!.forward(from: startPercent);
      } else {
        _gradientController!.value = startPercent;
      }
    }
    lyricPainter!.currentLine = line;
  }

  @override
  void dispose() {
    _flingController?.dispose();
    _flingController = null;
    _lineController?.dispose();
    _lineController = null;
    _gradientController?.dispose();
    _gradientController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300, minHeight: 120),
      child: GestureDetector(
        onTap: () {
          if (!_consumeTap && widget.onTap != null) {
            widget.onTap!();
          } else {
            _consumeTap = false;
          }
        },
        onTapDown: (details) {
          if (dragging) {
            _consumeTap = true;
            dragging = false;
            _flingController?.dispose();
            _flingController = null;
          }
        },
        onVerticalDragStart: (details) {
          dragging = true;
          _flingController?.dispose();
          _flingController = null;
        },
        onVerticalDragUpdate: (details) {
          lyricPainter!.offsetScroll += details.primaryDelta!;
        },
        onVerticalDragEnd: (details) {
          _flingController = AnimationController.unbounded(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )
            ..addListener(() {
              double value = _flingController!.value;

              if (value < -lyricPainter!.height || value >= 0) {
                _flingController!.dispose();
                _flingController = null;
                dragging = false;
                value = value.clamp(-lyricPainter!.height, 0.0);
              }
              lyricPainter!.offsetScroll = value;
              lyricPainter!.repaint();
            })
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                dragging = false;
                _flingController?.dispose();
                _flingController = null;
              }
            })
            ..animateWith(ClampingScrollSimulation(
                position: lyricPainter!.offsetScroll,
                velocity: details.primaryVelocity!));
        },
        child: CustomPaint(
          size: widget.size,
          painter: lyricPainter,
        ),
      ),
    );
  }
}

class LyricPainter extends ChangeNotifier implements CustomPainter {
  ///param lyric must not be null
  LyricPainter(TextStyle style, this.lyric,
      {this.textAlign = TextAlign.center, Color? highlight = Colors.red}) {
    lyricPainters = [];
    for (int i = 0; i < lyric.size; i++) {
      final painter = TextPainter(
          text: TextSpan(style: style, text: lyric[i].line),
          textAlign: textAlign);
      painter.textDirection = TextDirection.ltr;
//      painter.layout();//layout first, to get the height
      lyricPainters.add(painter);
    }
    _styleHighlight = style.copyWith(color: highlight);
  }

  MusicLyricContent lyric;
  late List<TextPainter> lyricPainters;

  final TextPainter _highlightPainter =
      TextPainter(textDirection: TextDirection.ltr);

  double _offsetScroll = 0;

  double get offsetScroll => _offsetScroll;

  double _lineGradientPercent = -1;

  double get lineGradientPercent {
    if (_lineGradientPercent == -1) return 1.0;
    return _lineGradientPercent.clamp(0.0, 1.0);
  }

  ///音乐播放时间,毫秒
  set lineGradientPercent(double percent) {
    _lineGradientPercent = percent;
    repaint();
  }

  set offsetScroll(double value) {
    if (height == -1) {
      // do not change offset when height is not available.
      return;
    }
    _offsetScroll = value.clamp(-height, 0.0);
    repaint();
  }

  int currentLine = 0;

  TextAlign textAlign;

  TextStyle? _styleHighlight;

  void repaint() {
    notifyListeners();
  }

  double get height => _height;
  double _height = -1;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    _layoutPainterList(size);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    //当offsetScroll为0时,第一行绘制在正中央
    double dy = offsetScroll + size.height / 2 - lyricPainters[0].height / 2;

    for (int line = 0; line < lyricPainters.length; line++) {
      final TextPainter painter = lyricPainters[line];

      if (line == currentLine) {
        _paintCurrentLine(canvas, painter, dy, size);
      } else {
        drawLine(canvas, painter, dy, size);
      }
      dy += painter.height;
    }
  }

  //绘制当前播放中的歌词
  void _paintCurrentLine(
      ui.Canvas canvas, TextPainter painter, double dy, ui.Size size) {
    if (dy > size.height || dy < 0 - painter.height) {
      return;
    }

    //for current highlight line, draw background text first
    drawLine(canvas, painter, dy, size);

    _highlightPainter
      ..text = TextSpan(
          text: (painter.text as TextSpan?)?.text, style: _styleHighlight)
      ..textAlign = textAlign;

    _highlightPainter.layout(); //layout with unbound width

    double lineWidth = _highlightPainter.width;
    double gradientWidth = _highlightPainter.width * lineGradientPercent;
    final double lineHeight = _highlightPainter.height;

    _highlightPainter.layout(maxWidth: size.width);

    final highlightRegion = Path();
    double lineDy = 0;
    while (gradientWidth > 0) {
      double dx = 0;
      if (lineWidth < size.width) {
        dx = (size.width - lineWidth) / 2;
      }
      highlightRegion.addRect(
          Rect.fromLTWH(0, dy + lineDy, dx + gradientWidth, lineHeight));
      lineWidth -= _highlightPainter.width;
      gradientWidth -= _highlightPainter.width;
      lineDy += lineHeight;
    }

    canvas.save();
    canvas.clipPath(highlightRegion);

    drawLine(canvas, _highlightPainter, dy, size);
    canvas.restore();

    assert(() {
      if (_kEnablePaintDebug) {
        final painter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawPath(highlightRegion, painter);
      }
      return true;
    }());
  }

  ///draw a lyric line
  void drawLine(
      ui.Canvas canvas, TextPainter painter, double dy, ui.Size size) {
    if (dy > size.height || dy < 0 - painter.height) {
      return;
    }
    canvas.save();
    canvas.translate(_calculateAlignOffset(painter, size), dy);

    painter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  double _calculateAlignOffset(TextPainter painter, ui.Size size) {
    if (textAlign == TextAlign.center) {
      return (size.width - painter.width) / 2;
    }
    return 0;
  }

  @override
  bool shouldRepaint(LyricPainter oldDelegate) {
    return true;
  }

  void _layoutPainterList(ui.Size size) {
    _height = 0;
    for (final p in lyricPainters) {
      p.layout(maxWidth: size.width);
      _height += p.height;
    }
  }

  //compute the offset current offset to destination line
  double computeScrollTo(int destination) {
    if (lyricPainters.isEmpty || this.height == 0) {
      return 0;
    }

    double height = -lyricPainters[0].height / 2;
    for (int i = 0; i < lyricPainters.length; i++) {
      if (i == destination) {
        height += lyricPainters[i].height / 2;
        break;
      }
      height += lyricPainters[i].height;
    }
    return -(height + offsetScroll);
  }

  @override
  bool? hitTest(ui.Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) =>
      shouldRepaint(oldDelegate as LyricPainter);
}
