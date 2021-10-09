import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_personalized.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicDjProgramPage extends StatefulWidget {
  @override
  _MusicDjProgramPageState createState() => _MusicDjProgramPageState();
}

class _MusicDjProgramPageState extends State<MusicDjProgramPage> {
  late double _imageWidth;
  late double _imageHeight;
  @override
  void initState() {
    _imageWidth = Inchs.adapter(90);
    _imageHeight = _imageWidth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicPerDjProgramViewModel>(
      viewModel: MusicPerDjProgramViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.djPersonalizeds.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildContent(viewModel.djPersonalizeds)],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            S.of(context).recommended_dj,
            style: AppTheme.titleStyle(context),
          ),
          QYButtom(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4),
            height: 26,
            title: Text(S.of(context).more),
            imageAlignment: ImageAlignment.right,
            image: Icon(
              Icons.chevron_right,
              size: 20,
              color: AppTheme.subtitleColor(context),
            ),
            imageMargin: 0,
            border: Border.all(color: AppTheme.iconColor(context)),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_) {
              Navigator.of(context).pushNamed(MyRouterName.dj);
            },
          )
        ]));
  }

  Widget _buildContent(List<MusicDjPersonalized> djPersonalizeds) {
    return Container(
      height: _imageHeight + 40,
      child: ListView(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        scrollDirection: Axis.horizontal,
        children: djPersonalizeds.map((e) => _buildContentItem(e)).toList(),
      ),
    );
  }

  Widget _buildContentItem(MusicDjPersonalized djPersonalized) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击');
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: _imageWidth,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      djPersonalized.picUrl, _imageWidth, _imageHeight,
                      ),
                  radius: _imageWidth / 2,
                  width: _imageWidth,
                  height: _imageHeight,
                ),
                Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 40,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            QYSpacing(
              height: 4,
            ),
            Text(
              djPersonalized.name ?? '',
              maxLines: 1,
              style: AppTheme.titleStyle(context).copyWith(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
