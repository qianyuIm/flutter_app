
import 'package:flutter/material.dart';


class ClearInkWell extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Widget? child;
  const ClearInkWell({Key? key, this.onTap, this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      radius: 0,
      onTap: onTap,
      child: child,
    );
  }
}