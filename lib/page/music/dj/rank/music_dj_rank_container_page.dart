import 'package:flutter/material.dart';
import 'package:flutter_app/page/music/dj/rank/music_dj_program_rank_page.dart';
import 'package:flutter_app/page/music/dj/rank/music_dj_rank_page.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

/// 类型
const _tab_titles = ['声音榜', '主播榜'];

/// 主播榜 -》 新人 最热 每日
///
/// 排行榜
class MusicDJRankContainerPage extends StatefulWidget {
  @override
  _MusicDJRankContainerPageState createState() =>
      _MusicDJRankContainerPageState();
}

class _MusicDJRankContainerPageState extends State<MusicDJRankContainerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tab_titles.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: TabBar(
          controller: _tabController,
          onTap: (value) {
            _tabController.animateTo(value);
          },
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: AppTheme.titleColor(context),
          unselectedLabelColor: AppTheme.subtitleColor(context),
          labelStyle: AppTheme.titleStyle(context),
          unselectedLabelStyle: AppTheme.subtitleStyle(context),
          indicatorWeight: 3,
          tabs: _tab_titles
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
        )),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MusicDJProgramRankPage(),
          MusicDJRankPage(),
        ],
      ),
    );
  }
}
