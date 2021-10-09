import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

typedef ControllerSetter<T> = Future<void> Function(T controller);
typedef DataSetter<D> = Future<String> Function(D data);
typedef ControllerBuilder<T, D> = T? Function(D data);

abstract class VideoPreloadAbstractController<T, D> {
  /// 获取当前的控制器实例
  T get playController;

  /// 是否显示暂停按钮
  ValueNotifier<bool> get showPauseIcon;

  /// 加载视频，在init后，应当开始下载视频内容
  Future<void> init({DataSetter<D> beforeInit, ControllerSetter<T>? afterInit});

  /// 视频销毁，在dispose后，应当释放任何内存资源
  Future<void> dispose();

  /// 播放
  Future<void> play();

  /// 暂停
  Future<void> pause({bool showPauseIcon: false});
}

class VideoPreloadController<D>
    extends VideoPreloadAbstractController<FijkPlayer, D> {
  final D data;
  final int index;
  final DataSetter<D> beforeInit;
  final ControllerBuilder<FijkPlayer, D> builder;
  final ControllerSetter<FijkPlayer>? afterInit;

  VideoPreloadController(
      {required this.data,
      required this.index,
      required this.beforeInit,
      required this.builder,
      this.afterInit});

  ValueNotifier<bool> _showPauseIcon = ValueNotifier<bool>(false);

  FijkPlayer? _controller;

  /// 阻止在init的时候dispose，或者在dispose前init
  List<Future> _actLocks = [];
  bool get isDispose => _disposeLock != null;
  bool get prepared => _prepared;
  bool _prepared = false;

  Completer<void>? _disposeLock;

  @override
  FijkPlayer get playController {
    if (_controller == null) {
      _controller = builder.call(this.data);
    }
    return _controller!;
  }

  @override
  Future<void> dispose() async {
    if (!prepared) return;
    await Future.wait(_actLocks);
    _actLocks.clear();
    var completer = Completer<void>();
    _actLocks.add(completer.future);
    _prepared = false;
    await this.playController.release();
    _controller = null;
    _disposeLock = Completer<void>();
    completer.complete();
    LogUtil.v('释放成功 => $index');
  }

  @override
  Future<void> init(
      {DataSetter<D>? beforeInit,
      ControllerSetter<FijkPlayer>? afterInit}) async {
    if (prepared) return;
    await Future.wait(_actLocks);
    _actLocks.clear();
    var completer = Completer<void>();
    _actLocks.add(completer.future);
    beforeInit ??= this.beforeInit;
    var videoUrl = await beforeInit.call(this.data);
    if (videoUrl.length > 10) {
      LogUtil.v('请求到视频地址  => $index');
    }
    // videoUrl = 'https://static.ybhospital.net/test-video.mp4';
    // videoUrl = 'https://';
    await this.playController.setDataSource(videoUrl);
    
    
    await this.playController.prepareAsync();
    await this.playController.setLoop(0);
    afterInit ??= this.afterInit;
    await afterInit?.call(this.playController);
    _prepared = true;
    completer.complete();
    if (_disposeLock != null) {
      _disposeLock?.complete();
      _disposeLock = null;
    }
  }

  @override
  Future<void> pause({bool showPauseIcon = false}) async {
    await Future.wait(_actLocks);
    _actLocks.clear();
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    if (this.playController.isPlayable()) {
      await this.playController.pause();
      LogUtil.v('暂停成功 => $index');
    } else {
      // await this.playController.reset();
      // _prepared = false;
      LogUtil.v(this.playController.state);
      LogUtil.v('重置 => $index');
    }

    _showPauseIcon.value = true;
  }

  @override
  Future<void> play() async {
    await Future.wait(_actLocks);
    _actLocks.clear();
    await init();
    if (!prepared) return;
    if (_disposeLock != null) {
      await _disposeLock?.future;
    }
    await this.playController.start();
    LogUtil.v('播放 => $index');
    _showPauseIcon.value = false;
  }
  /// 刷新当前
  Future<void> refresh() async {
    
    _prepared = false;
    await this.playController.reset();
    await play();
  }

  @override
  ValueNotifier<bool> get showPauseIcon => _showPauseIcon;
}
