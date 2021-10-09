import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_artist_detail.dart';
import 'package:flutter_app/page/music/artist/music_artist_album_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_dj_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_event_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_home_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_song_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_mv_page.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_secondary_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/bottom_clipper.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/expansion_widget.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

import 'package:flutter_app/widget/qy_spacing.dart';

/// 歌手页面
class MusicArtistPage extends StatefulWidget {
  final int artistId;

  const MusicArtistPage({Key? key, required this.artistId}) : super(key: key);

  @override
  _MusicArtistPageState createState() => _MusicArtistPageState();
}

class _MusicArtistPageState extends State<MusicArtistPage>
    with SingleTickerProviderStateMixin {
  /// 突出的高度
  double _prominentTopHeight = 56;
  TabController? _tabController;
  bool _isExpanded = false;
  final ValueNotifier<int> _tapNotifier = ValueNotifier(0);
  int number = 0;
  MusicSimiArtistViewModel? simiArtistViewModel;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProviderWidget2<MusicArtistViewModel, MusicSimiArtistViewModel>(
      viewModel1: MusicArtistViewModel(widget.artistId),
      viewModel2: MusicSimiArtistViewModel(widget.artistId),
      onModelReady: (viewModel1, viewModel2) {
        viewModel1.initData();
        viewModel2.initData();
      },
      builder: (context, viewModel1, viewModel2, child) {
        simiArtistViewModel = viewModel2;
        if (viewModel1.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel1.isError) {
          return ViewStateErrorWidget(
              error: viewModel1.viewStateError!,
              onPressed: viewModel1.initData);
        } else if (viewModel1.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel1.initData);
        }

        /// 判断tab展示
        bool isAll =
            IntOptionalHelper.hasValue(viewModel1.artistDetail.eventCount);
        if (_tabController == null) {
          _tabController = TabController(length: isAll ? 6 : 4, vsync: this);
        }
        Widget tabs = isAll
            ? _buildAllTabs(viewModel1.artistDetail)
            : _buildPartTabs(viewModel1.artistDetail);
        Widget body = isAll
            ? _buildAllBodys(viewModel1.artistDetail.user?.userId ?? 0,
                viewModel1.artistId, viewModel1.artistDetail.artist?.cover)
            : _buildPartBodys(
                viewModel1.artistId, viewModel1.artistDetail.artist?.cover);
        bool hasUser = viewModel1.artistDetail.user != null;

        ///TODO: Temporary fix, wait for https://github.com/flutter/flutter/issues/54059 to be fixed
        // return My.NestedScrollView(
        return NestedScrollView(
          // physics: const BouncingScrollPhysics(
          //     parent: const AlwaysScrollableScrollPhysics()),
          // stretchHeaderSlivers: false,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildHeader(viewModel1.artistDetail, hasUser),
              _buildProminentCard(viewModel1.artistDetail, hasUser),
              tabs
            ];
          },
          body: body,
        );
      },
    ));
  }

  Widget _buildHeader(MusicArtistDetail artistDetail, bool hasUser) {
    var imageWidth = Inchs.screenWidth;
    var imageHeight = 151 * imageWidth / 185;

    return SliverAppBar(
        backgroundColor: AppTheme.appBarTheme(context).backgroundColor,
        title: Text('${widget.artistId}'),
        pinned: true,
        stretch: true,
        expandedHeight: imageHeight,
        flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              child: Stack(
                alignment: Alignment.topCenter,
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppTheme.scaffoldBackgroundColor(context),
                  ),
                  ClipPath(
                    clipper: BottomClipper(_prominentTopHeight - 16),
                    child: ImageLoadView(
                      imagePath: ImageCompressHelper.musicCompress(
                          artistDetail.artist?.cover, imageWidth, imageHeight),
                      width: imageWidth,
                      height: imageHeight,
                    ),
                  ),
                  Positioned(
                    left: Inchs.left,
                    bottom: 0,
                    right: Inchs.right,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.cardColor(context),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      width: Inchs.screenWidth,
                      height: _prominentTopHeight,
                    ),
                  ),
                  _buildProminentTop(artistDetail, hasUser)
                ],
              ),
            )));
  }

  Widget _buildProminentTop(MusicArtistDetail artistDetail, bool hasUser) {
    if (hasUser) {
      return Positioned(
        left: (Inchs.screenWidth - 80) / 2,
        bottom: 20,
        child: Container(
          width: 80,
          height: 80,
          child: ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
                artistDetail.user?.avatarUrl, 100, 100),
            radius: 40,
          ),
        ),
      );
    }
    return Positioned(
      bottom: 10,
      child: Text(
        artistDetail.artist?.name ?? '',
        style: AppTheme.titleStyle(context).copyWith(fontSize: 22),
      ),
    );
  }

  /// 突出部分
  Widget _buildProminentCard(MusicArtistDetail artistDetail, bool hasUser) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        decoration: BoxDecoration(
            color: AppTheme.cardColor(context),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        child: Column(
          children: [
            if (hasUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artistDetail.artist?.name ?? '',
                    style: AppTheme.titleStyle(context).copyWith(fontSize: 22),
                  ),
                  QYSpacing(
                    width: 4,
                  ),
                  ImageLoadView(
                    imagePath:
                        artistDetail.user?.avatarDetail?.identityIconUrl ?? '',
                    width: 20,
                    height: 20,
                  )
                ],
              ),
            Text(artistDetail.user?.description ?? ''),
            QYSpacing(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QYButtom(
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  width: 100,
                  height: 30,
                  color: AppTheme.primaryColor(context),
                  title: Text(
                    S.of(context).artist_follow,
                    style: AppTheme.subtitleStyle(context).copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                QYSpacing(
                  width: 4,
                ),
                ExpandIcon(
                  padding: EdgeInsets.all(6),
                  expandedColor: AppTheme.primaryColor(context),
                  isExpanded: _isExpanded,
                  onPressed: (value) {
                    number += 1;
                    _tapNotifier.value = number;
                  },
                )
              ],
            ),
            ExpansionWidget(
              onExpansionChanged: (value) {
                setState(() {
                  _isExpanded = value;
                });
              },
              tapNotifier: _tapNotifier,
              children: [
                _buildSimiArtists(artistDetail),
              ],
            ),
            // _buildSimiArtists(artistDetail),
            QYSpacing(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  /// 相似歌手
  Widget _buildSimiArtists(MusicArtistDetail artistDetail) {
    if (simiArtistViewModel!.isBusy) {
      return ViewStateBusyWidget();
    } else if (simiArtistViewModel!.isError) {
      return ViewStateErrorWidget(
          error: simiArtistViewModel!.viewStateError!,
          onPressed: simiArtistViewModel!.initData);
    } else if (simiArtistViewModel!.isEmpty) {
      return ViewStateEmptyWidget(onPressed: simiArtistViewModel!.initData);
    }
    return MusicSimiArtist(
      simiArtists: simiArtistViewModel!.artists,
    );
  }

  /// 部分tab
  Widget _buildPartTabs(MusicArtistDetail artistDetail) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          minHeight: 48,
          maxHeight: 48,
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            height: 48,
            width: Inchs.screenWidth,
            child: TabBar(
                controller: _tabController,
                onTap: (value) {},
                isScrollable: false,
                tabs: [
                  _buildTabItem(S.of(context).artist_home),
                  _buildTabItem(S.of(context).artist_song),
                  _buildTabItem(S.of(context).artist_album,
                      number: StringHelper.intString(
                          artistDetail.artist?.albumSize)),
                  _buildTabItem(S.of(context).artist_mv,
                      number:
                          StringHelper.intString(artistDetail.artist?.mvSize)),
                ]),
          )),
    );
  }

  Widget _buildPartBodys(int artistId, String? coverUrl) {
    return TabBarView(controller: _tabController, children: [
      MusicArtistHomePage(),
      MusicArtistSongPage(artistId: artistId),
      MusicArtistAlbumPage(artistId: artistId),
      MusicArtistMVPage(
        artistId: artistId,
        coverUrl: coverUrl,
      ),
    ]);
  }

  /// 全部tabs
  Widget _buildAllTabs(MusicArtistDetail artistDetail) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          minHeight: 48,
          maxHeight: 48,
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            height: 48,
            width: Inchs.screenWidth,
            child: TabBar(
                controller: _tabController,
                onTap: (value) {},
                isScrollable: true,
                tabs: [
                  _buildTabItem(S.of(context).artist_home),
                  _buildTabItem(S.of(context).artist_song),
                  _buildTabItem(S.of(context).artist_album,
                      number: StringHelper.intString(
                          artistDetail.artist?.albumSize)),
                  _buildTabItem(S.of(context).artist_event,
                      number: StringHelper.omit(artistDetail.eventCount)),
                  _buildTabItem(S.of(context).artist_blog),
                  _buildTabItem(S.of(context).artist_mv,
                      number:
                          StringHelper.intString(artistDetail.artist?.mvSize)),
                ]),
          )),
    );
  }

  Widget _buildAllBodys(int uid, int artistId, String? coverUrl) {
    return TabBarView(controller: _tabController, children: [
      MusicArtistHomePage(),
      MusicArtistSongPage(artistId: artistId),
      MusicArtistAlbumPage(artistId: artistId),
      MusicArtistEventPage(
        uid: uid,
      ),
      MusicArtistDJPage(),
      MusicArtistMVPage(
        artistId: artistId,
        coverUrl: coverUrl,
      ),
    ]);
  }

  Widget _buildTabItem(String tabName, {String number = ''}) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tabName),
          Text(
            number,
            style: AppTheme.subtitleStyle(context).copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class MusicSimiArtist extends StatelessWidget {
  final List<MusicArtist> simiArtists;
  const MusicSimiArtist({Key? key, required this.simiArtists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.v('来了');
    return Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: simiArtists.length,
          itemBuilder: (context, index) {
            return _buildSimiArtistItem(context, simiArtists[index]);
          },
        ));
  }

  Widget _buildSimiArtistItem(BuildContext context, MusicArtist artist) {
    var color = AppTheme.primaryColor(context);
    return Container(
      width: 100,
      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: BoxDecoration(
          color: color.withAlpha(50),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(artist.picUrl, 50, 50),
            width: 50,
            height: 50,
            radius: 25,
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Text(
              artist.fullName(),
              style: AppTheme.titleStyle(context).copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '${StringHelper.formateNumber(artist.fansCount)}粉丝',
            style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
          ),
          SizedBox(
            height: 4,
          ),
          QYButtom(
            absorbOnMove: true,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            width: 70,
            height: 28,
            color: Colors.white,
            title: Text(
              S.of(context).artist_follow,
              style: AppTheme.subtitleStyle(context)
                  .copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color),
          ),
        ],
      ),
    );
  }
}
