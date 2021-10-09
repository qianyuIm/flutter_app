import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicDJPersonalizeRecommendPage extends StatefulWidget {
  @override
  _MusicDJPersonalizeRecommendPageState createState() =>
      _MusicDJPersonalizeRecommendPageState();
}

class _MusicDJPersonalizeRecommendPageState
    extends State<MusicDJPersonalizeRecommendPage> {
  late double _imageWidth;
  late double _imageHeight;
  @override
  void initState() {
    _imageWidth = Inchs.adapter(120);
    _imageHeight = _imageWidth;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicDJPersonalizeRecommendViewModel>(
      viewModel: MusicDJPersonalizeRecommendViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.djRadios.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildContent(viewModel.djRadios)],
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
            '个性化推荐',
            style: AppTheme.titleStyle(context),
          ),
        ]));
  }

  Widget _buildContent(List<MusicDjRadio> djRadios) {
    return Container(
      height: _imageHeight + 50,
      child: ListView(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        scrollDirection: Axis.horizontal,
        children: djRadios.map((e) => _buildContentItem(e)).toList(),
      ),
    );
  }

  Widget _buildContentItem(MusicDjRadio djRadio) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击');
      },
      child: Container(
        padding: EdgeInsets.only(right: 8),
        width: _imageWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      djRadio.picUrl, _imageWidth, _imageHeight),
                  radius: 5,
                  width: _imageWidth,
                  height: _imageHeight,
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 4, right: 4),
                      height: 20,
                      color: Colors.black.withAlpha(30),
                      child: Text(
                        djRadio.dj?.nickname ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.subtitleStyle(context)
                            .copyWith(color: Colors.white),
                      ),
                    )),
              ],
            ),
            QYSpacing(
              height: 4,
            ),
            Text(
              djRadio.rcmdText ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
