import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class AppSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right,top: Inchs.sp10),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  QYSpacing(
                    height: 4,
                  ),
                  _buildItem(
                    context,
                    S.of(context).setting_theme,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MyRouterName.app_theme_setting);
                    },
                  ),
                  QYSpacing(
                    height: 4,
                  ),
                  _buildItem(
                    context,
                    S.of(context).setting_font,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MyRouterName.app_font_setting);
                    },
                  ),
                  QYSpacing(
                    height: 4,
                  ),
                  _buildItem(
                    context,
                    S.of(context).setting_language,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MyRouterName.app_language_setting);
                    },
                  ),
                  QYSpacing(
                    height: 4,
                  ),
                ],
              ),
            ),
            QYSpacing(
                    height: 8,
                  ),
            Card(
              child: Column(
                children: [
                  QYSpacing(
                    height: 4,
                  ),
                  _buildItem(
                    context,
                    S.of(context).setting_song_quality,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MyRouterName.app_song_quality_setting);
                    },
                  ),
                  QYSpacing(
                    height: 4,
                  ),
                  
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title,
      {VoidCallback? onPressed}) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Icon(
              Icons.chevron_right,
              color: AppTheme.subtitleColor(context),
            )
          ],
        ),
      ),
    );
  }
}
