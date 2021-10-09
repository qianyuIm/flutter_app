import 'dart:ui';

import 'package:colour/colour.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/page/user/user_play_list_dialog.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/pulse_animation_widget.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:ink_page_indicator/ink_page_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 播放控制面板
Future<T> _showPlayingBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final result = await showCustomModalBottomSheet(
    expand: false,
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    ),
  );

  return result;
}

class PlayingDialogContentListKey extends ValueKey {
  const PlayingDialogContentListKey(this.type, {this.position})
      : super('_PlayingDialogContentListKey');

  /// 在list中所处的位置
  final int? position;
  final MusicPlayingListType type;
}

class MusicPlayingDialog extends StatelessWidget {
  static void show(BuildContext context) {
    _showPlayingBottomSheet(
      context: context,
      builder: (context) => MusicPlayingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MusicPlayerManager manager = MusicPlayerManager.of(context);
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: FutureBuilder<Map<MusicPlayingListType, List<MusicSong>>>(
          future: manager.getPlayingList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data ?? {};
              return MusicPlayingContent(
                data: data,
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: Inchs.adapter(500) - 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor(context),
                    ),
                  ),
                ),
              );
            }
            return Material();
          },
        ),
      ),
    );
  }
}

class MusicPlayingContent extends StatefulWidget {
  final Map<MusicPlayingListType, List<MusicSong>> data;
  const MusicPlayingContent({Key? key, required this.data}) : super(key: key);

  @override
  _MusicPlayingContentState createState() => _MusicPlayingContentState();
}

class _MusicPlayingContentState extends State<MusicPlayingContent> {
  late PageIndicatorController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageIndicatorController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Inchs.adapter(500),
      child: Column(
        children: [
          if (widget.data.length != 1) _buildIndicator(),
          QYSpacing(
            height: 5,
          ),
          Expanded(
              child: Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(12),
                  child: PageView.custom(
                    controller: _pageController,
                    childrenDelegate: SliverChildListDelegate(
                        widget.data.keys.map((type) {
                          var songs = widget.data[type]!;
                          return MusicPlayingContentItem(
                            type: type,
                            songs: songs,
                          );
                        }).toList(),
                        addAutomaticKeepAlives: false),
                  )))
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      decoration: BoxDecoration(
          color: Colour('333333', 0.3),
          borderRadius: BorderRadius.circular(15)),
      height: 30,
      width: 200,
      child: InkPageIndicator(
        pageCount: widget.data.length,
        controller: _pageController,
        gap: 32,
        inactiveColor: Colors.grey,
        activeColor: Colors.white,
        // padding: 16,
      ),
    );
  }
}

class MusicPlayingContentItem extends StatefulWidget {
  final MusicPlayingListType type;
  final List<MusicSong> songs;

  const MusicPlayingContentItem(
      {Key? key, required this.type, required this.songs})
      : super(key: key);

  @override
  _MusicPlayingContentItemState createState() =>
      _MusicPlayingContentItemState();
}

//TDTO: AutomaticKeepAliveClientMixin 会冲突所以这不适用
class _MusicPlayingContentItemState extends State<MusicPlayingContentItem> {
  double _itemExtent = 50;
  late List<MusicSong> _songs;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _songs = List.from(widget.songs);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MusicPlayerManager playerManager = MusicPlayerManager.of(context);

    return VisibilityDetector(
      key: Key('_MusicPlayingContentItemState'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          _scrollController = ModalScrollController.of(context);
          _onScroll();
        }
      },
      child: Column(
        children: [
          _buildHeaderTitle(playerManager),
          Expanded(
            child: Container(
              child: CustomScrollView(
                key: GlobalObjectKey(widget.type),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                controller: ModalScrollController.of(context),
                slivers: [
                  SliverList(
                      key: PlayingDialogContentListKey(widget.type,
                          position: playerManager.currentIndex),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var song = widget.songs[index];
                        return _buildItem(playerManager, song, index);
                      }, childCount: _songs.length))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(MusicPlayerManager playerManager) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalDirection: VerticalDirection.up,
              children: [
                Text(
                  widget.type.title,
                  style: AppTheme.titleStyle(context).copyWith(fontSize: 22),
                ),
                Text(
                  '(${_songs.length})',
                  style: AppTheme.subtitleStyle(context).copyWith(fontSize: 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QYBounce(
                  onPressed: () {
                    playerManager.setPlayMode(playerManager.playMode.next);
                    setState(() {});
                  },
                  child: Container(
                    child: Image.asset(
                      playerManager.playModeImage,
                      width: 24,
                      color: AppTheme.subtitleColor(context)
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    QYButtom(
                      color: Colors.transparent,
                      onPressed: (_) async {
                        LogUtil.v('收藏全部');
                        Navigator.of(context).pop();
                        var playingSongs =
                            await playerManager.playingSongsFor(widget.type);
                        var tracks = playingSongs.map((e) => e.id).toList();
                        UserPlaylistDialog.show(context, tracks);
                      },
                      padding: EdgeInsets.only(right: 10),
                      title: Text('收藏全部'),
                      image: Image.asset(
                        ImageHelper.wrapMusicPng(
                            'video_collection_normal_icon'),
                        color: AppTheme.subtitleColor(context),
                        width: 22,
                      ),
                      imageMargin: 2,
                    ),
                    QYSpacing(
                      width: 4,
                    ),
                    QYBounce(
                      onPressed: () {
                        playerManager.removePlaylist(widget.type);
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        ImageHelper.wrapMusicPng('music_playing_dialog_delete'),
                        width: 20,
                        color: AppTheme.subtitleColor(context),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildItem(
      MusicPlayerManager playerManager, MusicSong song, int index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left),
        height: _itemExtent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            QYBounce(
              absorbOnMove: true,
              onPressed: () {
                /// 判断当前类型
                if (widget.type == MusicPlayingListType.current) {
                  playerManager.playIndex(index).then((value) {
                    setState(() {});
                  });
                } else {
                  playerManager.playWithListType(widget.type, index: index);
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 100),
                child: Row(
                  children: [
                    _buildLeading(playerManager, song),
                    QYSpacing(
                      width: 4,
                    ),
                    Expanded(child: _buildMiddle(playerManager, song)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildTrailing(playerManager, song, index),
            ),
          ],
        ));
  }

  Widget _buildLeading(MusicPlayerManager playerManager, MusicSong song) {
    return PulseAnimationWidget(
      animation: playerManager.isPlayingFor(song, type: widget.type),
      height: 10,
      width: 1,
      color: AppTheme.primaryColor(context),
      unAnimationBuilder: (context) {
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildMiddle(MusicPlayerManager playerManager, MusicSong song) {
    var titleColor = AppTheme.titleColor(context);
    var subTitleColor = AppTheme.subtitleColor(context);
    if (playerManager.equalWith(song, type: widget.type)) {
      titleColor = AppTheme.primaryColor(context);
      subTitleColor = titleColor;
    }
    var title = song.title;
    var artistName = song.artistName;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: title,
            style: AppTheme.titleStyle(context).copyWith(color: titleColor)),
        TextSpan(
            text: ' - $artistName',
            style:
                AppTheme.subtitleStyle(context).copyWith(color: subTitleColor))
      ]),
    );
  }

  Widget _buildTrailing(
      MusicPlayerManager playerManager, MusicSong song, int index) {
    var isEqual = playerManager.equalWith(song, type: widget.type);
    var display = playerManager.sourceFor(widget.type).display;
    var color = AppTheme.subtitleColor(context);
    if (!display) {
      color = AppTheme.of(context).disabledColor.withAlpha(80);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isEqual)
          QYButtom(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 26,
            title: Text(
              '播放来源',
              style: AppTheme.subtitleCopyStyle(context,
                  fontSize: 12, color: color),
            ),
            imageAlignment: ImageAlignment.right,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_) {
              if (display) {
                LogUtil.v('播放来源');
              }
            },
          ),
        QYBounce(
          onPressed: () async {
            _songs.removeAt(index);
            await playerManager.removeCurrentPlayingAt(index);
          },
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: Icon(
              Icons.clear,
              color: AppTheme.subtitleColor(context),
            ),
          ),
        )
      ],
    );
  }

  /// 点击滚动
  void _onScroll() {
    final type = widget.type;
    if (type != MusicPlayingListType.current) return;
    _computeScroller((contentListKey, children, start, end) {
      final target = contentListKey?.position ?? 0;
      final position = _scrollController?.position;
      if (position == null) return;
      if (target >= start && target <= end) {
        final Element toShow = children[target - start];
        position
            .ensureVisible(toShow.renderObject!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .whenComplete(() {});
      } else if (target < start) {
        position
            .ensureVisible(
          children.first.renderObject!,
          duration: const Duration(milliseconds: 150),
          curve: Curves.linear,
        )
            .then((_) {
          WidgetsBinding.instance?.scheduleFrameCallback((timeStamp) {
            _onScroll();
          });
        });
      } else if (target > end) {
        position
            .ensureVisible(
          children.last.renderObject!,
          duration: const Duration(milliseconds: 150),
          curve: Curves.linear,
        )
            .then((_) {
          WidgetsBinding.instance?.scheduleFrameCallback((timeStamp) {
            _onScroll();
          });
        });
      }
    });
  }

  void _computeScroller(
    void Function(
      PlayingDialogContentListKey? contentListKey,
      List<Element> children,
      int start,
      int end,
    )
        callback,
  ) {
    SliverMultiBoxAdaptorElement? playListSliver;
    void playListSliverFinder(Element element) {
      if (element.widget.key is PlayingDialogContentListKey) {
        playListSliver = element as SliverMultiBoxAdaptorElement?;
      } else if (playListSliver == null) {
        element.visitChildElements(playListSliverFinder);
      }
    }

    // to find PlayListSliver.
    context.visitChildElements(playListSliverFinder);

    if (playListSliver == null) {
      return;
    }

    final PlayingDialogContentListKey? sliverKey =
        playListSliver!.widget.key as PlayingDialogContentListKey?;
    assert(playListSliver != null, "can not find sliver");

    final List<Element> children = [];
    playListSliver!.visitChildElements((element) {
      children.add(element);
    });
    if (children.isEmpty) {
      return;
    }
    final start = _index(children.first)!;
    final end = _index(children.last)!;
    if (end <= start) {
      return;
    }
    callback(sliverKey, children, start, end);
  }

  static int? _index(Element element) {
    int? index;
    void _findIndex(Element e) {
      if (e.widget is IndexedSemantics) {
        index = (e.widget as IndexedSemantics).index;
      } else {
        e.visitChildElements(_findIndex);
      }
    }

    element.visitChildElements(_findIndex);
    assert(index != null, "can not get index for element $element");
    return index;
  }
}
