import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_circle.dart';
import 'package:provider/provider.dart';

class AppFontSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeModel = Provider.of<MyAppThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting_font),
      ),
      body: _buildFont(context, themeModel),
    );
  }

  Widget _buildFont(BuildContext context, MyAppThemeViewModel themeModel) {
    return GridView.builder(
      padding: EdgeInsets.only(
          left: Inchs.left, right: Inchs.right, top: Inchs.sp10),
      itemCount: QYConfig.appFontFamilySupport.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return _buildItem(context, themeModel, index);
      },
    );
  }

  Widget _buildItem(
      BuildContext context, MyAppThemeViewModel themeModel, int index) {
    var fontFamily = QYConfig.appFontFamilySupport[index];
    var primaryColor = AppTheme.primaryColor(context);
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        themeModel.switchFontFamily(fontFamily);
      },
      child: GridTile(
        header: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: fontFamily == themeModel.fontFamily
                  ? primaryColor.withAlpha(200)
                  : primaryColor.withAlpha(100)),
          padding: EdgeInsets.only(left: 10, right: 5),
          height: 30,
          child: Row(
            children: [
              Text(fontFamily,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: fontFamily,
                  )),
              Spacer(),
              if (fontFamily == themeModel.fontFamily)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: QYCircle(color: Colors.white),
                )
            ],
          ),
        ),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(colors: [
                  primaryColor.withOpacity(0.3),
                  primaryColor.withOpacity(0.5),
                  primaryColor.withOpacity(0.7),
                  primaryColor.withOpacity(0.9),
                  primaryColor.withOpacity(1.0),
                  primaryColor.withOpacity(0.9),
                  primaryColor.withOpacity(0.7),
                  primaryColor.withOpacity(0.5),
                  primaryColor.withOpacity(0.3),
                ])),
            alignment: Alignment(0, 0.20),
            child: Text(
              '浅宇\nQianYuIm',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: fontFamily, fontSize: 16,color: Colors.white),
            )),
      ),
    );
  }
}
