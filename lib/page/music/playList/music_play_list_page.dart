import 'package:colour/colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_playlist_categorie.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MusicPlaylistPage extends StatefulWidget {
  final MusicPlaylistCategorie category;

  const MusicPlaylistPage({Key? key, required this.category}) : super(key: key);

  @override
  _MusicPlaylistPageState createState() => _MusicPlaylistPageState();
}

class _MusicPlaylistPageState extends State<MusicPlaylistPage>
    with AutomaticKeepAliveClientMixin {
  late double _imageWidthHeight;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _imageWidthHeight = Inchs.screenWidth - Inchs.left - Inchs.right;
    _imageWidthHeight = _imageWidthHeight - 12;
    _imageWidthHeight = _imageWidthHeight / 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ProviderWidget<MusicPlaylistViewModel>(
        viewModel: MusicPlaylistViewModel(widget.category.name),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError && viewModel.playLists.isEmpty) {
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
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext c, int index) {
                return _buildItem(viewModel.playLists[index], index);
              },
              itemCount: viewModel.playLists.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(MusicPlayList playList, int index) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        Navigator.of(context)
            .pushNamed(MyRouterName.play_list_detail, arguments: playList.id);
      },
      child: Container(
        height: _imageWidthHeight + 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(playList),
            QYSpacing(
              height: 4,
            ),
            Expanded(
                child: Text(
              playList.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildImage(MusicPlayList playList) {
    return Stack(
      children: [
        ImageLoadView(
            radius: 10,
            width: _imageWidthHeight,
            height: _imageWidthHeight,
            imagePath: ImageCompressHelper.musicCompress(
                playList.coverImgUrl, _imageWidthHeight, _imageWidthHeight)),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colour('333333', 0.5),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 16),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    StringHelper.formateNumber(playList.playCount),
                    style: AppTheme.subtitleStyle(context)
                        .copyWith(fontSize: 12, color: Colors.white),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
