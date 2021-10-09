import 'package:flutter/material.dart';

class ScrollControllerViewModel extends ChangeNotifier {
  final ScrollController? _scrollController;
  final double _triggerHeight;
  bool _trigger = false;

  ScrollControllerViewModel(this._scrollController, this._triggerHeight);
  ScrollController? get scrollController => _scrollController;

  bool get trigger => _trigger;

  init() {
    if (_scrollController == null) return;
    _scrollController!.addListener(() {
      // LogUtil.v('offset => ${_scrollController?.offset}');
      if (_scrollController!.offset > _triggerHeight && !_trigger) {
        _trigger = true;
        notifyListeners();
      } else if (_scrollController!.offset < _triggerHeight && _trigger) {
        _trigger = false;
        notifyListeners();
      }
    });
    // ignore: unused_element
    void scrollToTop() {
      _scrollController?.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
    }
  }
}
