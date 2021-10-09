
import 'package:flutter/material.dart';
import 'package:flutter_app/page/music/login/music_login_page.dart';
import 'package:flutter_app/page/music/login/music_login_pwd_page.dart';

const pageLoginPassword = "loginPassword";
const pageLoginPhone = "loginWithPhone";

/// 登录流程
class LoginNavigator extends StatelessWidget {
  const LoginNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: pageLoginPhone,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings, builder: (context) => _generatePage(settings)!);
      },
    );
  }

  Widget? _generatePage(RouteSettings settings) {
    switch (settings.name) {
      case pageLoginPhone:
        return MusicLoginPage();
      case pageLoginPassword:
        final args = settings.arguments! as Map<String, String>;
        return MusicLoginPwdPage(
          mobile: args['mobile'] as String,
           nickName: args['nickName'] as String,
        );
    }
    return null;
  }
}