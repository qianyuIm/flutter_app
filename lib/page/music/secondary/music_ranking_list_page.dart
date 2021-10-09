import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_ranking.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/page/music/bottom/bottom_player_box_controller.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_secondary_view_model.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

/// 排行榜
class MusicRankingListPage extends StatefulWidget {
  @override
  _MusicRankingListPageState createState() => _MusicRankingListPageState();
}

class _MusicRankingListPageState extends State<MusicRankingListPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  TabController? _tabController;
  Map<String, GlobalKey> _positionKeys = {};
  List<double> _positionHeights = [];
  double _allPositionHeight = 0;
  Map<int, double> _positionScope = {};

  /// 点击与滑动导致 tab计算错误
  bool isTap = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);

    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    /// 计算各个位置的高度
    if (_positionHeights.length != _positionKeys.length) {
      _positionKeys.forEach((key, value) {
        _positionHeights.add(getPositionHeight(value));
      });
      _positionHeights.forEach((element) {
        _allPositionHeight += element;
      });
      _positionScope = getPositionScope();
    }
    _tabController?.animateTo(calculateTabIndex(_scrollController.offset));
  }

  double getPositionHeight(GlobalKey key) {
    double height = 0;
    RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderSliverToBoxAdapter) {
      height = renderObject.child?.size.height ?? 0.0;
    } else {
      //如果用到其他RenderObject的子类这里需要加逻辑，
      print('=====如果用到其他RenderObject的子类这里需要加逻辑，=========');
    }
    return height;
  }

  /// 获取范围
  Map<int, double> getPositionScope() {
    Map<int, double> scope = {};
    double positionScope = 0;
    _positionHeights.asMap().forEach((key, value) {
      positionScope += value;
      scope[key] = positionScope;
    });
    return scope;
  }

  /// 计算位置
  int calculateTabIndex(double offset) {
    int tabIndex = _tabController!.index;
    if (isTap) return tabIndex;
    double beforePositionScope = 0;
    _positionScope.forEach((key, value) {
      if (offset < value && offset >= beforePositionScope) {
        tabIndex = key;
      }
      beforePositionScope = value;
    });
    LogUtil.v('tabIndex => $tabIndex');
    return tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).rank_list),
      ),
      body: ProviderWidget<MusicRankingViewModel>(
        viewModel: MusicRankingViewModel(),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: viewModel.initData);
          } else if (viewModel.isEmpty || viewModel.sections.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }
          if (_tabController == null) {
            _tabController =
                TabController(length: viewModel.sections.length, vsync: this);
          }
          if (viewModel.sections.length != _positionKeys.length) {
            _positionKeys.clear();
            viewModel.sections.forEach((element) {
              _positionKeys[element] = GlobalKey();
            });
          }
          return BottomPlayerBoxController(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildTabs(viewModel.sections),
                _buildOfficialSection(viewModel, viewModel.ranking),
                _buildGlobalSection(viewModel, viewModel.ranking),
                _buildArtistSection(viewModel, viewModel.ranking),
                _buildRewardSection(viewModel, viewModel.ranking)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(List<String> sections) {
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
              labelColor: AppTheme.titleColor(context),
              unselectedLabelColor: AppTheme.subtitleColor(context),
              labelStyle: AppTheme.titleStyle(context),
              unselectedLabelStyle: AppTheme.subtitleStyle(context),
              controller: _tabController,
              onTap: (value) {
                // _tabController?.animateTo(value);
                //通过循环计算offset
                if (_positionHeights.length != _positionKeys.length) {
                  _positionKeys.forEach((key, value) {
                    _positionHeights.add(getPositionHeight(value));
                  });
                  _positionHeights.forEach((element) {
                    _allPositionHeight += element;
                  });
                  _positionScope = getPositionScope();
                }
                double height = 0;
                for (int i = 0; i < value; i++) {
                  height += _positionHeights[i];
                }

                /// 与总高度对比
                height =
                    (height > _allPositionHeight - Inchs.screenHeight + 100)
                        ? (_allPositionHeight - Inchs.screenHeight + 100)
                        : height;
                // _scrollController.jumpTo(height.toDouble());
                isTap = true;
                _scrollController
                    .animateTo(height.toDouble(),
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear)
                    .then((value) {
                  LogUtil.v('改变状态 => $isTap');
                  isTap = false;
                });
              },
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: sections
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
            ),
          )),
    );
  }

  /// 官方榜
  Widget _buildOfficialSection(
      MusicRankingViewModel viewModel, MusicRanking ranking) {
    /// 是否有官方榜单
    if (!viewModel.hasOfficial) return SizedBox.shrink();

    /// 官方list
    var officialList = ranking.list!
        .where((element) => element.tracks?.isNotEmpty == true)
        .toList();

    return SliverToBoxAdapter(
        key: _positionKeys['官方榜'],
        child: Container(
          padding: EdgeInsets.only(
              left: Inchs.left, right: Inchs.right, top: 10),
          child: Column(
            children: [
              Container(
                  height: 40,
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          '官方榜',
                          style: AppTheme.titleStyle(context),
                        )
                      ],
                    ),
                  )),
              QYSpacing(
                height: 6,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: officialList.length,
                itemBuilder: (context, index) {
                  return _buildOfficialItem(officialList[index]);
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildOfficialItem(MusicRankingList list) {
    return InkWell(
      onTap: () {
        LogUtil.v('点击跳转');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 130,
        child: Row(
          children: [
            Stack(
              children: [
                ImageLoadView(
                    imagePath: ImageCompressHelper.musicCompress(
                        list.coverImgUrl, 120, 120),
                    width: 120,
                    height: 120,
                    radius: 5),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                            Colors.transparent,
                            Colors.black45
                          ])),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            list.updateFrequency ?? '',
                            style: AppTheme.subtitleStyle(context)
                                .copyWith(color: Colors.white),
                          ),
                          QYSpacing(
                            width: 4,
                          )
                        ],
                      )),
                )
              ],
            ),
            QYSpacing(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    _getTrack(list.tracks?[0], 0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _getTrack(list.tracks?[1], 1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _getTrack(list.tracks?[2], 2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Divider(
                    height: 0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getTrack(MusicTrack? track, int index) {
    return "${index + 1} ${track?.first} - ${track?.second}";
  }

  /// 全球榜
  Widget _buildGlobalSection(
      MusicRankingViewModel viewModel, MusicRanking ranking) {
    /// 是否有全球榜
    if (!viewModel.hasGlobal) return SizedBox.shrink();

    /// 全球list
    var globalList = ranking.list!
        .where((element) => element.tracks?.isEmpty == true)
        .toList();
    final width = (Inchs.screenWidth - Inchs.left - Inchs.right - 8) / 3;

    return SliverToBoxAdapter(
        key: _positionKeys['全球榜'],
        child: Container(
          padding: EdgeInsets.only(
              left: Inchs.left, right: Inchs.right, top: 10),
          child: Column(
            children: [
              Container(
                  height: 40,
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          '全球榜',
                          style: AppTheme.titleStyle(context),
                        )
                      ],
                    ),
                  )),
              QYSpacing(
                height: 6,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: globalList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: width + 30,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return _buildGlobalItem(globalList[index]);
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildGlobalItem(MusicRankingList list) {
    final width = (Inchs.screenWidth - Inchs.left - Inchs.right - 8) / 3;
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              ImageLoadView(
                  imagePath: ImageCompressHelper.musicCompress(
                      list.coverImgUrl, width, width),
                  width: width,
                  height: width,
                  radius: 5),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: const [
                          Colors.transparent,
                          Colors.black45
                        ])),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          list.updateFrequency ?? '',
                          style: AppTheme.subtitleStyle(context)
                              .copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        QYSpacing(
                          width: 4,
                        )
                      ],
                    )),
              )
            ],
          ),
          QYSpacing(
            height: 2,
          ),
          Center(
            child: Text('${list.name}',
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  /// 歌手榜
  Widget _buildArtistSection(
      MusicRankingViewModel viewModel, MusicRanking ranking) {
    /// 是否有歌手榜
    if (!viewModel.hasArtist) return SizedBox.shrink();
    var color = AppTheme.subtitleColor(context);
    var artistTop = ranking.artistToplist!;

    return SliverToBoxAdapter(
        key: _positionKeys['歌手榜'],
        child: Container(
          padding: EdgeInsets.only(
              left: Inchs.left, right: Inchs.right, top: 10),
          child: Column(
            children: [
              Container(
                  height: 40,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '歌手榜',
                          style: AppTheme.titleStyle(context),
                        ),
                        QYButtom(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 8, right: 4),
                          height: 28,
                          title: Text('更多'),
                          imageAlignment: ImageAlignment.right,
                          image: Icon(
                            Icons.chevron_right,
                            color: color,
                            size: 20,
                          ),
                          imageMargin: 0,
                          border: Border.all(color: color),
                          borderRadius: BorderRadius.circular(14),
                          onPressed: (_) {
                            Navigator.of(context).pushNamed(
                                MyRouterName.music_artist_ranking_list);
                          },
                        )
                      ],
                    ),
                  )),
              QYSpacing(
                height: 6,
              ),
              _buildArtistItem(artistTop),
            ],
          ),
        ));
  }

  Widget _buildArtistItem(MusicRankingArtistToplist artistTop) {
    return InkWell(
      onTap: () {
        LogUtil.v('点击跳转');
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        height: 130,
        child: Row(
          children: [
            Stack(
              children: [
                ImageLoadView(
                    imagePath: ImageCompressHelper.musicCompress(
                        artistTop.coverUrl, 120, 120),
                    width: 120,
                    height: 120,
                    radius: 5),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                            Colors.transparent,
                            Colors.black45
                          ])),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            artistTop.updateFrequency ?? '',
                            style: AppTheme.subtitleStyle(context)
                                .copyWith(color: Colors.white),
                          ),
                          QYSpacing(
                            width: 4,
                          )
                        ],
                      )),
                )
              ],
            ),
            QYSpacing(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(),
                  Text(
                    _getArtist(artistTop.artists?[0], 0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _getArtist(artistTop.artists?[1], 1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _getArtist(artistTop.artists?[2], 2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Divider(
                    height: 0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getArtist(MusicArtist? artist, int index) {
    return "${index + 1} ${artist?.first} - 热搜${artist?.third}";
  }

  /// 赞赏榜
  Widget _buildRewardSection(
      MusicRankingViewModel viewModel, MusicRanking ranking) {
    /// 是否有赞赏榜
    if (!viewModel.hasReward) return SizedBox.shrink();
    var songList = ranking.rewardToplist!.songs!;
    var color = AppTheme.subtitleColor(context);
    // var playerManager = MusicPlayerManager.of(context);
    return SliverToBoxAdapter(
        key: _positionKeys['赞赏榜'],
        child: Container(
          padding: EdgeInsets.only(
              left: Inchs.left, right: Inchs.right, top: 10),
          child: Column(
            children: [
              Container(
                  height: 40,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '赞赏榜',
                          style: AppTheme.titleStyle(context),
                        ),
                        QYButtom(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          height: 28,
                          title: Text('播放'),
                          image: Image.asset(
                            ImageHelper.wrapMusicPng(
                              'music_playing_play',
                            ),
                            width: 20,
                            color: color,
                          ),
                          imageMargin: 0,
                          border: Border.all(color: color),
                          borderRadius: BorderRadius.circular(14),
                          onPressed: (_) async {
                            if (songList.isNotEmpty) {
                              // await playerManager.update(
                              //     MusicPlayerManager.rewardSoleId,
                              //     songList,
                              //     0);
                            }
                          },
                        )
                      ],
                    ),
                  )),
              QYSpacing(
                height: 6,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return _buildRewardItem(songList, songList[index], index);
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildRewardItem(List<MusicSong> songs, MusicSong song, int index) {
    MusicPlayerManager playerManager =
        MusicPlayerManager.of(context, listen: true);
    return Container(
        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
        child: QYBounce(
          duration: Duration(milliseconds: 120),
          onPressed: () async {
            LogUtil.v('播放');

            if (songs.isNotEmpty) {
              // await playerManager.update(
              //     MusicPlayerManager.rewardSoleId, songs, index);
            }
          },
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ImageLoadView(
                    imagePath: ImageCompressHelper.musicCompress(
                        song.album?.picUrl, 60, 60),
                    width: 60,
                    height: 60,
                    radius: 5,
                  ),
                  if (playerManager.currentIndex == index)
                    Center(
                        child: Text(
                      '播放中..',
                      style: AppTheme.subtitleStyle(context)
                          .copyWith(color: Colors.red),
                    ))
                ],
              ),
              QYSpacing(
                width: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(song.title),
                    QYSpacing(
                      height: 4,
                    ),
                    Text(
                      song.subTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (song.hasMV == true)
                Image.asset(
                  ImageHelper.wrapMusicPng(
                    'music_play_list_video',
                  ),
                  width: 24,
                ),
              QYSpacing(
                width: 10,
              ),
            ],
          ),
        ));
  }
}
