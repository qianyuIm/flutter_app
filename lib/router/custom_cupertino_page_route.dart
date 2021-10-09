import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// from: https://juejin.cn/post/6844903901980786696#heading-2
///
enum CustomCupertinoTransitionType {
  /// right -> left
  cupertino,

  /// bottom -> top
  cupertinoFullscreenDialog,

  /// left -> right
  fromLeft,

  /// top -> bottom
  fromTop,

  /// fade
  fade,

  /// none 动画时长不能 设置为 zero 可以小点
  none
}

extension CustomCupertinoTransitionTypeGet on CustomCupertinoTransitionType {
  bool get isFade {
    if (this == CustomCupertinoTransitionType.fade) {
      return true;
    }
    return false;
  }
}

class CustomCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  /// pushType 和  gestureType 必须为同一组件 才能交互  否则冲突
  ///
  ///
  CustomCupertinoPageRoute({
    required WidgetBuilder builder,
    this.pushType = CustomCupertinoTransitionType.cupertino,
    this.popType = CustomCupertinoTransitionType.cupertino,
    this.gestureType = CustomCupertinoTransitionType.cupertino,
    this.duration = const Duration(milliseconds: 330),
    String? title,
    RouteSettings? settings,
    bool maintainState = true,
  })  : this.pushPopOrGestureFade = ((pushType.isFade && !gestureType.isFade) ||
            (!pushType.isFade && gestureType.isFade) || (popType.isFade && !gestureType.isFade) || (!popType.isFade && gestureType.isFade)),
        super(
            builder: builder,
            title: title,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: false);

  /// 动画时长
  final Duration duration;

  /// push pop 或者 手势为 fade
  final bool pushPopOrGestureFade;

  /// push 动画
  final CustomCupertinoTransitionType pushType;

  /// pop 动画
  final CustomCupertinoTransitionType popType;

  /// 手势 动画
  final CustomCupertinoTransitionType gestureType;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return false;
  }

  /// push 动画时长
  @override
  Duration get transitionDuration =>
      (pushType == CustomCupertinoTransitionType.none)
          ? Duration(milliseconds: 50)
          : duration;

  /// pop 动画时长
  @override
  Duration get reverseTransitionDuration =>
      (popType == CustomCupertinoTransitionType.none)
          ? Duration(milliseconds: 50)
          : duration;
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions(
        this, context, animation, secondaryAnimation, child);
  }

  Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final bool linearTransition = isPopGestureInProgress(route);
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      pushType: pushType,
      popType: popType,
      gestureType: gestureType,
      pushPopOrGestureFade: pushPopOrGestureFade,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: linearTransition,
      child: _CupertinoBackGestureDetector<T>(
        enabledCallback: () => _isPopGestureEnabled<T>(route),
        onStartPopGesture: () => _startPopGesture<T>(route),
        child: child,
      ),
    );
  }

  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  static _CupertinoBackGestureController<T> _startPopGesture<T>(
      PageRoute<T> route) {
    assert(_isPopGestureEnabled(route));
    // route.controller?.reverse();
    return _CupertinoBackGestureController<T>(
      navigator: route.navigator!,
      controller: route.controller!, // protected access
    );
  }

  static bool _isPopGestureEnabled<T>(PageRoute<T> route) {
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst) return false;
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes), so disallow it.
    if (route.willHandlePopInternally) return false;
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    if (route.hasScopedWillPopCallback) return false;
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) return false;
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation!.status != AnimationStatus.completed) return false;
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed)
      return false;
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress(route)) return false;

    // Looks like a back gesture would be welcome!
    return true;
  }
}

// 没有动画
final Animatable<Offset> _kNone = Tween<Offset>(
  begin: Offset.zero,
  end: Offset.zero,
);

///  left -> right
final Animatable<Offset> _kLeft2Right =
    Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0));

/// right -> left  cupertino
final Animatable<Offset> _kRight2Left = Tween<Offset>(
  begin: const Offset(1.0, 0.0),
  end: Offset.zero,
);

/// top -> bottom
final Animatable<Offset> _kTop2Bottom =
    Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero);

///  bottom -> top cupertinoFullscreenDialog
final Animatable<Offset> _kBottom2Top =
    Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero);

// Offset from fully on screen to 1/3 offscreen to the left.
final Animatable<Offset> _kMiddleLeftTween = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(-1.0 / 3.0, 0.0),
);

class CupertinoPageTransition extends StatefulWidget {
  final Animation<double> primaryRouteAnimation;

  /// push pop 或者 手势为 fade
  final bool pushPopOrGestureFade;

  /// push 动画
  final CustomCupertinoTransitionType pushType;

  /// pop 动画
  final CustomCupertinoTransitionType popType;

  /// 手势 动画
  final CustomCupertinoTransitionType gestureType;
  final bool linearTransition;

  CupertinoPageTransition({
    Key? key,
    required this.primaryRouteAnimation,
    required this.pushType,
    required this.popType,
    required this.gestureType,
    required this.pushPopOrGestureFade,
    required Animation<double> secondaryRouteAnimation,
    required this.child,
    required this.linearTransition,
  })  : _primaryPositionAnimationPop = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_offset(popType)),
        _secondaryPositionAnimation = (linearTransition
                ? secondaryRouteAnimation
                : CurvedAnimation(
                    parent: secondaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_kMiddleLeftTween),
        _primaryPositionAnimationPush = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_offset(pushType)),
        _primaryPositionAnimationGesture = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(_offset(gestureType)),
        _primaryPositionAnimationFade = (linearTransition
                ? primaryRouteAnimation
                : CurvedAnimation(
                    parent: primaryRouteAnimation,
                    curve: Curves.linearToEaseOut,
                    reverseCurve: Curves.easeInToLinear,
                  ))
            .drive(Tween<double>(
          begin: 0.0,
          end: 1.0,
        )),
        _primaryPositionAnimationDefaultFade = CurvedAnimation(
          parent: primaryRouteAnimation,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInToLinear,
        ).drive(Tween<double>(
          begin: 1.0,
          end: 1.0,
        )),
        super(key: key);

  final Animation<Offset> _primaryPositionAnimationPush;
  final Animation<double> _primaryPositionAnimationFade;
  final Animation<double> _primaryPositionAnimationDefaultFade;

  final Animation<Offset> _primaryPositionAnimationPop;
  final Animation<Offset> _primaryPositionAnimationGesture;

  final Animation<Offset> _secondaryPositionAnimation;

  /// The widget below this widget in the tree.
  final Widget child;

  static Animatable<Offset> _offset(CustomCupertinoTransitionType type) {
    if (type == CustomCupertinoTransitionType.cupertino) {
      return _kRight2Left;
    } else if (type ==
        CustomCupertinoTransitionType.cupertinoFullscreenDialog) {
      return _kBottom2Top;
    } else if (type == CustomCupertinoTransitionType.fromLeft) {
      return _kLeft2Right;
    } else if (type == CustomCupertinoTransitionType.fromTop) {
      return _kTop2Bottom;
    } else if (type == CustomCupertinoTransitionType.fromTop) {
      return _kTop2Bottom;
    }
    return _kNone;
  }

  @override
  _CupertinoPageTransitionState createState() =>
      _CupertinoPageTransitionState();
}

class _CupertinoPageTransitionState extends State<CupertinoPageTransition> {
  bool isPush = true;
  @override
  void initState() {
    super.initState();

    widget.primaryRouteAnimation
        .addStatusListener(_primaryRouteAnimationStatusListener);
  }

  @override
  void dispose() {
    // LogUtil.v('CupertinoPageTransition => 移除了');
    widget.primaryRouteAnimation
        .removeStatusListener(_primaryRouteAnimationStatusListener);

    super.dispose();
  }

  void _primaryRouteAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      /// 两种方式  后续看哪种好吧
      ///  第一种 在 addPostFrameCallback 内改变
      // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      //   isPush = false;
      //   LogUtil.v('push结束');
      // });
      isPush = false;

      /// 第二种
      setState(() {});
    } else if (status == AnimationStatus.dismissed) {
      // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      //   isPush = true;
      //   LogUtil.v('push开始');
      // });
      isPush = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    final TextDirection textDirection = Directionality.of(context);
    return SlideTransition(
        position: widget._secondaryPositionAnimation,
        textDirection: textDirection,
        transformHitTests: false,
        child: judgeChild(
            widget.pushPopOrGestureFade, widget.linearTransition, textDirection));
  }

  Widget? judgeChild(bool pushPopOrGestureFade, bool linearTransition,
      TextDirection textDirection) {
    /// push 判定
    if (isPush) {
      // LogUtil.v('我是Push');
      return judgeFadeOrOffsetChild(
          widget.pushType, textDirection, linearTransition, pushPopOrGestureFade);
    } else if (linearTransition) {
      // LogUtil.v('我是手势');
      return judgeFadeOrOffsetChild(widget.gestureType, textDirection,
          linearTransition, pushPopOrGestureFade);
    } else {
      // LogUtil.v('我是Pop');
      return judgeFadeOrOffsetChild(
          widget.popType, textDirection, linearTransition, pushPopOrGestureFade);
    }
  }

  Widget? judgeFadeOrOffsetChild(
      CustomCupertinoTransitionType type,
      TextDirection textDirection,
      bool linearTransition,
      bool pushPopOrGestureFade) {
    if (pushPopOrGestureFade) {
      // LogUtil.v('111111111111');
      return FadeTransition(
          opacity: type.isFade
              ? widget._primaryPositionAnimationFade
              : widget._primaryPositionAnimationDefaultFade,
          child: SlideTransition(
              position: judgePosition(linearTransition),
              textDirection: textDirection,
              child: widget.child));
    } else {
      // LogUtil.v('22222222222');
      if (type.isFade) {
        return FadeTransition(
          opacity: widget._primaryPositionAnimationFade,
          child: widget.child,
        );
      } else {
        return SlideTransition(
            position: judgePosition(linearTransition),
            textDirection: textDirection,
            child: widget.child);
      }
    }
  }

  Animation<Offset> judgePosition(bool linearTransition) {
    if (isPush) {
      return widget._primaryPositionAnimationPush;
    } else if (linearTransition) {
      return widget._primaryPositionAnimationGesture;
    } else {
      return widget._primaryPositionAnimationPop;
    }
  }
}

class _CupertinoBackGestureDetector<T> extends StatefulWidget {
  const _CupertinoBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  }) : super(key: key);

  final Widget child;

  final ValueGetter<bool> enabledCallback;

  final ValueGetter<_CupertinoBackGestureController<T>> onStartPopGesture;

  @override
  _CupertinoBackGestureDetectorState<T> createState() =>
      _CupertinoBackGestureDetectorState<T>();
}

const double _kBackGestureWidth = 40.0;

class _CupertinoBackGestureDetectorState<T>
    extends State<_CupertinoBackGestureDetector<T>> {
  _CupertinoBackGestureController<T>? _backGestureController;

  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with the "down" event
    // that we don't consider here.
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    double dragAreaWidth = Directionality.of(context) == TextDirection.ltr
        ? MediaQuery.of(context).padding.left
        : MediaQuery.of(context).padding.right;
    dragAreaWidth = max(dragAreaWidth, _kBackGestureWidth);
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          width: dragAreaWidth,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

const double _kMinFlingVelocity = 1.0; // Screen widths per second.
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.
const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

class _CupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  _CupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  /// The drag gesture has changed by [fractionalDelta]. The total range of the
  /// drag should be 0.0 to 1.0.
  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of
  /// [fractionalVelocity] as a fraction of screen width per second.
  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    if (velocity.abs() >= _kMinFlingVelocity)
      animateForward = velocity <= 0;
    else
      animateForward = controller.value > 0.5;

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(
                _kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the target destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final int droppedPageBackAnimationTime = lerpDouble(
                0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!
            .floor();
        controller.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
