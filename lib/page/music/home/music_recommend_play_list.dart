import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicRecommendPlayListPage extends StatefulWidget {
  
  @override
  _MusicRecommendPlayListPageState createState() =>
      _MusicRecommendPlayListPageState();
}

class _MusicRecommendPlayListPageState
    extends State<MusicRecommendPlayListPage> {
  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  /// 未登录
  Widget _buildWidget() {
    return ProviderWidget<MusicPersonalizedViewModel>(
      viewModel: MusicPersonalizedViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.personalizeds.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildItem(context, viewModel)],
        );
      },
    );
  }

  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
        Text(
          S.of(context).recommended_playlist,
          style: AppTheme.titleStyle(context),
        ),
        QYButtom(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4),
            height: 26,
            title: Text(S.of(context).more),
            imageAlignment: ImageAlignment.right,
            image: Icon(Icons.chevron_right,color: AppTheme.subtitleColor(context),size: 20,),
            imageMargin: 0,
            border: Border.all(color: AppTheme.iconColor(context)),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_)  {
              Navigator.of(context).pushNamed(MyRouterName.play_list_container);
            },
          )
      ]),
    );
  }

  Widget _buildItem(
      BuildContext context, MusicPersonalizedViewModel viewModel) {
    return Container(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding:
            EdgeInsets.only(left: Inchs.left - 6, right: Inchs.right, top: 4),
        children: viewModel.personalizeds
            .map((element) => QYBounce(
              absorbOnMove: true,
                  onPressed: () {
                    LogUtil.v('点击了');
                    Navigator.of(context).pushNamed(
                        MyRouterName.play_list_detail,
                        arguments: element.id);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 6),
                    width: Inchs.adapter(100),
                    child: Column(
                      children: [
                        ImageLoadView(
                          imagePath: ImageCompressHelper.musicCompress(
                              element.picUrl, 100, 100),
                          radius: 5,
                          width: Inchs.adapter(100),
                          height: Inchs.adapter(100),
                        ),
                        QYSpacing(
                          height: 6,
                        ),
                        Text(
                          element.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
