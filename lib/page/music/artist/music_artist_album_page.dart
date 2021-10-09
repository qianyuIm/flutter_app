import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_artist_albums_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicArtistAlbumPage extends StatefulWidget {
  final int artistId;

  const MusicArtistAlbumPage({Key? key, required this.artistId})
      : super(key: key);
  @override
  _MusicArtistAlbumPageState createState() => _MusicArtistAlbumPageState();
}

class _MusicArtistAlbumPageState extends State<MusicArtistAlbumPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicArtistAlbumsViewModel>(
      viewModel: MusicArtistAlbumsViewModel(widget.artistId),
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
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          controller: viewModel.refreshController,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.albums.length,
            itemBuilder: (context, index) {
              return _buildItem(viewModel.albums[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(MusicAlbum album) {
    var time = TimeHelper.formatDateMs(album.publishTime, format: 'yyyy-MM-dd');
    var size = '${album.size}首';
    return InkWell(
      onTap: () {
        LogUtil.v('点击专辑跳转列表');
      },
      child: Container(
      margin: EdgeInsets.only(top: 4,bottom: 4),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 75,
                height: 85,
              ),
              Image.asset(
                ImageHelper.wrapMusicPng('music_artist_relation_album',
                   ),
                height: 10,
                width: 60,
              ),
              Positioned(
                top: 10,
                child: ImageLoadView(
                imagePath:
                    ImageCompressHelper.musicCompress(album.picUrl, 60, 60),
                width: 75,
                height: 75,
                radius: 10,
              ),
               )
            ],
          ),
          QYSpacing(
            width: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${album.name}'),
              Text('$time  $size'),
            ],
          )
        ],
      ),
    ),
    );
  }
}
