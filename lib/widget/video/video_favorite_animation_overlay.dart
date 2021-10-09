import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// 视频手势封装
/// 单击：暂停
/// 双击：点赞，双击后再次单击也是增加点赞爱心
class VideoFavoriteAnimationOverlay extends StatefulWidget {
  const VideoFavoriteAnimationOverlay(
      {Key? key, required this.child, this.onDoubleTap, this.onSingleTap})
      : super(key: key);

  /// 双击触发点赞爱心
  final Function()? onDoubleTap;

  /// 单击 触发暂停 or 播放
  final Function()? onSingleTap;
  final Widget child;

  @override
  _VideoFavoriteAnimationOverlayState createState() =>
      _VideoFavoriteAnimationOverlayState();
}

class _VideoFavoriteAnimationOverlayState
    extends State<VideoFavoriteAnimationOverlay> {
  GlobalKey _key = GlobalKey();
  List<Offset> icons = [];
  /// 单击or双击
  Timer? timer;
  bool canDouble = false;
  bool justDouble = false;

  @override
  Widget build(BuildContext context) {
    var iconStack = Stack(
      children: icons
          .map((position) => VideoFavoriteAnimationIcon(
                // key: Key(position.toString()),
                position: position,
                size: 100,
                onAnimationComplete: () {
                  icons.remove(position);
                },
                // offset: position,
              ))
          .toList(),
    );
    return GestureDetector(
      key: _key,
      onTapDown: (detail) {
        setState(() {
          if (canDouble) {
            print('添加爱心，当前爱心数量:${icons.length}');
            icons.add(_convertPosition(detail.globalPosition));
            widget.onDoubleTap?.call();
            justDouble = true;
          } else {
            justDouble = false;
          }
        });
      },
      onTapUp: (detail) {
        timer?.cancel();
        var delay = canDouble ? 1200 : 600;
        timer = Timer(Duration(milliseconds: delay), () {
          canDouble = false;
          timer = null;
          if (!justDouble) {
            widget.onSingleTap?.call();
          }
        });
        canDouble = true;
      },
      
      child: Stack(
        children: [widget.child, iconStack],
      ),
    );
  }

  // 内部转换坐标点
  Offset _convertPosition(Offset p) {
    RenderBox getBox = _key.currentContext?.findRenderObject() as RenderBox;
    return getBox.globalToLocal(p);
  }
}

class VideoFavoriteAnimationIcon extends StatefulWidget {
  final Offset? position;
  final double size;
  final Function? onAnimationComplete;

  const VideoFavoriteAnimationIcon(
      {Key? key, this.position, required this.size, this.onAnimationComplete})
      : super(key: key);
  @override
  _VideoFavoriteAnimationIconState createState() =>
      _VideoFavoriteAnimationIconState();
}

class _VideoFavoriteAnimationIconState extends State<VideoFavoriteAnimationIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  double rotate = pi / 10.0 * (2 * Random().nextDouble() - 1);

  double appearDuration = 0.1;

  double dismissDuration = 0.8;
  @override
  void initState() {
    _animationController = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
     print("VideoFavoriteAnimationIcon==>>dispose");
    super.dispose();
  }

  //开始动画
  startAnimation() async {
    await _animationController.forward();
    widget.onAnimationComplete?.call();
  }

  double get value => _animationController.value;

  double get opacity {
    if (value < appearDuration) {
      return 0.9 / appearDuration * value;
    }
    if (value < dismissDuration) {
      return 0.9;
    }
    var res = 0.9 - (value - dismissDuration) / (1 - dismissDuration);
    return res < 0 ? 0 : res;
  }

  double get scale {
    if (value <= 0.5) {
      return 0.6 + value / 0.5 * 0.5;
    } else if (value <= 0.8) {
      return 1.1 * (1 / 1.1 + (1.1 - 1) / 1.1 * (value - 0.8) / 0.25);
    } else {
      return 1 + (value - 0.8) / 0.2 * 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Image.asset(
      'assets/images/music/video_favorite_icon.webp',
      width: widget.size,
      height: widget.size,
    );
    Widget content = ShaderMask(
      child: child,
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft.add(Alignment(0.5, 0.5)),
        colors: [
          Color(0xffEF6F6F),
          Color(0xffF03E3E),
        ],
      ).createShader(bounds),
    );

    Widget body = Transform.rotate(
      angle: rotate,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: scale,
          child: content,
        ),
      ),
    );
    return widget.position == null
        ? Container()
        : Positioned(
            left: widget.position!.dx - widget.size / 2,
            top: widget.position!.dy - widget.size,
            child: body,
          );
  }
}


class LikeIconWidget extends StatefulWidget {
  final Offset offset;
  final Function? onAnimationComplete;
  const LikeIconWidget({Key? key, required this.offset, this.onAnimationComplete}) : super(key: key);
  @override
  _LikeIconWidgetState createState() => _LikeIconWidgetState();
}

class _LikeIconWidgetState extends State<LikeIconWidget> with TickerProviderStateMixin {
  late AnimationController animationController;

  Path path = Path();
  Tangent? _tangent;
  late PathMetric _pathMetric;

  //开始动画
  startAnimation() async {
    await animationController.forward();
    widget.onAnimationComplete?.call();
  }
  @override
  void initState() {
    animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    
    initPath();
    startAnimation();
    super.initState();

  }

@override
  void dispose() {
    print("LikeIconState==>>dispose");
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: animationController,
        builder: buildContent,
      ),
    );


  }
Widget buildContent(BuildContext context, Widget? child) {
    _tangent = _pathMetric.getTangentForOffset(_pathMetric.length * animationController.value);
    double angle = _tangent!.angle;
    return Transform(
      transform: Matrix4.translationValues(
          _tangent!.position.dx, _tangent!.position.dy, 0.0)
        ..rotateZ(angle),
      child: Opacity(
        child: Image.asset(
          'assets/images/music/video_favorite_icon.webp',
          width: 50,
          height: 50,
        ),
        opacity: 1 - animationController.value,
      ),
    );
  }

  void initPath() {
    path.moveTo(widget.offset.dx, widget.offset.dy);
    Offset end =
        Offset(Random().nextDouble() * 400, Random().nextDouble() * 50);
    Offset ctrl1 = formatMiddlePoint();
    Offset ctrl2 = formatMiddlePoint();

    path.cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, end.dx, end.dy);

    PathMetrics pathMetrics = path.computeMetrics();
    _pathMetric = pathMetrics.first;
    _tangent = _pathMetric
        .getTangentForOffset(_pathMetric.length * animationController.value);
  }

  Offset formatMiddlePoint() {
    double x = (Random().nextDouble() * 600);
    double y = (Random().nextDouble() * 300 / 4);
    Offset pointF = Offset(x, y);
    return pointF;
  }



}