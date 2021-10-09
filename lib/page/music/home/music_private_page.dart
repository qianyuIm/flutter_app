import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/model/music/home/music_privatecontent.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

/// 独家放送
class MusicPrivatePage extends StatefulWidget {
  @override
  _MusicPrivatePageState createState() => _MusicPrivatePageState();
}

class _MusicPrivatePageState extends State<MusicPrivatePage> {
  late double _imageWidth;
  late double _imageHeight;
  @override
  void initState() {
    _imageWidth = Inchs.screenWidth / 2;
    _imageHeight = 344 * _imageWidth / 611;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return ProviderWidget<MusicPrivateViewModel>(
      viewModel: MusicPrivateViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.privateContents.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildContent(viewModel.privateContents)],
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
            S.of(context).enter_private,
            style: AppTheme.titleStyle(context),
          ),
          QYButtom(
            absorbOnMove: true,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4),
            height: 26,
            title: Text(S.of(context).more),
            imageAlignment: ImageAlignment.right,
            image: Icon(
              Icons.chevron_right,
              color: AppTheme.subtitleColor(context),
              size: 20,
            ),
            imageMargin: 0,
            border: Border.all(color: AppTheme.iconColor(context)),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_) {},
          )
        ]));
  }

  Widget _buildContent(List<MusicPrivateContent> privateContents) {
    return Container(
      height: _imageHeight + 50,
      child: ListView(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        scrollDirection: Axis.horizontal,
        children: privateContents.map((e) => _buildContentItem(e)).toList(),
      ),
    );
  }

  Widget _buildContentItem(MusicPrivateContent privateContent) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击');
      },
      child: Container(
        padding: EdgeInsets.only(right: 8),
        width: _imageWidth,
        child: Column(
          children: [
            Stack(
              children: [
                ImageLoadView(
                  imagePath: privateContent.sPicUrl ?? '',
                  radius: 5,
                  width: _imageWidth,
                  height: _imageHeight,
                ),
                Positioned(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            QYSpacing(height: 6,),
            Text(
              privateContent.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
