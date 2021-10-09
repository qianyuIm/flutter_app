import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class PageNeedLogin extends StatelessWidget {
  final WidgetBuilder builder;
  final WidgetBuilder? unLoginBuilder;
  final VoidCallback? unLoginPressed;

  const PageNeedLogin(
      {Key? key,
      required this.builder,
      this.unLoginBuilder,
      this.unLoginPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = MusicUserManager.of(context, listen: true);
    if (user.isLogin) {
      return builder(context);
    }
    if (unLoginBuilder != null) {
      return unLoginBuilder!(context);
    }
    Widget widget = Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).need_login_title, style: AppTheme.titleStyle(context)),
            QYSpacing(
              height: 20,
            ),
            QYButtom(
              width: 170,
              height: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              title: Text(
                S.of(context).need_login_go,
                style: AppTheme.subtitleCopyStyle(context,color: AppTheme.primaryColor(context))
                    ,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor(context)),
              onPressed: (state) {
                unLoginPressed?.call();
                Navigator.of(context).pushNamed(MyRouterName.music_login);
              },
            ),
          ],
        ),
      ),
    );
    // if (Scaffold.maybeOf(context) == null) {
    //   widget =
    //       Scaffold(body: widget, appBar: AppBar(title: const Text('需要登陆')));
    // }
    return widget;
  }
}
