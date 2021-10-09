import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/page/music/dj/music_dj_banner_page.dart';
import 'package:flutter_app/page/music/dj/music_dj_category_page.dart';
import 'package:flutter_app/page/music/dj/music_dj_category_recommend.dart';
import 'package:flutter_app/page/music/dj/music_dj_personalize_recommend.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/view_model/scroll_controller_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/animated_widget.dart';

class MusicDjPage extends StatefulWidget {
  @override
  _MusicDjPageState createState() => _MusicDjPageState();
}

class _MusicDjPageState extends State<MusicDjPage> {
  late double _bannerHeight;
  late double _triggerHeight;
  @override
  void initState() {
    _bannerHeight = Inchs.screenWidth * 0.85 * 287 / 738;
    _triggerHeight = _bannerHeight - kToolbarHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProviderWidget<ScrollControllerViewModel>(
      viewModel: ScrollControllerViewModel(
          PrimaryScrollController.of(context), _triggerHeight),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) {
        return CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            _buildAppBar(viewModel),
            _buildCategoryPage(),
            _buildPersonalizeRecommendPage(),
            _buildCategoryRecommendPage(),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate((context, index) {
            //     return Container(
            //       margin: EdgeInsets.all(5),
            //       color: Colors.yellow,
            //       height: 40,
            //     );
            //   }, childCount: 100),
            // )
          ],
        );
      },
    ));
  }

  /// appbar
  Widget _buildAppBar(ScrollControllerViewModel viewModel) {
    return SliverAppBar(
        pinned: true,
        stretch: true,
        expandedHeight: _bannerHeight,
        leading: EmptyAnimatedSwitcher(
          display: viewModel.trigger,
          child: BackButton(),
        ),
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: _buildBanner(),
            title: EmptyAnimatedSwitcher(
                display: viewModel.trigger,
                child: Text(
                  '主播电台',
                  style: AppTheme.appBarTheme(context).titleTextStyle,
                ))));
  }

  /// _bannerHeight
  Widget _buildBanner() {
    return MusicDJBannerPage();
  }
  /// 分类
  Widget _buildCategoryPage() {
    return SliverToBoxAdapter(child: MusicDJCategoryPage(),);
  }
  /// 个性推荐
  Widget _buildPersonalizeRecommendPage() {
    return SliverToBoxAdapter(child: MusicDJPersonalizeRecommendPage());
  }
  /// 分类推荐
  Widget _buildCategoryRecommendPage() {
    return  MusicDJCategoryRecommendPage();
  }
}
