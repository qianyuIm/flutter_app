import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_top_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicTopAlbumContainerPage extends StatefulWidget {
  @override
  _MusicTopAlbumContainerPageState createState() =>
      _MusicTopAlbumContainerPageState();
}

class _MusicTopAlbumContainerPageState extends State<MusicTopAlbumContainerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_buildTabs(), Expanded(child: _buildBody())],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppTheme.scaffoldBackgroundColor(context),
      height: 48,
      child: TabBar(controller: _tabController, onTap: (value) {}, tabs: [
        Tab(
          text: S.of(context).all,
        ),
        Tab(
          text: S.of(context).zh,
        ),
        Tab(
          text: S.of(context).ea,
        ),
        Tab(
          text: S.of(context).kr,
        ),
        Tab(
          text: S.of(context).jp,
        )
      ]),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        MusicTopAlbumItemPage(
          area: 'ALL',
        ),
        MusicTopAlbumItemPage(
          area: 'ZH',
        ),
        MusicTopAlbumItemPage(
          area: 'EA',
        ),
        MusicTopAlbumItemPage(
          area: 'KR',
        ),
        MusicTopAlbumItemPage(
          area: 'JP',
        ),
      ],
    );
  }
}

class MusicTopAlbumItemPage extends StatefulWidget {
  final String area;

  const MusicTopAlbumItemPage({Key? key, required this.area}) : super(key: key);

  @override
  _MusicTopAlbumItemPageState createState() => _MusicTopAlbumItemPageState();
}

class _MusicTopAlbumItemPageState extends State<MusicTopAlbumItemPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicTopAlbumViewModel>(
      viewModel: MusicTopAlbumViewModel(widget.area),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty || viewModel.albums.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        final imageWidth =
            (Inchs.screenWidth - 2 * Inchs.left - 2 * Inchs.sp10) / 3;
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          controller: viewModel.refreshController,
          onLoading: viewModel.loadMore,
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: Inchs.left, vertical: Inchs.sp10),
            itemCount: viewModel.albums.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: imageWidth + 50,
                mainAxisSpacing: Inchs.sp10,
                crossAxisSpacing: Inchs.sp10),
            itemBuilder: (context, index) {
              return _buildItem(viewModel.albums[index], imageWidth);
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(MusicAlbum album, double imageSize) {
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击专辑');
      },
      child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
                album.picUrl, imageSize, imageSize),
            width: imageSize,
            height: imageSize,
            radius: 10,
          ),
          QYSpacing(height: 4,),
          Expanded(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                QYSpacing(height: 2,),
                Text(album.artist?.name ?? '',maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
              ],
            ),
          ))
        ],
      )),
    );
    
  }
}
