import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/page/music/home/music_banner_page.dart';
import 'package:flutter_app/page/music/home/music_calendar_page.dart';
import 'package:flutter_app/page/music/home/music_category_page.dart';
import 'package:flutter_app/page/music/home/music_dj_program.dart';
import 'package:flutter_app/page/music/home/music_personalized_mv.dart';
import 'package:flutter_app/page/music/home/music_personalized_new_song.dart';
import 'package:flutter_app/page/music/home/music_private_page.dart';
import 'package:flutter_app/page/music/home/music_recommend_play_list.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';

/// 音乐
class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin {
  

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildBanner(),
          _buildCategoryItem(),
          _buildRecommendPlayListPage(),
          _buildPrivatePage(),
          _buildPersonalizedNewSongPage(),
          _buildPersonalizedMVPage(),
          _buildDjProgramPage(),
          _buildCalendar()
        ],
      ),
    );
  }

  /// appbar
  Widget _buildAppBar() {
    return SliverAppBar(
      title: Text(S.of(context).tabMusic),
      pinned: true,
      actions: [
        
        QYBounce(
          onPressed: () {
            Navigator.of(context).pushNamed(MyRouterName.app_setting);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Inchs.right),
            child: Icon(Icons.search,size: 26,color: AppTheme.iconColor(context),),
          ),
        )
      ],
    );
  }

  /// banner
  Widget _buildBanner() {
    return SliverToBoxAdapter(child: MusicBannerPage());
  }

  /// categoryItem
  Widget _buildCategoryItem() {
    return SliverToBoxAdapter(
      child: MusicCategoryPage(),
    );
  }

  /// 推荐歌单
  Widget _buildRecommendPlayListPage() {
    return SliverToBoxAdapter(
      child: MusicRecommendPlayListPage(),
    );
  }
  /// 独家放送
  Widget _buildPrivatePage() {
    return SliverToBoxAdapter(
      child: MusicPrivatePage(),
    );
  }
  /// 推荐新音乐
  Widget _buildPersonalizedNewSongPage() {
    return SliverToBoxAdapter(
      child: MusicPersonalizedNewSongPage(),
    );
  }
  /// 推荐mv
  Widget _buildPersonalizedMVPage() {
    return SliverToBoxAdapter(
      child: MusicPersonalizedMvPage(),
    );
  }
  /// 推荐 电台
  Widget _buildDjProgramPage() {
    return SliverToBoxAdapter(
      child: MusicDjProgramPage(),
    );
  }
  
  /// 音乐日历
  Widget _buildCalendar() {
    return SliverToBoxAdapter(
      child: MusicCalendarPage(),
    );
  }
}
