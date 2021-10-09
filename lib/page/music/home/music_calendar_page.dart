import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/page_need_login.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MusicCalendarPage extends StatefulWidget {
  @override
  _MusicCalendarPageState createState() => _MusicCalendarPageState();
}

class _MusicCalendarPageState extends State<MusicCalendarPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  MusicCalendarViewModel? _viewModel;

  @override
  void initState() {
    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);
    super.initState();
  }

  @override
  void dispose() {
    _viewModel?.destroy = true;
    _viewModel?.fadeController?.removeListener(_viewModel!.animationListener);
    _viewModel?.fadeController?.dispose();
    _viewModel?.streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageNeedLogin(
      unLoginBuilder: (context) {
        return SizedBox.shrink();
      },
      builder: (context) {
        return ProviderWidget<MusicCalendarViewModel>(
          viewModel: MusicCalendarViewModel(),
          onModelReady: (viewModel) => viewModel.initData(),
          builder: (context, viewModel, child) {
            _viewModel = viewModel;
            if (viewModel.isBusy) {
              return ViewStateBusyWidget();
            } else if (viewModel.isError && viewModel.calendars.isEmpty) {
              return ViewStateErrorWidget(
                  error: viewModel.viewStateError!,
                  onPressed: viewModel.initData);
            } else if (viewModel.isEmpty) {
              return ViewStateEmptyWidget(onPressed: viewModel.initData);
            }
            // if (viewModel.calendars.isEmpty) {
            //   return SizedBox.shrink();
            // }
            if (viewModel.fadeController == null) {
              viewModel.fadeController = _fadeController;
              viewModel.fadeAnimation = _fadeAnimation;
              viewModel.fadeController?.stop();
              viewModel.fadeController
                  ?.addListener(viewModel.animationListener);
            }
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 6),
              child: Column(
                children: [
                  _buildHeader(viewModel.calendars.length),
                  _buildContent(viewModel)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    var color = AppTheme.iconColor(context);
    var title = count > 0 ? '今日$count条' : '查看更多';
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '音乐日历',
        style: AppTheme.titleStyle(context),
      ),
      QYButtom(
        absorbOnMove: true,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10, right: 4),
        height: 26,
        title: Text(title),
        imageAlignment: ImageAlignment.right,
        image: Icon(
          Icons.chevron_right,
          size: 20,
        ),
        imageMargin: 0,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(13),
        onPressed: (_) {},
      )
    ]));
  }

  Widget _buildContent(MusicCalendarViewModel viewModel) {
    if (viewModel.calendars.isEmpty) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Text('今日暂无,查看更多'),
      );
    }
    var calendar = viewModel.calendars[viewModel.currentIndex];
    return VisibilityDetector(
      key: Key('_MusicCalendarPageState'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          _viewModel?.resumeClock();
        }
        if (info.visibleFraction == 0.0) {
          _viewModel?.pauseClock();
        }
      },
      child: Container(
          // color: Colors.black87,
          margin: EdgeInsets.only(top: 6),
          // height: 116,
          height: 120,
          child: Stack(
            children: [
              Positioned(
                  top: 15,
                  // top: 10,
                  child: Row(
                    children: [
                      Text(
                        '今天',
                      ),
                      QYSpacing(
                        width: 4,
                      ),
                      Text(calendar.tag ?? ''),
                    ],
                  )),
              Positioned(
                top: 40,
                // top: 60,
                child: FadeTransition(
                  opacity: _viewModel!.fadeAnimation!,
                  child: Container(
                    width: Inchs.screenWidth -
                        Inchs.left -
                        Inchs.right -
                        170,
                    child: Text(
                      calendar.title ?? '',
                      style: AppTheme.titleStyle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Positioned(
                // top: 10,
                top: 10,
                right: 0,
                child: imageSwitcher(viewModel),
              ),
            ],
          )),
    );
  }

  Widget imageSwitcher(MusicCalendarViewModel viewModel) {
    var opacityCalendar = viewModel.calendars[
        viewModel.currentIndex <= viewModel.calendars.length - 2
            ? viewModel.currentIndex + 1
            : 0];
    var visibleCalendar = viewModel.calendars[viewModel.visibleIndex];
    var fadeCalendar = viewModel.calendars[viewModel.currentIndex];

    return Container(
      width: 100,
      height: 100,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
                opacity: _viewModel!.opacity,
                child: ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      opacityCalendar.imgUrl, 80, 80),
                  width: 80,
                  height: 80,
                  // width: 130,
                  // height: 130,
                  radius: 5,
                )),
          ),

          ///fake
          Positioned(
            right: _viewModel!.right,
            bottom: _viewModel!.bottom,
            child: Visibility(
                visible: _viewModel!.visible,
                child: ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      visibleCalendar.imgUrl, 80, 80),
                  width: 80,
                  height: 80,
                  // width: 130,
                  // height: 130,
                  radius: 5,
                )),
          ),

          ///above
          Positioned(
            left: 0,
            top: 0,
            child: FadeTransition(
                opacity: _viewModel!.fadeAnimation!,
                child: ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      fadeCalendar.imgUrl, 80, 80),
                  width: 80,
                  height: 80,
                  // width: 130,
                  // height: 130,
                  radius: 5,
                )),
          ),
        ],
      ),
    );
  }
}
