import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/generated/l10n.dart';

class LocaleViewModel extends ChangeNotifier {
  late int _localeIndex;

  int get localeIndex => _localeIndex;

  Locale? get locale {
    if (_localeIndex > 0) {
      var value = QYConfig.appLocaleSupport[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  LocaleViewModel() {
    _localeIndex = SpUtil.getInt(SpConfig.appLocaleIndexKey)!;
  }

  void switchLocale(int? index) {
    _localeIndex = index ?? _localeIndex;
    notifyListeners();
    SpUtil.putInt(SpConfig.appLocaleIndexKey, _localeIndex);
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).setting_language_auto;
      case 1:
        return '中文';
      case 2:
        return 'English';
      default:
        return '';
    }
  }
}
