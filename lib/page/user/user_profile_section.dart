import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userItem = MusicUserManager.of(context).userDetail;
    if (userItem == null) {
      return _userNotLogin(context);
    }
    return Container(
      margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.only(
            bottom: 8, left: Inchs.left, right: Inchs.right),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: QYBounce(
                  onPressed: () {
                    LogUtil.v('打印');
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },));
          },
          child: Container(
            height: 72,
            child: Row(
              children: [
                ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      userItem.profile?.avatarUrl, 54, 54),
                  width: 54,
                  height: 54,
                  radius: 27,
                ),
                QYSpacing(width: 4,),
                  Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userItem.profile?.nickname ?? ''),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor(context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          child: Text(
                            "Lv.${userItem.level}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.titleColor(context),
              )
              ],
            ),
          ),
        ));
  }

  Widget _userNotLogin(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding:
          EdgeInsets.only(bottom: 8, left: Inchs.left, right: Inchs.right),
      child: QYBounce(
        absorbOnMove: true,
        onPressed: () {
          
          Navigator.of(context).pushNamed(MyRouterName.music_login);
        },
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Image.asset(
                ImageHelper.wrapMusicPng('music_default_avatar'),
                width: 54,
              ),
              QYSpacing(
                width: 6,
              ),
              Text(S.of(context).login),
              Spacer(),
              Icon(
                Icons.chevron_right,
              )
            ],
          ),
        ),
      ),
    );
  }
}
