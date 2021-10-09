import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/page/search/music_search_bar.dart';
import 'package:flutter_app/page/search/music_search_result_page.dart';
import 'package:flutter_app/view_model/search/music_search_result_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/clear_ink_well.dart';

/// 搜索类型
const Map<MusicSearchType, String> _allSearchTypes = {
  MusicSearchType.comprehensive: '综合',
  MusicSearchType.songs: '单曲',
  MusicSearchType.albums: '专辑',
  MusicSearchType.artists: '歌手',
  MusicSearchType.playlists: '歌单',
  // MusicSearchType.mvs: 'MV',
  MusicSearchType.videos: '视频',
  MusicSearchType.lyrics: '歌词',
  MusicSearchType.djRadios: '电台',
  MusicSearchType.userprofiles: '用户',
};

class MusicSearchResultContainer extends StatefulWidget {
  final String searchWord;

  const MusicSearchResultContainer({Key? key, required this.searchWord})
      : super(key: key);

  @override
  _MusicSearchResultContainerState createState() =>
      _MusicSearchResultContainerState();
}

class _MusicSearchResultContainerState extends State<MusicSearchResultContainer>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late TabController _tabController;

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.text = widget.searchWord;
    _tabController = TabController(length: _allSearchTypes.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: Inchs.screenWidth,
      height: Inchs.navigation_height + Inchs.statusBarHeight,
      padding: EdgeInsets.only(left: 8, right: Inchs.right),
      child: Column(
        children: [
          SizedBox(
            height: Inchs.statusBarHeight,
          ),
          Expanded(
            child: Row(
              children: [
                ClearInkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                Expanded(
                    child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildSearchBar(context),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: ClearInkWell(
                              onTap: () {
                                LogUtil.v('返回');
                                Navigator.of(context).pop({
                                  'searchWord': widget.searchWord,
                                  'showKeyBoard': true
                                });
                              },
                            ),
                          ),
                          Expanded(child: ClearInkWell(
                            onTap: () {
                              LogUtil.v('清空并返回');
                              Navigator.of(context).pop({'showKeyBoard': true});
                            },
                          ))
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// searchBar
  Widget _buildSearchBar(BuildContext context) {
    return MusicSearchBar(
      controller: _textController,
      topSafeArea: false,
      showCancel: false,
      loadHint: false,
      enabled: false,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildContainer() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
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
            tabs: _allSearchTypes.values
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            MusicSearchResultComprehensivePage(
              searchType: MusicSearchType.songs,
              keyword: widget.searchWord,
            ),
            MusicSearchResultSongPage(
              searchType: MusicSearchType.songs,
              keyword: widget.searchWord,
            ),
            MusicSearchResultAlbumPage(
              searchType: MusicSearchType.albums,
              keyword: widget.searchWord,
            ),
            MusicSearchResultArtistPage(
              searchType: MusicSearchType.artists,
              keyword: widget.searchWord,
            ),
            MusicSearchResultPlaylistPage(
              searchType: MusicSearchType.playlists,
              keyword: widget.searchWord,
            ),



            MusicSearchResultVideoPage(
              searchType: MusicSearchType.videos,
              keyword: widget.searchWord,
            ),
            MusicSearchResultLyricPage(
              searchType: MusicSearchType.lyrics,
              keyword: widget.searchWord,
            ),
            MusicSearchResultDJRadioPage(
              searchType: MusicSearchType.djRadios,
              keyword: widget.searchWord,
            ),
            MusicSearchResultUserprofilePage(
              searchType: MusicSearchType.userprofiles,
              keyword: widget.searchWord,
            ),
          ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(child: _buildContainer()),
        ],
      ),
    );
  }
}
