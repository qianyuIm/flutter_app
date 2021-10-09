import 'package:flutter/material.dart';

class ScrollDetectManager<T> extends ChangeNotifier {
  T? _data;
  int _playIndex = -1;
  
  T? get data => _data;
  int get playIndex => _playIndex;

  void update(int playIndex, T? data) {
    _playIndex = playIndex;
    _data = data;
    notifyListeners();
  }
  
}