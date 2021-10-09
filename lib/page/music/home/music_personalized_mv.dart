import 'package:colour/colour.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';

class MusicPersonalizedMvPage extends StatefulWidget {
  @override
  _MusicPersonalizedMvPageState createState() =>
      _MusicPersonalizedMvPageState();
}

class _MusicPersonalizedMvPageState extends State<MusicPersonalizedMvPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicPersonalizedMVViewModel>(
      viewModel: MusicPersonalizedMVViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.perMVs.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildContent(viewModel.perMVs)],
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
            S.of(context).recommended_mv,
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
            onPressed: (_) {},
          )
        ]));
  }

  Widget _buildContent(List<MusicMV> perMVs) {
    return Container(
      height: Inchs.screenWidth - Inchs.left - Inchs.right,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        itemCount: perMVs.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: ((Inchs.screenWidth - 2 * Inchs.left)/ 2 ) - 8,
            // mainAxisExtent: 200,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8),
        itemBuilder: (context, index) {
          var perMv = perMVs[index];
          return _buildContentItem(perMv);
        },
      ),
    );
  }

  Widget _buildContentItem(MusicMV perMv) {
    final size = ((Inchs.screenWidth - 2 * Inchs.left)/ 2 ) - 8;
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击mv');
      },
      child: Stack(
      alignment: Alignment.center,
      children: [
        ImageLoadView(
          imagePath:
              ImageCompressHelper.musicCompress(perMv.picUrl, size, size),
          width: size,
          height: size,
          radius: 10,
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colour('333333', 0.4),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    StringHelper.formateNumber(perMv.playCount),
                    style: AppTheme.subtitleStyle(context)
                        .copyWith(fontSize: 12, color: Colors.white),
                  )
                ],
              )),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            decoration: BoxDecoration(
              color: Colour('333333', 0.4),
            ),
            child: Text(
              perMv.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.subtitleStyle(context).copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    ),
    );
  }
}
