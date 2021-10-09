import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'video_preload_controller.dart';
// for: https://github.com/mjl0602/flutter_tiktok

typedef LoadMoreVideo<D> = Future<List<VideoPreloadController<D>>?> Function(
  int index,
  List<VideoPreloadController<D>> list,
);

class VideoPreloadManager<D> extends ChangeNotifier {
  VideoPreloadManager(
      {this.loadMoreCount = 1, this.preloadCount = 2, this.disposeCount = 5});

  /// 到第几个触发预加载，例如：1:最后一个，2:倒数第二个
  final int loadMoreCount;

  /// 预加载多少个视频
  final int preloadCount;

  /// 超出多少个，就释放视频
  final int disposeCount;

  /// 提供视频的builder
  LoadMoreVideo<D>? _videoProvider;

  /// 标记是否已经开始加载更多，因为加载更多是个耗时任务
  bool _isLoadMore = false;
  bool get isLoadMore => _isLoadMore;

  /// 是否还有更多的数据
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// 视频列表
  List<VideoPreloadController<D>> _playerList = [];
  List<D> _playerDataList = [];

  /// 视频总数目
  int get videoCount => _playerList.length;
  List<D> get videos => _playerDataList;

  /// 目前的视频序号
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  VideoPreloadController<D> get currentPlayer =>
      _playerList[_currentIndex.value];

  /// 初始化
  init({
    int initialIndex = 0,
    required PageController pageController,
    required List<VideoPreloadController<D>> initialList,
    required LoadMoreVideo<D> videoProvider,
  }) async {
    _playerList.addAll(initialList);
    _playerDataList.addAll(initialList.map((e) => e.data).toList());
    _videoProvider = videoProvider;
    pageController.addListener(() {
      var p = pageController.page!;
      /// 只会在页面完全切换才会更改播放设置
      if (p % 1 == 0) {
        loadIndex(p ~/ 1);
      }
    });
    loadIndex(initialIndex, reload: true);
    notifyListeners();
  }

  /// 获取指定index的player
  VideoPreloadController<D>? playerOfIndex(int index) {
    if (index < 0 || index > _playerList.length - 1) {
      return null;
    }
    return _playerList[index];
  }

  _didUpdateValue() {
    notifyListeners();
  }

  /// 加载
  loadIndex(int target, {bool reload = false}) {
    if (!reload) {
      if (_currentIndex.value == target) return;
    }
    // LogUtil.v('加载->>$target');
    // 播放当前的，暂停其他的
    var oldIndex = _currentIndex.value;
    var newIndex = target;
    // 暂停之前的视频
    if (!(oldIndex == 0 && newIndex == 0)) {
      var oldPreloadController = playerOfIndex(oldIndex);
      // oldPreloadController?.playController.seekTo(0);
      oldPreloadController?.pause();
      // LogUtil.v('暂停$oldIndex');
    }
    // 开始播放当前的视频
    var newPreloadController = playerOfIndex(newIndex);
    newPreloadController?.playController.addListener(_didUpdateValue);
    newPreloadController?.showPauseIcon.addListener(_didUpdateValue);
    newPreloadController?.play();
    // LogUtil.v('播放$newIndex');
    // 处理预加载/释放内存
    for (var i = 0; i < _playerList.length; i++) {
      // 需要释放[disposeCount]之前的视频
      if (i < newIndex - disposeCount) {
        // LogUtil.v('释放$i');
        playerOfIndex(i)?.playController.removeListener(_didUpdateValue);
        playerOfIndex(i)?.showPauseIcon.removeListener(_didUpdateValue);
        playerOfIndex(i)?.dispose();
      } else {
        // 需要预加载
        if (i > newIndex && i <= newIndex + preloadCount) {
          LogUtil.v('预加载$i');
          playerOfIndex(i)?.init();
        }
      }
    }
    // 快到最底部，添加更多视频
    if (_playerList.length - newIndex <= loadMoreCount + 1 &&
        !_isLoadMore &&
        _hasMore) {
      _isLoadMore = true;
      _videoProvider?.call(newIndex, _playerList).then(
        (list) async {
          _isLoadMore = false;
          if (list != null) {
            _playerList.addAll(list);
            _playerDataList.addAll(list.map((e) => e.data).toList());
            notifyListeners();
          } else {
            // LogUtil.v('没有更多数据了');
            _hasMore = false;
            notifyListeners();
          }
        },
        onError: (_) {
          // LogUtil.v('加载失败处理');
          _isLoadMore = false;
          notifyListeners();
        },
      );
    }
    // 完成
    _currentIndex.value = target;
  }

  @override
  void dispose() {
    // 销毁全部
    for (var player in _playerList) {
      player.showPauseIcon.dispose();
      player.dispose();
    }
    _playerList = [];
    _playerDataList = [];
    super.dispose();
  }
}
