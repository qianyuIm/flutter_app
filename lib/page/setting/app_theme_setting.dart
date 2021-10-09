import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/color_helper.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_circle.dart';
import 'package:flutter_app/widget/qy_expansion_remove_divider_tile.dart';

import 'package:provider/provider.dart';

class AppThemeSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeModel = Provider.of<MyAppThemeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting_theme),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: Inchs.sp8),
          ),
          _buildMode(context, themeModel),
          SliverPadding(
            padding: EdgeInsets.only(top: Inchs.sp8),
          ),
          _buildTheme(context, themeModel),
        ],
      ),
    );
  }

  Widget _buildMode(BuildContext context, MyAppThemeViewModel themeModel) {
    return SliverToBoxAdapter(
      child: QYExpansionRemoveDividerTile(
        backgroundColor: AppTheme.cardColor(context),
        collapsedBackgroundColor: AppTheme.scaffoldBackgroundColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).setting_theme_mode),
            Text(MyAppThemeViewModel.darkModeName(
                themeModel.darkModeIndex, context))
          ],
        ),
        leading: Icon(
          Icons.color_lens,
        ),
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: QYConfig.darkModeSupport.length,
            itemBuilder: (context, index) {
              return RadioListTile<int>(
                activeColor: Theme.of(context).primaryColor,
                selected: themeModel.darkModeIndex == index,
                value: index,
                onChanged: (value) {
                  themeModel.switchDarkMode(value);
                },
                groupValue: themeModel.darkModeIndex,
                title: Text(MyAppThemeViewModel.darkModeName(index, context)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTheme(BuildContext context, MyAppThemeViewModel themeModel) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverPadding(
      padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.5,
        children: QYConfig.appThemeIndexSupport.keys.map((index) {
          var primaryColor = themeModel.primaryColorFor(index, isDarkMode);
          return QYBounce(
            absorbOnMove: true,
            onPressed: () {
              themeModel.switchTheme(index);
            },
            child: GridTile(
              header: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: index == themeModel.themeIndex
                        ? primaryColor.withAlpha(200)
                        : primaryColor.withAlpha(100)),
                padding: EdgeInsets.only(left: 10, right: 5),
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      ColorHelper.colorString(primaryColor),
                      style: AppTheme.subtitleStyle(context).copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    if (index == themeModel.themeIndex)
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
                alignment: Alignment(0, 0.30),
                child: Text(
                  QYConfig.appThemeIndexSupport[index] ?? '',
                  style: AppTheme.titleStyle(context).copyWith(color: Colors.white),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
