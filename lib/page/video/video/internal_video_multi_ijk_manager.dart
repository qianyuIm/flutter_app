import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';

class InternalVideoIJKMultiManager {
  Map<int, FijkPlayer> _multiManagers = {};
  bool _canPlay = true;
  FijkPlayer? _activeManager;

  int get length => _multiManagers.length;

  void remove(FijkPlayer manager, int key) {
    if (_activeManager == manager) {
      _activeManager = null;
    }
    manager.release();
    _multiManagers.remove(key);
  }

  /// 更新 用于下拉刷新使用
  update(FijkPlayer manager, int key) {
    _multiManagers[key] = manager;
  }

  // Future<void> clear() async {
  //   if (_activeManager != null) {
  //     await _activeManager?.pause();
  //     _activeManager?.release();
  //   }
  //   _activeManager = null;
  //   _multiManagers.forEach((key, value) async {
  //     await value.release();
  //   });
  //   _multiManagers.clear();
  // }

  Future<void> play(FijkPlayer manager) async {
    if (_activeManager != null && _activeManager?.isPlayable() == true) {
      await _activeManager?.pause();
    }
    if (_canPlay) {
      _activeManager = manager;
      _activeManager?.start();
      LogUtil.v('我要播放了');
    }
  }

  /// 针对外部控制
  void activePause() {
    _canPlay = false;
    LogUtil.v('暂停');
    managerPause();
  }

  void managerPause() {
    if (_activeManager != null && _activeManager?.isPlayable() == true) {
      _activeManager?.pause();
    }
  }

  /// 针对外部控制
  void activePlay() {
    _canPlay = true;
    LogUtil.v('激活播放');
    managerPlay();
  }

  void managerPlay() {
    if (_activeManager != null && _activeManager?.isPlayable() == true) {
      _activeManager?.start();
    }
  }
}
