import 'package:flutter/material.dart';
import 'package:flutter_app/app_start.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/launch_helper.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/locale_view_model.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  
  AppStart.init(() {
    runApp(MyApp());
  });
  
}

///全局获取context
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialAppPage();
  }
}

class MaterialAppPage extends StatefulWidget {
  @override
  _MaterialAppPageState createState() => _MaterialAppPageState();
}

class _MaterialAppPageState extends State<MaterialAppPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () => MultiProvider(
        providers: [
          /// 登录状态
          ChangeNotifierProvider<MusicUserManager>(
            create: (context) => MusicUserManager(),
          ),
          /// 皮肤
          ChangeNotifierProvider<MyAppThemeViewModel>(
            create: (context) => MyAppThemeViewModel(),
          ),
          /// 语言
          ChangeNotifierProvider<LocaleViewModel>(
            create: (context) => LocaleViewModel(),
          ),
          /// 音频播放控制
          ChangeNotifierProvider<MusicPlayerManager>(
              create: (context) => MusicPlayerManager(platform: Theme.of(context).platform)),
             
        ],
        child: Consumer2<MyAppThemeViewModel, LocaleViewModel>(
          builder: (context, theme, locale, child) {
            return RefreshConfiguration(
              hideFooterWhenNotFull: true,
              child: MaterialApp(
                onGenerateTitle: (context) => S.of(context).appTitle,
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                darkTheme: theme.themeData(isDarkMode: true),
                theme: theme.themeData(),
                themeMode: theme.getThemeMode(),
                locale: locale.locale,
                localizationsDelegates: const [
                  S.delegate,
                  RefreshLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                onGenerateRoute: MyRouter.generateRoute,
                initialRoute: LaunchHelper.initialRoute(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
