import 'package:colour/colour.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/generated/l10n.dart';

/// 主题支持列表
final _appThemeSupport = <int, _AppTheme>{
  0: _NeteaseAppTheme(),
  1: _DiDiAppTheme(),
  2: _WeChatAppTheme(),
  3: _FishAppTheme(),
  4: _QuarkAppTheme()
};

class MyAppThemeViewModel extends ChangeNotifier {
  /// 明暗模式
  late int _darkModeIndex;

  /// 当前主题
  late int _themeIndex;

  /// 当前字体
  late String _fontFamily;

  Color get primaryColor => _appThemeSupport[_themeIndex]!.primaryColor(false);
  String get fontFamily => _fontFamily;
  int get darkModeIndex => _darkModeIndex;
  int get themeIndex => _themeIndex;

  MyAppThemeViewModel() {
    _darkModeIndex = SpUtil.getInt(SpConfig.appThemeUserDarkModeKey)!;
    _themeIndex = SpUtil.getInt(SpConfig.appThemeIndexKey)!;
    _fontFamily =
        SpUtil.getString(SpConfig.appFontFamilyKey, defValue: 'system')!;
  }

  /// 获取对应主色
  Color primaryColorFor(int index, bool isDarkMode) {
    // 判断
    // if (_darkModeIndex == 1) {
    //   isDarkMode = false;
    // } else if (_darkModeIndex == 2) {
    //   isDarkMode = true;
    // }
    return _appThemeSupport[index]!.primaryColor(isDarkMode);
  }

  /// 获取当前主色
  Color currentPrimaryColor(bool isDarkMode) {
    return primaryColorFor(_themeIndex, isDarkMode);
  }

  void switchDarkMode(int? index) {
    _darkModeIndex = index ?? _darkModeIndex;
    notifyListeners();
    _saveDarkMode2Storage(_darkModeIndex);
  }

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme(int? themeIndex) {
    _themeIndex = themeIndex ?? _themeIndex;
    notifyListeners();
    _saveTheme2Storage(_themeIndex);
  }

  /// 切换字体
  void switchFontFamily(String? fontFamily) {
    _fontFamily = fontFamily ?? _fontFamily;
    notifyListeners();
    _saveFontFamily2Storage(_fontFamily);
  }

  /// 获取当前模式
  ThemeMode getThemeMode() {
    switch (_darkModeIndex) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }

  /// 自定义 themeData
  /// isPlatformDarkMode: 系统级别
  ThemeData themeData({bool isDarkMode: false}) {
    var _appTheme = _appThemeSupport[_themeIndex];
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,

        /// 主色
        primaryColor: _appTheme?.primaryColor(isDarkMode),
        tabBarTheme: _appTheme?.tabBarTheme(isDarkMode, fontFamily),

        /// 自定义 tabbar
        bottomNavigationBarTheme:
            _appTheme?.bottomNavigationBarTheme(isDarkMode, fontFamily),
        dividerColor: _appTheme?.dividerColor(isDarkMode),

        /// 导航条
        appBarTheme: _appTheme?.appBarTheme(isDarkMode, fontFamily),
        iconTheme: _appTheme?.iconTheme(isDarkMode),

        /// 内容背景色
        scaffoldBackgroundColor: _appTheme?.scaffoldBackgroundColor(isDarkMode),
        cardTheme: _appTheme?.cardTheme(isDarkMode),
        fontFamily: _fontFamily);

    /// 得出结论 DefaultTextStyle 与 bodyText2 相关
    themeData = themeData.copyWith(
        
        textTheme: themeData.textTheme.copyWith(
            bodyText1: themeData.textTheme.bodyText1?.copyWith(
                fontSize: _appTheme?.titleFontSize,
                color: _appTheme?.titleColor(isDarkMode)),
            bodyText2: themeData.textTheme.subtitle2?.copyWith(
                fontSize: _appTheme?.subtitleFontSize,
                color: _appTheme?.subtitleColor(isDarkMode))));
    return themeData;
  }

  /// 深色模式选择
  static String darkModeName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).setting_theme_mode_auto;
      case 1:
        return S.of(context).setting_theme_mode_normal;
      case 2:
        return S.of(context).setting_theme_mode_dark;
      default:
        return '';
    }
  }

  /// 数据持久化到shared preferences
  void _saveTheme2Storage(int themeIndex) async {
    SpUtil.putInt(SpConfig.appThemeIndexKey, themeIndex);
  }

  void _saveDarkMode2Storage(int userDarkModeIndex) async {
    SpUtil.putInt(SpConfig.appThemeUserDarkModeKey, userDarkModeIndex);
  }

  void _saveFontFamily2Storage(String fontFamily) async {
    SpUtil.putString(SpConfig.appFontFamilyKey, fontFamily);
  }
}

abstract class _AppTheme {
  /// 主色
  Color primaryColor(bool isDarkMode);

  /// 强调色 废弃
  // Color accentColor(bool isDarkMode);

  /// 图标主题
  IconThemeData iconTheme(bool isDarkMode);

  /// 内容背景色
  Color scaffoldBackgroundColor(bool isDarkMode);

  /// 导航主题
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily);

  /// tabbar主题
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily);

  /// Tab 主题设置
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily);

  /// Card 主题
  CardTheme cardTheme(bool isDarkMode);

  /// 分割线颜色
  Color dividerColor(bool isDarkMode);

  /// 标题颜色
  Color titleColor(bool isDarkMode);

  /// 副标题颜色
  Color subtitleColor(bool isDarkMode);

  /// 禁止选中的颜色
  Color disabledColor(bool isDarkMode);

  /// 标题大小
  double get titleFontSize;

  /// 副标题大小
  double get subtitleFontSize;
}

/// 网易红
class _NeteaseAppTheme extends _AppTheme {
  @override
  Color primaryColor(bool isDarkMode) {
    return isDarkMode ? Colour('#bd0618') : Colour('#F83245');
  }

  // @override
  // Color accentColor(bool isDarkMode) {
  //   return isDarkMode ? Colour('#d2071b') : Colors.yellow;
  // }

  @override
  IconThemeData iconTheme(bool isDarkMode) {
    return IconThemeData(
        color: isDarkMode ? Colour('#c44546') : Colour('#e15159'),
        opacity: 1.0,
        size: 24);
  }

  @override
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily) {
    return AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkMode ? Colour('252528') : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colour('#3C3C3C')),
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily));
  }

  @override
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
      selectedItemColor: primaryColor(isDarkMode),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      selectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey,
          fontSize: 14,
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
    );
  }

  @override
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily) {
    return TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: primaryColor(isDarkMode),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: titleColor(isDarkMode),
      unselectedLabelColor: subtitleColor(isDarkMode),
      labelStyle: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: titleColor(isDarkMode),
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          fontSize: subtitleFontSize,
          color: subtitleColor(isDarkMode),
          fontFamily: fontFamily),
    );
  }

  @override
  CardTheme cardTheme(bool isDarkMode) {
    return CardTheme(
      margin: EdgeInsets.zero,
      color: isDarkMode ? Colour('#353535') : Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  @override
  Color disabledColor(bool isDarkMode) {
    return isDarkMode ? Colors.white38 : Colors.black38;
  }

  @override
  Color dividerColor(bool isDarkMode) {
    return subtitleColor(isDarkMode);
  }

  @override
  Color scaffoldBackgroundColor(bool isDarkMode) {
    return isDarkMode ? Colour('#323232') : Colour('#F2F2F7');
  }

  @override
  Color subtitleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#E6E6E6') : Colour('#626262');
  }

  @override
  double get subtitleFontSize => Inchs.adapter(13);

  @override
  Color titleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#FFFFFF') : Colour('#3D444B');
  }

  @override
  double get titleFontSize => Inchs.adapter(16);
}

/// 滴滴橙
class _DiDiAppTheme extends _AppTheme {
  @override
  Color primaryColor(bool isDarkMode) {
    return isDarkMode ? Colour('#EC5D00') : Colour('#FF7B24');
  }

  // @override
  // Color accentColor(bool isDarkMode) {
  //   return isDarkMode ? Colour('#bf4c00') : Colour('#ff7b24');
  // }

  @override
  IconThemeData iconTheme(bool isDarkMode) {
    return IconThemeData(
        color: isDarkMode ? Colour('#ff771f') : Colour('#ffa061'),
        opacity: 1.0,
        size: 24);
  }

  @override
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily) {
    return AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkMode ? Colour('252528') : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colour('#3C3C3C')),
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily));
  }

  @override
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
      selectedItemColor: primaryColor(isDarkMode),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      selectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey,
          fontSize: 14,
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
    );
  }

  @override
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily) {
    return TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: primaryColor(isDarkMode),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: titleColor(isDarkMode),
      unselectedLabelColor: subtitleColor(isDarkMode),
      labelStyle: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: titleColor(isDarkMode),
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          fontSize: subtitleFontSize,
          color: subtitleColor(isDarkMode),
          fontFamily: fontFamily),
    );
  }

  @override
  CardTheme cardTheme(bool isDarkMode) {
    return CardTheme(
      margin: EdgeInsets.zero,
      color: isDarkMode ? Colour('#353535') : Colour('#FFFFFF'),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  @override
  Color disabledColor(bool isDarkMode) {
    return isDarkMode ? Colors.white38 : Colors.black38;
  }

  @override
  Color dividerColor(bool isDarkMode) {
    return subtitleColor(isDarkMode);
  }

  @override
  Color scaffoldBackgroundColor(bool isDarkMode) {
    return isDarkMode ? Colour('#323232') : Colour('#F2F2F7');
  }

  @override
  Color subtitleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#E6E6E6') : Colour('#626262');
  }

  @override
  double get subtitleFontSize => Inchs.adapter(13);

  @override
  Color titleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#FFFFFF') : Colour('#3D444B');
  }

  @override
  double get titleFontSize => Inchs.adapter(16);
}

/// 微信绿
class _WeChatAppTheme extends _AppTheme {
  @override
  Color primaryColor(bool isDarkMode) {
    return isDarkMode ? Colour('#03a04d') : Colour('#03dc6a');
  }

  // @override
  // Color accentColor(bool isDarkMode) {
  //   return isDarkMode ? Colour('#039045') : Colour('#03c65f');
  // }

  @override
  IconThemeData iconTheme(bool isDarkMode) {
    return IconThemeData(
        color: isDarkMode ? Colour('#03823e') : Colour('#03b256'),
        opacity: 1.0,
        size: 24);
  }

  @override
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily) {
    return AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkMode ? Colour('252528') : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colour('#3C3C3C')),
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily));
  }

  @override
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
      selectedItemColor: primaryColor(isDarkMode),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      selectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey,
          fontSize: 14,
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
    );
  }

  @override
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily) {
    return TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: primaryColor(isDarkMode),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: titleColor(isDarkMode),
      unselectedLabelColor: subtitleColor(isDarkMode),
      labelStyle: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: titleColor(isDarkMode),
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          fontSize: subtitleFontSize,
          color: subtitleColor(isDarkMode),
          fontFamily: fontFamily),
    );
  }

  @override
  CardTheme cardTheme(bool isDarkMode) {
    return CardTheme(
      margin: EdgeInsets.zero,
      color: isDarkMode ? Colour('#353535') : Colour('#FFFFFF'),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  @override
  Color disabledColor(bool isDarkMode) {
    return isDarkMode ? Colors.white38 : Colors.black38;
  }

  @override
  Color dividerColor(bool isDarkMode) {
    return subtitleColor(isDarkMode);
  }

  @override
  Color scaffoldBackgroundColor(bool isDarkMode) {
    return isDarkMode ? Colour('#323232') : Colour('#F2F2F7');
  }

  @override
  Color subtitleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#E6E6E6') : Colour('#626262');
  }

  @override
  double get subtitleFontSize => Inchs.adapter(13);

  @override
  Color titleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#FFFFFF') : Colour('#3D444B');
  }

  @override
  double get titleFontSize => Inchs.adapter(16);
}

/// 闲鱼黄
class _FishAppTheme extends _AppTheme {
  @override
  Color primaryColor(bool isDarkMode) {
    return isDarkMode ? Colour('#a17900') : Colour('#dda600');
  }

  // @override
  // Color accentColor(bool isDarkMode) {
  //   return isDarkMode ? Colour('#916d00') : Colour('#c79500');
  // }

  @override
  IconThemeData iconTheme(bool isDarkMode) {
    return IconThemeData(
        color: isDarkMode ? Colour('#b18500') : Colour('#b38600'),
        opacity: 1.0,
        size: 24);
  }

  @override
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily) {
    return AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        color: isDarkMode ? Colour('252528') : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colour('#3C3C3C')),
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily));
  }

  @override
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
      selectedItemColor: primaryColor(isDarkMode),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      selectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey,
          fontSize: 14,
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
    );
  }

  @override
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily) {
    return TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: primaryColor(isDarkMode),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: titleColor(isDarkMode),
      unselectedLabelColor: subtitleColor(isDarkMode),
      labelStyle: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: titleColor(isDarkMode),
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          fontSize: subtitleFontSize,
          color: subtitleColor(isDarkMode),
          fontFamily: fontFamily),
    );
  }

  @override
  CardTheme cardTheme(bool isDarkMode) {
    return CardTheme(
      margin: EdgeInsets.zero,
      color: isDarkMode ? Colour('#353535') : Colour('#FFFFFF'),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  @override
  Color disabledColor(bool isDarkMode) {
    return isDarkMode ? Colors.white38 : Colors.black38;
  }

  @override
  Color dividerColor(bool isDarkMode) {
    return subtitleColor(isDarkMode);
  }

  @override
  Color scaffoldBackgroundColor(bool isDarkMode) {
    return isDarkMode ? Colour('#323232') : Colour('#F2F2F7');
  }

  @override
  Color subtitleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#E6E6E6') : Colour('#626262');
  }

  @override
  double get subtitleFontSize => Inchs.adapter(13);

  @override
  Color titleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#FFFFFF') : Colour('#3D444B');
  }

  @override
  double get titleFontSize => Inchs.adapter(16);
}

/// 夸克紫
class _QuarkAppTheme extends _AppTheme {
  @override
  Color primaryColor(bool isDarkMode) {
    return isDarkMode ? Colour('#6e4486') : Colour('#9565b1');
  }

  // @override
  // Color accentColor(bool isDarkMode) {
  //   return isDarkMode ? Colour('#633d79') : Colour('#8854a6');
  // }

  @override
  IconThemeData iconTheme(bool isDarkMode) {
    return IconThemeData(
        color: isDarkMode ? Colour('#794b93') : Colour('#7a4c95'),
        opacity: 1.0,
        size: 24);
  }

  @override
  AppBarTheme appBarTheme(bool isDarkMode, String fontFamily) {
    return AppBarTheme(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colour('#3C3C3C')),
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colour('#3C3C3C'),
            fontFamily: fontFamily));
  }

  @override
  BottomNavigationBarThemeData bottomNavigationBarTheme(
      bool isDarkMode, String fontFamily) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colour('252528') : Colors.white,
      selectedItemColor: primaryColor(isDarkMode),
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      selectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.grey : Colors.grey,
          fontSize: 14,
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 12),
    );
  }

  @override
  TabBarTheme tabBarTheme(bool isDarkMode, String fontFamily) {
    return TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3,
          color: primaryColor(isDarkMode),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: titleColor(isDarkMode),
      unselectedLabelColor: subtitleColor(isDarkMode),
      labelStyle: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: titleColor(isDarkMode),
          fontFamily: fontFamily),
      unselectedLabelStyle: TextStyle(
          fontSize: subtitleFontSize,
          color: subtitleColor(isDarkMode),
          fontFamily: fontFamily),
    );
  }

  @override
  CardTheme cardTheme(bool isDarkMode) {
    return CardTheme(
      margin: EdgeInsets.zero,
      color: isDarkMode ? Colour('#353535') : Colour('#FFFFFF'),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  @override
  Color disabledColor(bool isDarkMode) {
    return isDarkMode ? Colors.white38 : Colors.black38;
  }

  @override
  Color dividerColor(bool isDarkMode) {
    return subtitleColor(isDarkMode);
  }

  @override
  Color scaffoldBackgroundColor(bool isDarkMode) {
    return isDarkMode ? Colour('#323232') : Colour('#F2F2F7');
  }

  @override
  Color subtitleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#E6E6E6') : Colour('#626262');
  }

  @override
  double get subtitleFontSize => Inchs.adapter(13);

  @override
  Color titleColor(bool isDarkMode) {
    return isDarkMode ? Colour('#FFFFFF') : Colour('#3D444B');
  }

  @override
  double get titleFontSize => Inchs.adapter(16);
}

class AppTheme {
  /// 主题
  static ThemeData of(BuildContext context) {
    return Theme.of(context);
  }

  /// 主色
  static Color primaryColor(BuildContext context) {
    return of(context).primaryColor;
  }

  /// 强调色 废弃
  // static Color accentColor(BuildContext context) {
  //   return of(context).colorScheme.secondary;
  // }

  /// 图标 主题
  static AppBarTheme appBarTheme(BuildContext context) {
    return of(context).appBarTheme;
  }

  /// 图标 主题
  static IconThemeData iconTheme(BuildContext context) {
    return of(context).iconTheme;
  }

  /// 图标色 of Border color
  static Color iconColor(BuildContext context) {
    return iconTheme(context).color!;
  }

  /// 主背景色
  static Color scaffoldBackgroundColor(BuildContext context) {
    return of(context).scaffoldBackgroundColor;
  }

  /// card theme
  static CardTheme cardTheme(BuildContext context) {
    return of(context).cardTheme;
  }

  /// card背景色
  static Color cardColor(BuildContext context) {
    return cardTheme(context).color!;
  }

  /// 底部主题
  static BottomNavigationBarThemeData bottomNavigationBarThemeData(
      BuildContext context) {
    return of(context).bottomNavigationBarTheme;
  }

  /// size 16 颜色追随系统
  static TextStyle titleStyle(BuildContext context) =>
      of(context).textTheme.bodyText1!;

  /// title copy size 16
  static TextStyle titleCopyStyle(BuildContext context,
          {Color? color, double? fontSize, FontWeight? fontWeight}) =>
      titleStyle(context).copyWith(
          color: color,
          fontSize: (fontSize != null) ? Inchs.adapter(fontSize) : fontSize,
          fontWeight: fontWeight);

  /// siez 13 颜色追随系统
  static TextStyle subtitleStyle(BuildContext context) =>
      of(context).textTheme.bodyText2!;

  /// subtitle copy siez 13
  static TextStyle subtitleCopyStyle(BuildContext context,
          {Color? color, double? fontSize, double? height,FontWeight? fontWeight}) =>
      subtitleStyle(context).copyWith(
          color: color,
          fontSize: (fontSize != null) ? Inchs.adapter(fontSize) : fontSize,
          height: height,
          fontWeight: fontWeight);

  /// title color
  static Color titleColor(BuildContext context) => titleStyle(context).color!;

  /// subTitle color
  static Color subtitleColor(BuildContext context) =>
      subtitleStyle(context).color!;
}
