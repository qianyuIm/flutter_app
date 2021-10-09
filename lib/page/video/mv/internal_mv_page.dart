import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/category_item.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_icon.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/locale_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/page/video/mv/internal_mv_menu_page.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/video/internal_mv_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui' as ui;

class InternalMVPage extends StatefulWidget {
  @override
  _InternalMVPageState createState() => _InternalMVPageState();
}

class _InternalMVPageState extends State<InternalMVPage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 0;
  double _previousOpacity = -1;
  late InternalMvMenuPageController _menuPageController;
  int _requestArea = 0;
  int _requestType = 0;
  int _requestOrder = 2;
  late double _maxWidth;
  late double _imageHeight;
  late double _crossAxisSpacing;
  InternalMvViewModel? _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _menuPageController = InternalMvMenuPageController();
    _crossAxisSpacing = 6;
    _maxWidth =
        (Inchs.screenWidth - Inchs.left - Inchs.right - _crossAxisSpacing) / 2;
    _imageHeight = 204 * _maxWidth / 164;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: ProviderWidget<InternalMvViewModel>(
      viewModel: InternalMvViewModel(),
      onModelReady: (viewModel) =>
          viewModel.initData(_requestArea, _requestType, _requestOrder),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.mvs.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!,
              onPressed: viewModel.initData(
                  _requestArea, _requestType, _requestOrder));
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(
              onPressed: viewModel.initData(
                  _requestArea, _requestType, _requestOrder));
        }
        _viewModel = viewModel;
        var area = LocaleHelper.localeString(
                              MusicApi
                                  .mvAllAreaSupport[_requestArea]!.titleValue!,
                              MusicApi
                                  .mvAllAreaSupport[_requestArea]!.titleKey!);
        var type = LocaleHelper.localeString(
                              MusicApi
                                  .mvAllAreaSupport[_requestType]!.titleValue!,
                              MusicApi
                                  .mvAllAreaSupport[_requestType]!.titleKey!);
    var order = LocaleHelper.localeString(
                              MusicApi
                                  .mvAllAreaSupport[_requestOrder]!.titleValue!,
                              MusicApi
                                  .mvAllAreaSupport[_requestOrder]!.titleKey!);

        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.depth == 0 &&
                    notification is ScrollUpdateNotification) {
                  _opacity = notification.metrics.pixels / 150;
                  _opacity = (_opacity < 0) ? 0 : (_opacity > 1 ? 1 : _opacity);
                  if (_previousOpacity != _opacity) {
                    setState(() {});
                  }
                  if (_menuPageController.isShow) {
                    _menuPageController.hide();
                  }
                  _previousOpacity = _opacity;
                }
                return false;
              },
              child: SmartRefresher(
                  enablePullUp: true,
                  controller: viewModel.refreshController,
                  onRefresh: viewModel.refresh,
                  onLoading: viewModel.loadMore,
                  child: CustomScrollView(
                    slivers: [
                      _buildHeader(),
                      _buildlist(viewModel.mvs),
                    ],
                  )),
            ),
            IgnorePointer(
              ignoring: _opacity == 0,
              child: Opacity(
                  opacity: _opacity,
                  child: InkWell(
                    onTap: () {
                      if (_menuPageController.isShow) {
                        _menuPageController.hide();
                      } else {
                        _menuPageController.show();
                      }
                    },
                    child: Container(
                      height: 50,
                      color: AppTheme.cardColor(context),
                      child: Center(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$area . $type . $order'),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            QyIcon.icon_arrow_down,
                            size: 16,
                            color: AppTheme.subtitleColor(context),
                          ),
                        ],
                      )),
                    ),
                  )),
            ),
            InternalMvMenuPage(
              menuPageController: _menuPageController,
              requestArea: _requestArea,
              requestType: _requestType,
              requestOrder: _requestOrder,
              areaSelectedCall: (int index) {
                _menuPageController.hide();
                _requestArea = index;
                _viewModel?.area = index;
                setState(() {});
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  _viewModel?.refreshController.requestRefresh();
                });
              },
              typeSelectedCall: (int index) {
                _menuPageController.hide();
                _requestType = index;
                _viewModel?.type = index;
                setState(() {});
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  _viewModel?.refreshController.requestRefresh();
                });
              },
              orderSelectedCall: (int index) {
                _menuPageController.hide();
                _requestOrder = index;
                _viewModel?.order = index;
                setState(() {});
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  _viewModel?.refreshController.requestRefresh();
                });
              },
            ),
          ],
        );
      },
    ));
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(child: _buildHeaderContent());
  }

  Widget _buildHeaderContent() {
    return Container(
      color: AppTheme.cardColor(context),
      padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
      child: Column(
        children: [
          _buildHeaderItem(MusicApi.mvAllAreaSupport, (index) {
            LogUtil.v('点击了');
            _requestArea = index;
            _viewModel?.area = index;
            setState(() {});
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              _viewModel?.refreshController.requestRefresh();
            });
          }, _requestArea),
          _buildHeaderItem(MusicApi.mvAllTypeSupport, (index) {
            LogUtil.v('点击了');
            _requestType = index;
            _viewModel?.type = index;
            setState(() {});
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              _viewModel?.refreshController.requestRefresh();
            });
          }, _requestType),
          _buildHeaderItem(MusicApi.mvAllOrderSupport, (index) {
            LogUtil.v('点击了');
            _requestOrder = index;
            _viewModel?.order = index;
            setState(() {});
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              _viewModel?.refreshController.requestRefresh();
            });
          }, _requestOrder),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(
      Map<int, CategoryItem> map, Function(int index) selectedCall, int index) {
    return Container(
      height: 50,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: map.keys.map((key) {
            if (key == -1) {
              return Center(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    LocaleHelper.localeString(
                        map[key]!.titleValue!, map[key]!.titleKey!),
                    style: AppTheme.titleStyle(context),
                  ),
                ),
              );
            } else {
              return InternalMvCategoryItem(
                isSelected: index == key,
                selectedCall: (index) {
                  LogUtil.v('点击了');
                  selectedCall.call(index);
                },
                title: LocaleHelper.localeString(
                    map[key]!.titleValue!, map[key]!.titleKey!),
                index: key,
              );
            }
          }).toList()),
    );
  }

  Widget _buildlist(List<InternalMv> mvs) {
    return SliverPadding(
      padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _maxWidth,
            mainAxisSpacing: 10,
            crossAxisSpacing: _crossAxisSpacing,
            mainAxisExtent: _imageHeight + 60),
        delegate: SliverChildBuilderDelegate((context, index) {
          return InternalMvItem(
            internalMv: mvs[index],
            area: _requestArea,
            type: _requestType,
            order: _requestOrder,
            internalMVs: mvs,
            imageWidth: _maxWidth,
            imageHeight: _imageHeight,
            index: index,
          );
        }, childCount: mvs.length),
      ),
    );
  }
}

class InternalMvCategoryItem extends StatelessWidget {
  final bool isSelected;
  final Function(int index) selectedCall;
  final String title;
  final int index;

  const InternalMvCategoryItem(
      {Key? key,
      required this.isSelected,
      required this.selectedCall,
      required this.title,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleColor = AppTheme.titleColor(context);
    var subTitleColor = AppTheme.subtitleColor(context);
    var primaryColor = AppTheme.of(context).primaryColor.withAlpha(100);
    var color = isSelected ? titleColor : subTitleColor;
    return InkWell(
        onTap: () {
          if (!isSelected) {
            selectedCall.call(index);
          }
        },
        child: Container(
            child: Center(
                child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: Text(
            title,
            style: AppTheme.subtitleCopyStyle(context,color: color),
          ),
        ))));
  }
}

class InternalMvItem extends StatelessWidget {
  final InternalMv internalMv;
  final int area;
  final int order;
  final int type;
  final int index;
  final List<InternalMv> internalMVs;

  final double imageWidth;
  final double imageHeight;

  const InternalMvItem(
      {Key? key,
      required this.internalMv,
      required this.area,
      required this.order,
      required this.type,
      required this.index,
      required this.internalMVs,
      required this.imageWidth,
      required this.imageHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LogUtil.v('点击mv=> ${internalMv.id}');

        Navigator.of(context)
            .pushNamed(MyRouterName.music_vertical_mv, arguments: {
          'area': area,
          'order': order,
          'type': type,
          'internalMVs': internalMVs,
          'initialIndex': index
        });
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppTheme.cardColor(context),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              child: _buildBlueImage(context),
            ),
            Expanded(child: _buildContent(internalMv, context))
          ],
        ),
      ),
    );
  }

  Widget _buildBlueImage(BuildContext context) {
    double centerHeight = imageWidth * 9 / 16;
    final color = Colors.white.withAlpha(200);
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageLoadView(
          imagePath: ImageCompressHelper.musicCompress(
              internalMv.cover, imageWidth, imageHeight),
          width: imageWidth,
          height: imageHeight,
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              // child:
            ),
          ),
        ),
        Center(
            child: Container(
          child: ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
                internalMv.cover, imageWidth, centerHeight),
            width: imageWidth,
            height: centerHeight,
          ),
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.play_circle_outlined,
                      color: color,
                      size: 16,
                    ),
                    QYSpacing(
                      width: 4,
                    ),
                    Text(
                      '${StringHelper.formateNumber(internalMv.playCount)}',
                      style: AppTheme.subtitleCopyStyle(context,color: color)
                          ,
                    ),
                  ],
                ),
                Text(
                  '${TimeHelper.getTimeStamp(internalMv.duration)}',
                  style: AppTheme.subtitleCopyStyle(context,color: color),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(InternalMv mv, BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                mv.name ?? '',
                style: AppTheme.titleCopyStyle(context,fontSize: 15,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'by ${mv.artistName}',
              style: AppTheme.subtitleCopyStyle(context,fontSize: 12,),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
