import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_circle.dart';

/// 音质选择
/// 0 自动选择
/// 128000 标准
/// 192000 较高
/// 320000 极高
/// 999000 无损音质
///

class AppMusicQualitySetting extends StatefulWidget {
  @override
  _AppMusicQualitySettingState createState() => _AppMusicQualitySettingState();
}

class _AppMusicQualitySettingState extends State<AppMusicQualitySetting> {
  @override
  Widget build(BuildContext context) {
    var presetPlayingQuality =
        SpUtil.getInt(SpConfig.presetMusicPlayingQualityKey, defValue: 0)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting_song_quality),
      ),
      body: _buildLanguage(context, presetPlayingQuality),
    );
  }

  Widget _buildLanguage(BuildContext context, int presetPlayingQuality) {
    return Padding(
      padding: EdgeInsets.only(
          left: Inchs.left, right: Inchs.right, top: Inchs.sp10),
      child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1.5,
          children: QYConfig.appMusicQualitySupport.keys.map((quality) {
            return _buildItem(context, presetPlayingQuality, quality);
          }).toList()),
    );
  }

  Widget _buildItem(BuildContext context, int presetPlayingQuality, int quality) {
    var qualityName = QYConfig.appMusicQualitySupport[quality]!;
    var primaryColor = AppTheme.primaryColor(context);
    return QYBounce(
      absorbOnMove: true,
      onPressed: () async {
        await SpUtil.putInt(SpConfig.presetMusicPlayingQualityKey, quality);
        setState(() {});
      },
      child: GridTile(
        header: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: quality == presetPlayingQuality
                  ? primaryColor.withAlpha(200)
                  : primaryColor.withAlpha(100)),
          padding: EdgeInsets.only(left: 10, right: 5),
          height: 30,
          child: Row(
            children: [
              Spacer(),
              if (quality == presetPlayingQuality)
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
              qualityName,
              textAlign: TextAlign.center,
              style: AppTheme.titleCopyStyle(context,color: Colors.white),
            )),
      ),
    );
  }
}
