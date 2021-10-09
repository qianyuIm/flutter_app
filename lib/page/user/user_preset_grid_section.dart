import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/locale_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:provider/provider.dart';

class UserPresetGridSection extends StatefulWidget {
  @override
  _UserPresetGridSectionState createState() => _UserPresetGridSectionState();
}

class _UserPresetGridSectionState extends State<UserPresetGridSection> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<UserPresetGridViewModel>(
      viewModel: UserPresetGridViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        var itemCount = viewModel.categoryItems.length;
        if (itemCount < 12) itemCount += 1;
        var isEvenNumber = (itemCount % 4 == 0);
        var line = itemCount ~/ 4;
        if (!isEvenNumber) {
          line += 1;
        }
        var height = (line * 100).toDouble();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 5),
          child: Card(
              child: Column(
            children: [
              Container(
                height: height,
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 10),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      mainAxisExtent: 100),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == viewModel.categoryItems.length &&
                        viewModel.categoryItems.length < 12) {
                      return QYBounce(
                        absorbOnMove: true,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(MyRouterName.music_user_group)
                              .then((value) => listenerPopTabLengthChange(
                                  context, value as bool));
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageHelper.wrapMusicPng(
                                    'icon_user_add_application'),
                                width: 28,
                                color: AppTheme.iconColor(context),
                              ),
                              QYSpacing(
                                height: 4,
                              ),
                              Container(
                                height: 36,
                               child: Text(
                                S.of(context).user_music_application,
                              ), 
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    var categoryItem = viewModel.categoryItems[index];
                    return QYBounce(
                      absorbOnMove: true,
                      onPressed: () {
                        LogUtil.v('点击');
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImageHelper.wrapMusicPng(
                                  categoryItem.categoryItem.imageName!),
                              width: 30,
                              color: AppTheme.of(context).primaryColor,
                            ),
                            QYSpacing(
                              height: 4,
                            ),
                            Container(
                              height: 36,
                              child: Text(
                              LocaleHelper.localeString(
                                  categoryItem.categoryItem.titleValue!,
                                  categoryItem.categoryItem.titleKey!),
                              textAlign: TextAlign.center,
                            ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildAdd(context, viewModel.categoryItems.length)
            ],
          )),
        );
      },
    );
  }

  Widget _buildAdd(BuildContext context, int length) {
    if (length < 12) {
      return SizedBox.shrink();
    }
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        Navigator.of(context).pushNamed(MyRouterName.music_user_group).then(
            (value) => listenerPopTabLengthChange(context, value as bool));
      },
      child: Container(
        height: 40,
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.wrapMusicPng('icon_user_add_application'),
              width: 28,
              color: AppTheme.iconColor(context),
            ),
            QYSpacing(
              width: 4,
            ),
            Text(S.of(context).user_music_application),
          ],
        ),
      ),
    );
  }

  void listenerPopTabLengthChange(BuildContext context, bool isChange) {
    LogUtil.v('isChange => $isChange');
    if (isChange) {
      Provider.of<UserPresetGridViewModel>(context, listen: false).initData();
    }
  }
}
