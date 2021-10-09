import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_artist_mv_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:ui' as ui;

class MusicArtistMVPage extends StatefulWidget {
  final int artistId;
  final String? coverUrl;

  const MusicArtistMVPage({Key? key, required this.artistId, this.coverUrl})
      : super(key: key);

  @override
  _MusicArtistMVPageState createState() => _MusicArtistMVPageState();
}

class _MusicArtistMVPageState extends State<MusicArtistMVPage>
    with AutomaticKeepAliveClientMixin {
  double kPadding = Inchs.left;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicArtistMvViewModel>(
      viewModel: MusicArtistMvViewModel(widget.artistId),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        final imageWidth = (Inchs.screenWidth - 3 * Inchs.left) / 2;
        final imageHeight = 204 * imageWidth / 164;
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          controller: viewModel.refreshController,
          onLoading: viewModel.loadMore,
          child: GridView.builder(
            padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
            itemCount: viewModel.mvs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: imageHeight,
                mainAxisSpacing: Inchs.left,
                crossAxisSpacing: Inchs.left),
            itemBuilder: (context, index) {
              return _buildItem(viewModel.mvs[index], imageWidth, imageHeight);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(MusicMV mv, double width, double height) {
    return MusicArtistMVItem(
      mv: mv,
      imageWidth: width,
      imageHeight: height,
      coverUrl: widget.coverUrl,
    );
  }
}

class MusicArtistMVItem extends StatelessWidget {
  final MusicMV mv;
  final double imageWidth;
  final double imageHeight;
  final String? coverUrl;

  const MusicArtistMVItem(
      {Key? key,
      required this.mv,
      required this.imageWidth,
      required this.imageHeight,
      this.coverUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        LogUtil.v('点击mv');
        // Navigator.of(context).pushNamed(MyRouterName.music_vertical_video);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: _buildBlueImage(context),
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
              mv.imgurl, imageWidth, imageHeight),
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
                mv.imgurl16v9, imageWidth, centerHeight),
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
                QYButtom(
                  padding: EdgeInsets.zero,
                  title: Text(
                    '${StringHelper.formateNumber(mv.playCount)}',
                    style:
                        AppTheme.subtitleStyle(context).copyWith(color: color),
                  ),
                  image: Icon(
                    Icons.play_circle_outlined,
                    color: color,
                  ),
                ),
                Text(
                  '${TimeHelper.getTimeStamp(mv.duration)}',
                  style: AppTheme.subtitleStyle(context).copyWith(color: color),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Text(
              mv.name ?? '',
              style: AppTheme.subtitleStyle(context)
                  .copyWith(fontSize: 16, color: color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }

  
}
