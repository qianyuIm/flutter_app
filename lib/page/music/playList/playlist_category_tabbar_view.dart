

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class PlaylistCategoryTabbarView extends StatefulWidget {
  final int itemCount;
  final List<MusicPlaylistSelectedItem> items;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final int initialIndex;
  final void Function()? onPressed;
  final ValueChanged<int>? onPositionChange;
  const PlaylistCategoryTabbarView({
    Key? key,
    required this.itemCount,
    required this.items,
    required this.tabBuilder,
    required this.pageBuilder,
    this.initialIndex = 0,
    this.onPressed,
    this.onPositionChange,
  }) : super(key: key);
  @override
  _PlaylistCategoryTabbarViewState createState() => _PlaylistCategoryTabbarViewState();
}

class _PlaylistCategoryTabbarViewState extends State<PlaylistCategoryTabbarView> 
with TickerProviderStateMixin {
  late TabController _tabController;
  late double _left;
  String? _lastItemName;
  @override
  void initState() {
    _left = widget.itemCount > 3 ? 20 : 50;
    _tabController = TabController(
        initialIndex: widget.initialIndex,
        length: widget.itemCount,
        vsync: this);

    _tabController.addListener(onPositionChange);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(onPositionChange);
    _tabController.dispose();
    LogUtil.v('InternalCategoryTabBarView =>>>>>>移除了');
    super.dispose();
  }

  @override
  void didUpdateWidget(PlaylistCategoryTabbarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _tabController.removeListener(onPositionChange);
      _tabController.dispose();
      _left = widget.itemCount > 3 ? 20 : 50;

      /// 查找初始化的位置
      var initialIndex = 0;
      if (_lastItemName != null) {
        initialIndex = widget.items
            .map((e) => e.category.name)
            .toList()
            .indexOf(_lastItemName!);
        initialIndex = initialIndex < 0 ? 0 : initialIndex;
      }
      _lastItemName = null;
      _tabController = TabController(
          initialIndex:
              0,
          length: widget.itemCount,
          vsync: this);
      _tabController.addListener(onPositionChange);
      setState(() {});
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _tabController.animateTo(initialIndex);
      });
    }
  }

  void onPositionChange() {
    if (_tabController.index == _tabController.animation?.value) {
      _lastItemName = widget.items[_tabController.index].category.name;
      widget.onPositionChange?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: _left, right: 50),
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
                  tabs: List.generate(widget.itemCount,
                      (index) => widget.tabBuilder(context, index))),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => widget.onPressed?.call(),
                icon: Icon(
                  Icons.add,
                  color: AppTheme.titleColor(context),
                  size: 30,
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: List.generate(widget.itemCount,
                  (index) => widget.pageBuilder(context, index))),
        )
      ],
    );
  }}