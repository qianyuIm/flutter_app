import 'package:flutter/material.dart';
import 'package:rate_limiter/rate_limiter.dart';

/// form : https://github.com/ThomasEcalle/bouncing_widget
class QYBounce extends StatefulWidget {
  final Widget? child;

  /// 缩放时间
  final Duration duration;
  /// 防抖时间
  final Duration wait;

  /// 缩放系数 默认1.0(0.0 ~ 1.0 对应缩放比例为 1.0 ~ 0.9)
  final double scaleFactor;

  /// 是否吸收移动事件，用于滑动(:scrollview)控件中
  final bool absorbOnMove;

  /// 抓取的是动画结束的时间点
  final VoidCallback? onPressed;

  const QYBounce(
      {Key? key,
      this.child,
      this.duration = const Duration(milliseconds: 200),
      this.wait = const Duration(milliseconds: 600),
      this.scaleFactor = 0.5,
      this.absorbOnMove = false,
      this.onPressed})
      : super(key: key);
  @override
  _QYBounceState createState() => _QYBounceState();
}

class _QYBounceState extends State<QYBounce>
    with SingleTickerProviderStateMixin {
  //// Animation controller
  late AnimationController _controller;

  /// View scale used in order to make the bouncing animation
  late double _scale;

  /// Key of the given child used to get its size and position whenever we need
  GlobalKey _childKey = GlobalKey();

  /// If the touch position is outside or not of the given child
  bool _isOutside = false;

  Offset _previousPosition = Offset.zero;

  bool _isLongPress = true;

  /// Simple getter on widget's child
  Widget? get child => widget.child;

  /// Simple getter on widget's onPressed callback
  VoidCallback? get onPressed => widget.onPressed;

  /// Simple getter on widget's scaleFactor
  double get scaleFactor => widget.scaleFactor;

  /// Simple getter on widget's animation duration
  Duration get duration => widget.duration;

  
  late final Debounce debounceFunction;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    /// 防抖
    debounceFunction = debounce(() {
      _trigger();
    }, widget.wait, leading: true, trailing: false);
    super.initState();
  }

  /// Dispose the animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Each time the [_controller]'s value changes, build() will be called
  /// We just have to calculate the appropriate scale from the controller value
  /// and pass it to our Transform.scale widget
  @override
  Widget build(BuildContext context) {
    _scale = 1 - (_controller.value * scaleFactor);
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      onPointerMove: (moveEvent) => _onPointerMove(moveEvent, context),
      child: Transform.scale(
        key: _childKey,
        scale: _scale,
        child: child,
      ),
    );
  }

  /// 按下
  _onTapDown(PointerDownEvent downEvent) {
    _previousPosition = downEvent.position;
    _isLongPress = true;
    _controller.forward();
  }

  /// 移动
  _onPointerMove(PointerMoveEvent moveEvent, BuildContext context) {
    final Offset touchPosition = moveEvent.position;
    _isLongPress = _isLongPressChildBox(_previousPosition, touchPosition);

    _isOutside = _isOutsideChildBox(touchPosition);
  }

  /// 抬起
  _onTapUp(PointerUpEvent upEvent) {
    /// 点按的时候
    if (_controller.status != AnimationStatus.completed) {
      Future.delayed(duration, () {
        _reverseAnimation();
        _triggerOnPressed();
      });
    } else {
      /// 长按 or 移动
      _reverseAnimation();
      _triggerOnPressed(absorbMove: _isLongPress ? false : widget.absorbOnMove);
    }

    // _triggerOnPressed();
  }

  _reverseAnimation() {
    if (mounted) {
      _controller.reverse().then((value) => _isOutside = false);
    }
  }

  /// 触发回调
  void _triggerOnPressed({bool absorbMove = false}) {
    if (!_isOutside && !absorbMove) {
      Future.delayed(duration, () {
        debounceFunction();
      });
    }
  }

  /// 触发回调
  void _trigger() {
    onPressed?.call();
  }

  /// 判断是否为长按
  bool _isLongPressChildBox(Offset previousPosition, Offset touchPosition) {
    var x = (previousPosition.dx - touchPosition.dx).abs() < 2.0;
    var y = (previousPosition.dy - touchPosition.dy).abs() < 2.0;
    return x && y;
  }

  /// Method called when we need to now if a specific touch position is inside the given
  /// child render box
  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox? childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (childRenderBox == null) {
      return true;
    }
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return (touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height);
  }
}
