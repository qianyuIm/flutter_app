import 'dart:math';

import 'package:flutter/material.dart';

class ColorHelper {
  static const Color color_1 = Color.fromARGB(255, 21, 23, 35);
  static const Color color_2 = Color.fromARGB(150, 255, 255, 255);
  static const Color color_3 = Color.fromARGB(255, 254, 44, 85);
  static const Color color_4 = Color.fromARGB(255, 250, 206, 21);
  /// 播放页面 Colors.white70
  static const Color playingTitleColor = Colors.white70;
  /// 播放页面 Colors.black26
  static const Color playingCardColor = Colors.black26;

  /// 颜色字符串
  static String colorString(Color color) =>
      "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";

  /// 随机色
  static Color random() {
    final _random = Random();
    return Color.fromRGBO(_random.nextInt(256), _random.nextInt(256),
        _random.nextInt(256), _random.nextDouble());
  }
}
