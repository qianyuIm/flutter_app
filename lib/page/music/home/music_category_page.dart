import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/locale_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicCategoryPage extends StatefulWidget {
  @override
  _MusicCategoryPageState createState() => _MusicCategoryPageState();
}

class _MusicCategoryPageState extends State<MusicCategoryPage> {
  double scrollRatio = 0;

  @override
  Widget build(BuildContext context) {
    var color = AppTheme.primaryColor(context);
    var itemRender = QYConfig.musicCategorySupport
        .map((ele) => QYBounce(
              absorbOnMove: true,
              onPressed: () {
                LogUtil.v('点击了');
                Navigator.of(context).pushNamed(ele.routeName!);
              },
              child: Container(
                width: Inchs.adapter(345 / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: color.withAlpha(80)),
                        ),
                        Center(
                          child: Image.asset(
                            ImageHelper.wrapMusicPng(
                              ele.imageName!,
                            ),
                            height: Inchs.adapter(40),
                            color: color,
                          ),
                        ),
                        if (ele.imageName == 'music_daily_recommend')
                          Positioned(
                              bottom: 16,
                              child: Text(
                                TimeHelper.day(),
                                style: AppTheme.subtitleStyle(context).copyWith(
                                    fontSize: 12, color: Colors.white),
                              ))
                      ],
                    ),
                    QYSpacing(
                      height: 4,
                    ),
                    Text(
                      LocaleHelper.localeString(ele.titleValue!, ele.titleKey!),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ))
        .toList();

    return Container(
        padding: EdgeInsets.only(top: Inchs.sp10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itemRender,
        ));
  }
}
