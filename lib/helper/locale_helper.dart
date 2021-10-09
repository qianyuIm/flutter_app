import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:intl/intl.dart';




extension AppLocalizationExtension on BuildContext {
  /// 国际化
  S get localization {
    return S.of(this);
  }
}
/// tabbar  使用  
class LocaleHelper {
  /// 参考： l10n.dart 写法
  static String localeString(String titleValue, String titleKey) {
     return Intl.message(
      titleValue,
      name: titleKey,
      desc: '',
      args: [],
    );
  }
}