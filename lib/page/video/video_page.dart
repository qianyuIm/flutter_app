import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/page/video/mv/internal_mv_page.dart';
import 'package:flutter_app/page/video/video/internal_video_container_page.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/page_need_login.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

const int _kInitialIndex = 0;

class _VideoPageState extends State<VideoPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController =
        TabController(initialIndex: _kInitialIndex, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                tabs: [
              Tab(
                text: S.of(context).video,
              ),
              Tab(
                text: 'MV',
              )
            ])),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PageNeedLogin(
            builder: (context) {
              return InternalVideoContainerPage();
            },
          ),
          InternalMVPage(),
        ],
      ),
    );
  }
}
