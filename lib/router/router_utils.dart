import 'package:flutter/material.dart';

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;
  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}

//左--->右
class Left2RightRouter extends PageRouteBuilder {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Left2RightRouter(this.child,
      {this.durationMs = 500, this.curve = Curves.fastOutSlowIn})
      : super(
          transitionDuration: Duration(milliseconds: durationMs),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                  .animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
        );
}

//右--->左  普通状态
class Right2LeftRouter extends PageRouteBuilder {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Right2LeftRouter(this.child,
      {this.durationMs = 500, this.curve = Curves.fastOutSlowIn})
      : super(
          transitionDuration: Duration(milliseconds: durationMs),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                  .animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );
          },
        );
}

//上--->下
class Top2BottomRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Top2BottomRouter(
      {required this.child,
      this.durationMs = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (ctx, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              ctx,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, -1.0),
                    end: Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });
}

//下--->上
class Bottom2TopRouter<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;
  final Curve curve;
  Bottom2TopRouter(
      {required this.child,
      this.durationMs = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationMs),
            pageBuilder: (ctx, a1, a2) => child,
            transitionsBuilder: (
              ctx,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 1.0),
                    end: Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });
}
