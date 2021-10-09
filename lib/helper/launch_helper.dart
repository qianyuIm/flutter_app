import 'package:flustars/flustars.dart';
import 'package:flutter_app/app_start.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/router/router_manger.dart';

class LaunchHelper {
  static String initialRoute() {
    
    /// TODO： 测试阶段 
    return MyRouterName.tab;
    // var storage = SpUtil.getString(SpConfig.firstVersionKey)!;
    ///  展示新特性
    // if (storage != AppStart.packageVersion) {
    //   return MyRouterName.intro;
    // }
    // return MyRouterName.splash;
  }

  /// 保存版本号
  static storage() {
      SpUtil.putString(SpConfig.firstVersionKey,  AppStart.packageVersion);
  }

}