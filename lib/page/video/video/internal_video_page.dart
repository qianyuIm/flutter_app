import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_icon.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/model/music/video_category.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/video/internal_video_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class InternalVideoPage extends StatefulWidget {
  final VideoCategory category;

  const InternalVideoPage({Key? key, required this.category}) : super(key: key);

  @override
  _InternalVideoPageState createState() => _InternalVideoPageState();
}

class _InternalVideoPageState extends State<InternalVideoPage>
    with AutomaticKeepAliveClientMixin {
  InternalVideoViewModel? _viewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    LogUtil.v('${widget.category.name} => 初始化了');
    super.initState();
  }

  @override
  void dispose() {
    LogUtil.v('${widget.category.name} => 移除了');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ProviderWidget<InternalVideoViewModel>(
        viewModel: InternalVideoViewModel(widget.category.categoryId),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          _viewModel = viewModel;
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError && viewModel.videos.isEmpty) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: viewModel.initData);
          } else if (viewModel.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }

          return SmartRefresher(
            enablePullUp: true,
            controller: viewModel.refreshController,
            onRefresh: viewModel.refresh,
            onLoading: viewModel.loadMore,
            child: WaterfallFlow.builder(
              padding: EdgeInsets.only(
                  left: Inchs.left, right: Inchs.right, top: 10),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext c, int index) {
                return _buildItem(viewModel.videos[index], index);
              },
              itemCount: viewModel.videos.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(InternalVideo video, int index) {
    final itemColor = AppTheme.cardColor(context);
    return InkWell(
      onTap: () {
        if (_viewModel != null) {
          Navigator.of(context)
              .pushNamed(MyRouterName.music_vertical_video, arguments: {
            'categoryId': widget.category.categoryId,
            'videos': _viewModel!.videos,
            'initialIndex': index
          });
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: itemColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(video),
            QYSpacing(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3, right: 3),
              child: Text(
                video.itemTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.titleStyle(context),
              ),
            ),
            QYSpacing(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                video.itemSubTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.subtitleCopyStyle(context,fontSize: 12),
              ),
            ),
            QYSpacing(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(InternalVideo video) {
    final maxWidth = (Inchs.screenWidth - Inchs.left - Inchs.right - 8) / 2;
    final maxHeight = video.itemImageHeight(maxWidth);
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageLoadView(
          imagePath: ImageCompressHelper.musicCompress(
              video.itemPicUrl, maxWidth, maxHeight),
          shape: BoxShape.rectangle,
          width: maxWidth,
          height: maxHeight,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            height: 30,
            color: Colors.black26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      StringHelper.formateNumber(video.data?.playTime),
                      style: AppTheme.subtitleCopyStyle(context,color: Colors.white, fontSize: 11)
                          ,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Icon(
                      QyIcon.icon_praise,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      StringHelper.formateNumber(video.data?.praisedCount),
                      style: AppTheme.subtitleCopyStyle(context,
                          color: Colors.white, fontSize: 11),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                ),
                Text(
                  TimeHelper.getTimeStamp(video.data?.durationms),
                  style:
                      AppTheme.subtitleCopyStyle(context, color: Colors.white),
                ),
                // SizedBox(width: 3,),
              ],
            ),
          ),
        )
      ],
    );
  }
}
