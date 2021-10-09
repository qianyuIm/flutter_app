import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_daily_recommend.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music/music_transparent_flexible_space_bar.dart';
import 'package:flutter_app/widget/music/music_transparent_header.dart';
import 'package:flutter_app/widget/page_need_login.dart';

/// 每日推荐 => 歌曲
class MusicDailyRecommendPage extends StatefulWidget {
  @override
  _MusicDailyRecommendPageState createState() =>
      _MusicDailyRecommendPageState();
}

class _MusicDailyRecommendPageState extends State<MusicDailyRecommendPage> {
  @override
  Widget build(BuildContext context) {
    /// 获取登录状态
    return PageNeedLogin(
      builder: (context) {
        return Scaffold(
          body: ProviderWidget<MusicDailyRecommendViewModel>(
            viewModel: MusicDailyRecommendViewModel(),
            onModelReady: (viewModel) => viewModel.initData(),
            builder: (context, viewModel, child) {
              if (viewModel.isBusy) {
                return ViewStateBusyWidget();
              } else if (viewModel.isError) {
                return ViewStateErrorWidget(
                    error: viewModel.viewStateError!,
                    onPressed: () async {
                      /// 未登录
                      if (viewModel.viewStateError!.isUnauthorizedError) {
                        Navigator.of(context)
                            .pushNamed(MyRouterName.music_login,
                                arguments: MyRouterName.music_daily_recommend)
                            .then((_) {
                          final arguments =
                              ModalRoute.of(context)?.settings.arguments as Map;
                          final value = arguments[MyRouter.key];
                          if (value == MyRouter.value) {
                            viewModel.initData();
                          }
                        });
                      } else {
                        viewModel.initData();
                      }
                    });
              } else if (viewModel.isEmpty) {
                return ViewStateEmptyWidget(onPressed: viewModel.initData);
              }
              return CustomScrollView(
                slivers: [
                  _buildAppBar(viewModel.dailyRecommendItem),
                  _buildBody(viewModel.dailyRecommendItem)
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAppBar(MusicDailyRecommend dailyRecommendItem) {
    var topSong = dailyRecommendItem.dailySongs?.first;
    if (ListOptionalHelper.hasValue(dailyRecommendItem.recommendReasons)) {
      var reson = dailyRecommendItem.recommendReasons!.first;
      var tops = dailyRecommendItem.dailySongs
          ?.where((element) => element.id == reson.songId)
          .toList();
      if (ListOptionalHelper.hasValue(tops)) {
        topSong = tops!.first;
      }
    }

    return MusicTransparentHeader(
      stretch: true,
      title: Text('每日推荐'),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: AppTheme.appBarTheme(context)
          .titleTextStyle
          ?.copyWith(color: Colors.white),
      expandedHeight: 300,
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
                topSong?.album?.picUrl, 300, 300),
          ),
        ],
      ),
      content: Container(
        width: Inchs.screenWidth - 20 - 20,
        height: 40,
        color: Colors.red,
      ),
      contentPadding: EdgeInsets.only(left: 0, bottom: 30),
      stretchModes: [
        MusicTransparentStretchMode.fadeContent,
        MusicTransparentStretchMode.zoomBackground
      ],
    );
  }

  Widget _buildBody(MusicDailyRecommend dailyRecommendItem) {
    return SliverToBoxAdapter();
  }
}
