import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/category_item.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/locale_helper.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/page/video/mv/internal_mv_page.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

typedef InternalMvMenuChange = void Function(bool isShow);

class InternalMvMenuPageController extends ChangeNotifier {
  bool isShow = false;
  bool isHideAnimation = false;
  void show() {
    isShow = true;
    notifyListeners();
  }

  void hide({bool isHideAnimation = true}) {
    this.isHideAnimation = isHideAnimation;
    isShow = false;
    notifyListeners();
  }
}

class InternalMvMenuPage extends StatefulWidget {
  final InternalMvMenuPageController menuPageController;
  final InternalMvMenuChange? menuChanging;
  final InternalMvMenuChange? menuChanged;
  final int requestArea;
  final int requestType;
  final int requestOrder;
  final Function(int index) areaSelectedCall;
  final Function(int index) typeSelectedCall;
  final Function(int index) orderSelectedCall;
  const InternalMvMenuPage(
      {Key? key,
      required this.menuPageController,
      this.menuChanging,
      this.menuChanged,
      required this.requestArea,
      required this.requestType,
      required this.requestOrder,
      required this.areaSelectedCall,
      required this.typeSelectedCall,
      required this.orderSelectedCall})
      : super(key: key);

  @override
  _InternalMvMenuPageState createState() => _InternalMvMenuPageState();
}

class _InternalMvMenuPageState extends State<InternalMvMenuPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _heightAnimation;
  bool _isShowMenuItem = false;
  late int _requestArea;
  late int _requestType;
  late int _requestOrder;

  @override
  void initState() {
    _requestArea = widget.requestArea;
    _requestType = widget.requestType;
    _requestOrder = widget.requestOrder;

    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    widget.menuPageController.addListener(_menuPageControllerChange);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.menuPageController.removeListener(_menuPageControllerChange);
    _heightAnimation?.removeListener(_heightAnimationListener);
    _heightAnimation?.removeStatusListener(_heightAnimationStatusListener);
    super.dispose();
  }

  /// 状态改变
  void _menuPageControllerChange() {
    _isShowMenuItem = !_isShowMenuItem;
    widget.menuChanging?.call(_isShowMenuItem);
    _heightAnimation?.removeListener(_heightAnimationListener);
    _heightAnimation?.removeStatusListener(_heightAnimationStatusListener);
    _heightAnimation =
        Tween(begin: 0.0, end: 50.0).animate(_animationController)
          ..addListener(_heightAnimationListener)
          ..addStatusListener(_heightAnimationStatusListener);
    if (widget.menuPageController.isShow) {
      _animationController.forward();
    } else if (widget.menuPageController.isHideAnimation) {
      _animationController.reverse();
    } else {
      _animationController.value = 0;
    }
  }

  /// 高度改变
  void _heightAnimationListener() {}
  void _heightAnimationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        widget.menuChanged?.call(false);
        break;
      case AnimationStatus.completed:
        widget.menuChanged?.call(true);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            color: AppTheme.cardColor(context),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: Inchs.left, right: Inchs.right),
                  height: _heightAnimation?.value,
                  child: _buildHeaderItem(MusicApi.mvAllAreaSupport, (index) {
                    LogUtil.v('点击了');
                    _requestArea = index;
                    widget.areaSelectedCall.call(_requestArea);
                    setState(() {});
                  }, _requestArea),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: Inchs.left, right: Inchs.right),
                  height: _heightAnimation?.value,
                  child: _buildHeaderItem(MusicApi.mvAllTypeSupport, (index) {
                    LogUtil.v('点击了');
                    _requestType = index;
                    widget.typeSelectedCall.call(_requestType);

                    setState(() {});
                  }, _requestType),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: Inchs.left, right: Inchs.right),
                  height: _heightAnimation?.value,
                  child: _buildHeaderItem(MusicApi.mvAllOrderSupport, (index) {
                    LogUtil.v('点击了');
                    _requestOrder = index;
                    widget.orderSelectedCall.call(_requestOrder);
                    setState(() {});
                  }, _requestOrder),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderItem(
      Map<int, CategoryItem> map, Function(int index) selectedCall, int index) {
    return Container(
      height: 0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: map.keys.map((key) {
            if (key == -1) {
              return Center(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    LocaleHelper.localeString(map[key]!.titleValue!,map[key]!.titleKey!),
                    style: AppTheme.titleStyle(context),
                  ),
                ),
              );
            } else {
              return InternalMvCategoryItem(
                isSelected: index == key,
                selectedCall: (index) {
                  // LogUtil.v('点击了');
                  selectedCall.call(index);
                },
                title: LocaleHelper.localeString(map[key]!.titleValue!,map[key]!.titleKey!),
                index: key,
              );
            }
          }).toList()),
    );
  }
}
