import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/view_model/locale_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_circle.dart';
import 'package:provider/provider.dart';

class AppLanguageSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localeModel = Provider.of<LocaleViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting_language),
      ),
      body: _buildLanguage(context, localeModel),
    );
  }

  Widget _buildLanguage(BuildContext context, LocaleViewModel localeModel) {
    return GridView.builder(
      padding: EdgeInsets.only(
          left: Inchs.left, right: Inchs.right, top: Inchs.sp10),
      itemCount: QYConfig.appLocaleSupport.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        return _buildItem(context, localeModel, index);
      },
    );
  }

  Widget _buildItem(
      BuildContext context, LocaleViewModel localeModel, int index) {
    var localeName = LocaleViewModel.localeName(index, context);
    var primaryColor = AppTheme.primaryColor(context);
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        localeModel.switchLocale(index);
      },
      child: GridTile(
        header: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: index == localeModel.localeIndex
                  ? primaryColor.withAlpha(200)
                  : primaryColor.withAlpha(100)),
          padding: EdgeInsets.only(left: 10, right: 5),
          height: 30,
          child: Row(
            children: [
              Spacer(),
              if (index == localeModel.localeIndex)
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
              localeName,
              textAlign: TextAlign.center,
              style: AppTheme.titleStyle(context).copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
