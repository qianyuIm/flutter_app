import 'package:flutter/material.dart';

class BottomClipper extends CustomClipper<Path> {
  final double height;

  BottomClipper(this.height);

  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - height);

    var p1 = Offset(size.width / 2, size.height);
    var p2 = Offset(size.width, size.height - height);
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.lineTo(size.width, size.height - height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
