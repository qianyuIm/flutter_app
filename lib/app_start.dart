import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/helper/platform_helper.dart';
import 'package:path_provider/path_provider.dart';
/// 启动
class AppStart {
  static late String packageVersion;
  /// 临时目录 eg: cookie
  static late Directory temporaryDirectory;

  static Future init(VoidCallback callback) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    FijkLog.setLevel(FijkLogLevel.Error);
    temporaryDirectory = await getTemporaryDirectory();
    LogUtil.init(
      tag: 'flutter_app',
      isDebug: QYConfig.isDebug,
      maxLen: 1024 * 5,
    );
    LogUtil.v('path => ${temporaryDirectory.path}');
    packageVersion = await PlatformHelper.appVersion();
    await LocalDb.instance.initDb();
    callback();
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。
      //写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，
      //写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
