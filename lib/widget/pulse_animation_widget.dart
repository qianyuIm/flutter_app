import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/image_helper.dart';

class _DelayTween extends Tween<double> {
  final double delay;

  _DelayTween({
    required this.delay,
    double? begin,
    double? end,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class _Bar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  const _Bar({
    Key? key,
    required this.width,
    required this.height,
    this.color = Colors.white,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
            borderRadius: borderRadius,
          ),
        ));
  }
}

/// 脉冲动画
class PulseAnimationWidget extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;
  final Curve curve;
  final bool animation;
  final WidgetBuilder? unAnimationBuilder;

  const PulseAnimationWidget(
      {Key? key,
      this.width = 2.0,
      this.height = 15.0,
      this.animation = false,
      this.color = Colors.white,
      this.unAnimationBuilder,
      this.borderRadius = const BorderRadius.all(
          Radius.circular(2)),
      this.duration = const Duration(milliseconds: 800),
      this.curve = Curves.linear})
      : super(key: key);
  @override
  _PulseAnimationWidgetState createState() =>
      _PulseAnimationWidgetState();
}

class _PulseAnimationWidgetState
    extends State<PulseAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animation) _controller.repeat();
    super.initState();
  }

  @override
  void didUpdateWidget(PulseAnimationWidget oldWidget) {
    if (widget.animation) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation) {
      return _buildAnimation();
    }
    return _buildUnAnimation(context);
  }

  Widget _buildUnAnimation(BuildContext context) {
    if (widget.unAnimationBuilder != null) {
      return widget.unAnimationBuilder!(context);
    }
    return Container(
      child: Image.asset(
        ImageHelper.wrapMusicPng('music_playing_play'),
        color: widget.color,
        height: widget.height * 2,
      ),
    );
  }

  Widget _buildAnimation() {
    return Container(
      height: widget.height * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return ScaleTransition(
            scale: _DelayTween(begin: 1.0, end: 2.0, delay: index * .2).animate(
                CurvedAnimation(parent: _controller, curve: widget.curve)),
            child: _Bar(
              color: widget.color,
              width: widget.width,
              borderRadius: widget.borderRadius,
              height: widget.height,
            ),
          );
        }),
      ),
    );
  }
}
