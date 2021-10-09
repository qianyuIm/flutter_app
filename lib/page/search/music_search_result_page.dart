import 'package:expandable/expandable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/rich_text_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/search/music_search_result_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/clear_ink_well.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicSearchResultComprehensivePage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultComprehensivePage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultComprehensivePageState createState() =>
      _MusicSearchResultComprehensivePageState();
}

class _MusicSearchResultComprehensivePageState
    extends State<MusicSearchResultComprehensivePage> with AutomaticKeepAliveClientMixin  {
 @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      alignment: Alignment.center,
      child: Text('待完成!!!!!!!!!',style: AppTheme.titleStyle(context),)
    );
  }
}

class MusicSearchResultSongPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultSongPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);

  @override
  _MusicSearchResultSongPageState createState() =>
      _MusicSearchResultSongPageState();
}

class _MusicSearchResultSongPageState extends State<MusicSearchResultSongPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.songs.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            controller: viewModel.refreshController,
            onRefresh: viewModel.refresh,
            onLoading: viewModel.loadMore,
            child: CustomScrollView(
              slivers: [_buildPinned(), _buildList(viewModel.songs)],
            ));
      },
    );
  }

  Widget _buildPinned() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          maxHeight: 44,
          minHeight: 44,
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
            child: Row(
              children: [
                QYButtom(
                  padding: EdgeInsets.zero,
                  imageMargin: 8,
                  image: Icon(
                    Icons.play_circle_outline,
                  ),
                  title: Text(
                    '播放全部',
                    style: AppTheme.titleStyle(context),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildList(List<MusicSong> songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, int index) => _buildSongItem(songs[index]),
          childCount: songs.length),
    );
  }

  Widget _buildSongItem(MusicSong song) {
    return ClearInkWell(
      onTap: () {
        LogUtil.v('点击');
      },
      child: Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      children: RichTextHelper.multiInlineSpan(
                          context, song.name ?? '', widget.keyword)),
                ),
                QYSpacing(
                  height: 6,
                ),
                _buildSubItemTitle(song)
              ],
            ),
            QYButtom(
              onPressed: (state) {
                LogUtil.v('点击更多');
              },
              image: Image.asset(
                ImageHelper.wrapMusicPng('music_play_list_more',
                    ),
                width: 24,
                color: AppTheme.subtitleColor(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubItemTitle(MusicSong song) {
    var artistName = song.artists?.first.name ?? '';
    var albumName = song.album?.name ?? '';
    List<InlineSpan> inlineSpans =
        RichTextHelper.multiInlineSpan(context, albumName, widget.keyword);
    inlineSpans.insert(0,
        TextSpan(text: artistName, style: AppTheme.subtitleStyle(context)));
    inlineSpans.insert(
        1, TextSpan(text: ' - ', style: AppTheme.subtitleStyle(context)));
    return RichText(
      text: TextSpan(children: inlineSpans),
    );
  }
}

class MusicSearchResultAlbumPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultAlbumPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultAlbumPageState createState() =>
      _MusicSearchResultAlbumPageState();
}

class _MusicSearchResultAlbumPageState extends State<MusicSearchResultAlbumPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.albums.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.albums.length,
            itemBuilder: (context, index) {
              return _buildAlbumItem(viewModel.albums[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildAlbumItem(MusicAlbum album) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      // color: Colors.red,
      child: Row(
        children: [
          ImageLoadView(
              radius: 10,
              width: 50,
              height: 50,
              imagePath:
                  ImageCompressHelper.musicCompress(album.picUrl, 50, 50)),
          QYSpacing(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      children: RichTextHelper.multiInlineSpan(
                          context, album.name ?? '', widget.keyword)),
                ),
                QYSpacing(
                  height: 4,
                ),
                _buildAlbumSubTitle(album)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAlbumSubTitle(MusicAlbum album) {
    var size = '${album.size}首音乐';
    var artistName = ' by ' + (album.artist?.name ?? '');
    var publishTime =
        TimeHelper.formatDateMs(album.publishTime, format: 'yyyy-MM-dd');
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          text: size,
          style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
          children: [
            TextSpan(
                text: artistName,
                style:
                    AppTheme.subtitleStyle(context).copyWith(fontSize: 12)),
            TextSpan(text: ' ,  '),
            TextSpan(
                text: publishTime,
                style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12))
          ]),
    );
  }
}

class MusicSearchResultArtistPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultArtistPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultArtistPageState createState() =>
      _MusicSearchResultArtistPageState();
}

class _MusicSearchResultArtistPageState
    extends State<MusicSearchResultArtistPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.artists.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.artists.length,
            itemBuilder: (context, index) {
              return _buildArtistItem(viewModel.artists[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildArtistItem(MusicArtist artist) {
    var mainColor = artist.followed
        ? AppTheme.subtitleColor(context)
        : AppTheme.primaryColor(context);
    return ClearInkWell(
      onTap: () {
        LogUtil.v('点击歌手');
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildPic(artist.picUrl),
                QYSpacing(
                  width: 8,
                ),
                _buildName(artist.name ?? ''),
              ],
            ),
            QYButtom(
              width: 70,
              height: 30,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              title: Text(
                '+ 关注',
                style: AppTheme.subtitleStyle(context)
                    .copyWith(color: mainColor),
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: mainColor),
              onPressed: (state) {
                LogUtil.v('点击关注');
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPic(String? picUrl) {
    return ImageLoadView(
        width: 50,
        height: 50,
        radius: 25,
        imagePath: ImageCompressHelper.musicCompress(picUrl, 50, 50));
  }

  Widget _buildName(String name) {
    return Text(
      name,
      style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
    );
  }
}

class MusicSearchResultPlaylistPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultPlaylistPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultPlaylistPageState createState() =>
      _MusicSearchResultPlaylistPageState();
}

class _MusicSearchResultPlaylistPageState
    extends State<MusicSearchResultPlaylistPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.playlists.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.playlists.length,
            itemBuilder: (context, index) {
              return _buildPlaylistItem(viewModel.playlists[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildPlaylistItem(MusicPlayList playList) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          ImageLoadView(
              radius: 10,
              width: 50,
              height: 50,
              imagePath: ImageCompressHelper.musicCompress(
                  playList.coverImgUrl, 50, 50)),
          QYSpacing(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      children: RichTextHelper.multiInlineSpan(
                          context, playList.name ?? '', widget.keyword)),
                ),
                QYSpacing(
                  height: 4,
                ),
                _buildPlaylistSubTitle(playList)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylistSubTitle(MusicPlayList playList) {
    var size = '${playList.trackCount}首音乐';
    var artistName = ' by ' + (playList.creator?.nickname ?? '');
    var playCount = '播放${StringHelper.formateNumber(playList.playCount)}次';
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          text: size,
          style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
          children: [
            TextSpan(
                text: artistName,
                style:
                    AppTheme.subtitleStyle(context).copyWith(fontSize: 12)),
            TextSpan(text: ' ,  '),
            TextSpan(
                text: playCount,
                style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12))
          ]),
    );
  }
}

class MusicSearchResultUserprofilePage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultUserprofilePage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultUserprofilePageState createState() =>
      _MusicSearchResultUserprofilePageState();
}

class _MusicSearchResultUserprofilePageState
    extends State<MusicSearchResultUserprofilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.userprofiles.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.userprofiles.length,
            itemBuilder: (context, index) {
              return _buildUserprofileItem(viewModel.userprofiles[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildUserprofileItem(MusicUserProfile userProfile) {
    var mainColor = userProfile.followed
        ? AppTheme.subtitleColor(context)
        : AppTheme.primaryColor(context);
    return ClearInkWell(
      onTap: () {
        LogUtil.v('点击用户');
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageLoadView(
                radius: 10,
                width: 50,
                height: 50,
                imagePath: ImageCompressHelper.musicCompress(
                    userProfile.avatarUrl, 50, 50)),
            Expanded(child: _buildMidle(userProfile)),
            QYButtom(
              width: 70,
              height: 30,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              title: Text(
                '+ 关注',
                style: AppTheme.subtitleStyle(context)
                    .copyWith(color: mainColor),
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: mainColor),
              onPressed: (state) {
                LogUtil.v('点击关注');
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMidle(MusicUserProfile userProfile) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      children: RichTextHelper.multiInlineSpan(context,
                          userProfile.nickname ?? '', widget.keyword))),
              userProfile.gender.image
            ],
          ),
          if (userProfile.signature.isNotEmpty)
            QYSpacing(
              height: 4,
            ),
          if (userProfile.signature.isNotEmpty)
            Text(
              userProfile.signature,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
        ],
      ),
    );
  }
}

class MusicSearchResultLyricPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultLyricPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultLyricPageState createState() =>
      _MusicSearchResultLyricPageState();
}

class _MusicSearchResultLyricPageState extends State<MusicSearchResultLyricPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.songs.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.songs.length,
            itemBuilder: (context, index) {
              return _buildLyricItem(viewModel.songs[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildLyricItem(MusicSong song) {
    return ExpandableNotifier(
      child: Container(
          color: AppTheme.cardColor(context),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(song), _buildLyricContainer(song)],
          )),
    );
  }

  Widget _buildHeader(MusicSong song) {
    return Row(
      children: [
        Expanded(child: _buildHeaderLeading(song)),
        if (song.hasMV)
          QYButtom(
            padding: const EdgeInsets.all(4),
            onPressed: (state) {
              LogUtil.v('点击MV');
            },
            image: Image.asset(
              ImageHelper.wrapMusicPng('music_play_list_video',
                  ),
              width: 24,
            ),
          ),
        QYButtom(
          onPressed: (state) {
            LogUtil.v('点击歌词更多');
          },
          image: Image.asset(
            ImageHelper.wrapMusicPng('music_play_list_more',
                ),
            width: 24,
            color: AppTheme.subtitleColor(context),
          ),
        )
      ],
    );
  }

  Widget _buildHeaderLeading(MusicSong song) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.title,
            style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
          ),
          Text(song.subTitle)
        ],
      ),
    );
  }

  Widget _buildLyricContainer(MusicSong song) {
    return ScrollOnExpand(
      child: Container(
        child: Column(
          children: [
            Expandable(
              collapsed: _buildCollapsedLyric(song),
              expanded: _buildExpandedLyric(song),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    var controller =
                        ExpandableController.of(context, required: true)!;
                    return TextButton(
                      child: Text(
                        controller.expanded ? "收起歌词" : "展开歌词",
                        style: AppTheme.subtitleStyle(context),
                      ),
                      onPressed: () {
                        controller.toggle();
                      },
                    );
                  },
                ),
                ExpandableButton(
                  child: ExpandableIcon(
                    theme: ExpandableThemeData(
                      expandIcon: Icons.expand_more,
                      collapseIcon: Icons.expand_more,
                      iconColor: AppTheme.subtitleColor(context),
                      iconSize: 24.0,
                      iconPadding: EdgeInsets.only(right: 5),
                      hasIcon: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedLyric(MusicSong song) {
    Widget? lyric = _buildLyric(song.lyrics);
    if (lyric == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageHelper.wrapMusicPng('music_search_lyric'),
            width: 20,
            color: AppTheme.subtitleColor(context),
          ),
          QYSpacing(
            width: 8,
          ),
          lyric
        ],
      ),
    );
  }

  Widget _buildExpandedLyric(MusicSong song) {
    Widget? lyric = _buildLyric(song.lyrics, isExpanded: true);
    if (lyric == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageHelper.wrapMusicPng('music_search_lyric'),
            width: 20,
            color: AppTheme.subtitleColor(context),
          ),
          QYSpacing(
            width: 8,
          ),
          lyric
        ],
      ),
    );
  }

// https://github.com/fluttercandies/extended_text
  Widget? _buildLyric(MusicSearchLyrics? lyrics, {bool isExpanded = false}) {
    if (lyrics == null) return null;
    if (lyrics.txt.isEmpty) return null;
    if (ListOptionalHelper.hasValue(lyrics.range)) {
      var lyricsList = lyrics.lyrics;
      List<InlineSpan>? children = [];
      if (isExpanded) {
        var prefixLyric = lyrics.txt.substring(0, lyrics.range!.first.first);
        var prefixInlineSpan = TextSpan(
            text: prefixLyric, style: AppTheme.subtitleStyle(context));
        children.add(prefixInlineSpan);
      }
      LogUtil.v('https://github.com/fluttercandies/extended_text');
      int suffix = 0;
      for (var range in lyrics.range!) {
        suffix = range.first;
        var target = lyrics.txt.substring(range.first, range.second);
        var index =
            lyricsList.indexWhere((element) => element.contains(target));
        var lyric = lyricsList[index];

        var inlineSpan = RichTextHelper.multiInlineSpan(context, lyric, target);
        suffix += lyric.length;
        children.addAll(inlineSpan);
      }
      var suffixLyric = lyrics.txt.substring(suffix).trimRight();
      var suffixInlineSpan =
          TextSpan(text: suffixLyric, style: AppTheme.subtitleStyle(context));
      children.add(suffixInlineSpan);
      return RichText(
          maxLines: isExpanded ? null : 3,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(children: children));
    }
    return Text(
      lyrics.txt,
      maxLines: isExpanded ? null : 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MusicSearchResultDJRadioPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultDJRadioPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultDJRadioPageState createState() =>
      _MusicSearchResultDJRadioPageState();
}

class _MusicSearchResultDJRadioPageState
    extends State<MusicSearchResultDJRadioPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.djRadios.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.djRadios.length,
            itemBuilder: (context, index) {
              return _buildDJRadioItem(viewModel.djRadios[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildDJRadioItem(MusicDjRadio djRadio) {
    return ClearInkWell(
      onTap: () {
        LogUtil.v('点击电台');
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            ImageLoadView(
                radius: 10,
                width: 50,
                height: 50,
                imagePath:
                    ImageCompressHelper.musicCompress(djRadio.picUrl, 50, 50)),
            QYSpacing(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        children: RichTextHelper.multiInlineSpan(
                            context, djRadio.name ?? '', widget.keyword)),
                  ),
                  QYSpacing(
                    height: 4,
                  ),
                  _buildPlaylistSubTitle(djRadio)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistSubTitle(MusicDjRadio djRadio) {
    var size = '${djRadio.programCount}个声音';
    var artistName = ' by ' + (djRadio.dj?.nickname ?? '');
    var playCount = '播放${StringHelper.formateNumber(djRadio.playCount)}次';
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          text: size,
          style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
          children: [
            TextSpan(
                text: artistName,
                style:
                    AppTheme.subtitleStyle(context).copyWith(fontSize: 12)),
            TextSpan(text: ' ,  '),
            TextSpan(
                text: playCount,
                style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12))
          ]),
    );
  }
}

class MusicSearchResultVideoPage extends StatefulWidget {
  final MusicSearchType searchType;
  final String keyword;

  const MusicSearchResultVideoPage(
      {Key? key, required this.searchType, required this.keyword})
      : super(key: key);
  @override
  _MusicSearchResultVideoPageState createState() =>
      _MusicSearchResultVideoPageState();
}

class _MusicSearchResultVideoPageState extends State<MusicSearchResultVideoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicSearchResultViewModel>(
      viewModel: MusicSearchResultViewModel(widget.searchType, widget.keyword),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.videos.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: true,
          controller: viewModel.refreshController,
          onRefresh: viewModel.refresh,
          onLoading: viewModel.loadMore,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
            itemCount: viewModel.videos.length,
            itemBuilder: (context, index) {
              return _buildVideoItem();
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoItem() {
    return Container(
      margin: EdgeInsets.all(8),
      height: 40,
      color: Colors.red,
    );
  }
}
