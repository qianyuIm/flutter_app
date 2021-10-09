import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Inchs {
  /// 导航条高度 56
  static const double navigation_height = kToolbarHeight;
  /// tabbar 高度 56
  static const double tabbar_height = kBottomNavigationBarHeight;
  /// left 16 adapter
  static double get left => 16.0;
  /// right 16 adapter
  static double get right => 16.0;
  /// 10 间距
  static double get sp10 => adapter(10);
  /// 8 间距
  static double get sp8 => adapter(8);
  /// 6 间距
  static double get sp6 => adapter(6);
  /// 4 间距
  static double get sp4 => adapter(4);

  /// 屏幕宽度
  static double get screenWidth => ScreenUtil().screenWidth;
  /// 屏幕高度
  static double get screenHeight => ScreenUtil().screenHeight;
  /// 状态栏高度 dp 刘海屏会更高
  static double get statusBarHeight => ScreenUtil().statusBarHeight;
/// 状态栏diff高度 dp 刘海屏会更高
  static double get statusBarDiffHeight => statusBarHeight - 20;
  /// 底部安全区距离 
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;
  
  /// flutter_screenutil 适配 
  static double adapter(double dessignValue) => ScreenUtil().setWidth(dessignValue).truncateToDouble();
}