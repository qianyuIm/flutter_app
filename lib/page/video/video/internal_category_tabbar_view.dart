import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/video/internal_video_view_model.dart';

/// TODO: 还是有bug 切换的时候位置刷新不理想 先这么用吧
class InternalCategoryTabBarView extends StatefulWidget {
  final int itemCount;
  final List<InternalVideoSelectedItem> items;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final int initialIndex;
  final void Function()? onPressed;
  final ValueChanged<int>? onPositionChange;
  const InternalCategoryTabBarView({
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
  _InternalCategoryTabBarViewState createState() =>
      _InternalCategoryTabBarViewState();
}

class _InternalCategoryTabBarViewState extends State<InternalCategoryTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late double _left;
  int? _lastItemId;
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
  void didUpdateWidget(InternalCategoryTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _tabController.removeListener(onPositionChange);
      _tabController.dispose();
      _left = widget.itemCount > 3 ? 20 : 50;

      /// 查找初始化的位置
      var initialIndex = 0;
      if (_lastItemId != null) {
        initialIndex = widget.items
            .map((e) => e.category.categoryId)
            .toList()
            .indexOf(_lastItemId!);
        initialIndex = initialIndex < 0 ? 0 : initialIndex;
      }
      _lastItemId = null;
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
      _lastItemId = widget.items[_tabController.index].category.categoryId;
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
  }
}
