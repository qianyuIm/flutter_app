import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';

class ConnectivityHelper {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectionStatusController =
      StreamController<ConnectivityResult>.broadcast();

  /// 网络连接状态监听
  Stream<ConnectivityResult> get onConnectivityStatusChanged =>
      _connectionStatusController.stream;
  ConnectivityResult get connectionStatus => _connectionStatus;

  bool get isWifi => _connectionStatus == ConnectivityResult.wifi;
  bool get isMobile => _connectionStatus == ConnectivityResult.mobile;

  factory ConnectivityHelper() {
    _singleton ??= ConnectivityHelper._();
    return _singleton!;
  }
  static ConnectivityHelper? _singleton;

  ConnectivityHelper._() {
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    LogUtil.v('数据改变 => $result');
    _connectionStatus = result;
    _connectionStatusController.add(result);
  }
}
