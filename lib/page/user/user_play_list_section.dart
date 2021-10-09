import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/page/user/user_create_play_list.dart';
import 'package:flutter_app/page/user/user_play_list_update_page.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:provider/provider.dart';

/// 10
const double _kPlayListDividerHeight = 10;

/// 48
const double kUserPlayListHeaderHeight = 48;

enum UserPlaylistType { created, subscribed }

class UserPlayListTypeNotification extends Notification {
  UserPlayListTypeNotification({required this.type});

  final UserPlaylistType type;
}

class UserPlayListSliverKey extends ValueKey {
  const UserPlayListSliverKey({this.createdPosition, this.subscribedPosition})
      : super("_UserPlayListSliverKey");

  /// 在list中所处的位置
  final int? createdPosition;

  /// 在list中所处的位置
  final int? subscribedPosition;
}

class UserPlaylistSection extends StatefulWidget {
  final ScrollController? scrollController;

  const UserPlaylistSection({Key? key, this.scrollController})
      : super(key: key);

  @override
  _UserPlaylistSectionState createState() => _UserPlaylistSectionState();
}

class _UserPlaylistSectionState extends State<UserPlaylistSection> {
  /// 标识位置使用
  final _dividerKey = GlobalKey();
  double _dividerDy = 0;
  UserPlaylistType? _currentType;

  @override
  void initState() {
    widget.scrollController?.addListener(_onScrolling);
    super.initState();
  }

  @override
  void didUpdateWidget(UserPlaylistSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.scrollController?.removeListener(_onScrolling);
    widget.scrollController?.addListener(_onScrolling);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScrolling);
    super.dispose();
  }

  void _onScrolling() {
    if (_dividerDy == 0) {
      final RenderBox? childRenderBox =
          _dividerKey.currentContext?.findRenderObject() as RenderBox?;
      if (childRenderBox == null) {
        return;
      }
      final Size childSize = childRenderBox.size;
      final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);
      _dividerDy = childPosition.dy -
          Inchs.navigation_height -
          Inchs.statusBarHeight +
          childSize.height -
          kUserPlayListHeaderHeight;
    }
    var type = _dividerDy >= widget.scrollController!.offset
        ? UserPlaylistType.created
        : UserPlaylistType.subscribed;
    if (_currentType != type) {
      UserPlayListTypeNotification(type: type).dispatch(context);
      _currentType = type;
    }
  }

  @override
  Widget build(BuildContext context) {
    var playlistViewModel = context.watch<UserPlaylistViewModel>();
    var createdPlayList = playlistViewModel.createdPlayList;
    var createdCount =
        createdPlayList.length > 1 ? createdPlayList.length - 1 : 1;
    return SliverList(
      key: UserPlayListSliverKey(
          createdPosition: 1, subscribedPosition: 3 + createdCount),
      delegate: SliverChildListDelegate([
        const SizedBox(
          height: _kPlayListDividerHeight,
        ),
        PlaylistHeader(
          title: S.of(context).user_tab_playlist_create,
          editor: true,
          count: createdPlayList.length - 1,
          onEditorPressed: () {
            LogUtil.v('编辑');
            UserCreatePlaylist.show(context);
          },
          onMorePressed: () {
            UserPlaylistUpdateDialog.show(
                context,
                S.of(context).user_tab_playlist_create,
                createdPlayList.length - 1, () {
              var playLists = createdPlayList.isNotEmpty
                  ? createdPlayList.sublist(1)
                  : createdPlayList;
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                  MyRouterName.user_play_list_update,
                  arguments: {'playlists': playLists, 'enableNickName': false});
            });
          },
        ),
        ..._playlistWidget(context, playlistViewModel.createdPlayList, true),
        SizedBox(
          key: _dividerKey,
          height: _kPlayListDividerHeight,
        ),
        PlaylistHeader(
          title: S.of(context).user_tab_playlist_subscribe,
          editor: false,
          count: playlistViewModel.subscribedPlayList.length,
          onMorePressed: () {
            UserPlaylistUpdateDialog.show(
                context,
                S.of(context).user_tab_playlist_subscribe,
                playlistViewModel.subscribedPlayList.length, () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushNamed(MyRouterName.user_play_list_update, arguments: {
                'playlists': playlistViewModel.subscribedPlayList,
                'enableNickName': true
              });
            });
          },
        ),
        ..._playlistWidget(
            context, playlistViewModel.subscribedPlayList, false),
        const SizedBox(
          height: _kPlayListDividerHeight,
        ),
      ], addAutomaticKeepAlives: false),
    );
  }

  static Iterable<Widget> _playlistWidget(
      BuildContext context, List<MusicPlayList> playLists, bool created) {
    if (created) {
      playLists = playLists.isNotEmpty ? playLists.sublist(1) : playLists;
    }
    if (playLists.isEmpty) {
      var title = created
          ? S.of(context).user_tab_playlist_create_empty
          : S.of(context).user_tab_playlist_subscribe_empty;
      return [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppTheme.cardColor(context),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          margin: EdgeInsets.symmetric(horizontal: Inchs.left),
          padding: EdgeInsets.symmetric(vertical: Inchs.left),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTheme.subtitleStyle(context)
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ];
    }
    final List<Widget> widgets = <Widget>[];
    for (int i = 0; i < playLists.length; i++) {
      widgets.add(Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left),
        child: PlaylistTile(
          playList: playLists[i],
          enableNickName: !created,
          enableBottomRadius: i == playLists.length - 1,
          onPressed: () {
            Navigator.of(context).pushNamed(MyRouterName.play_list_detail,
                arguments: playLists[i].id);
          },
        ),
      ));
    }
    return widgets;
  }
}

class PlaylistHeader extends StatelessWidget {
  final String title;
  final bool editor;
  final int count;
  final VoidCallback? onEditorPressed;
  final VoidCallback? onMorePressed;

  const PlaylistHeader(
      {Key? key,
      required this.title,
      required this.editor,
      required this.count,
      this.onEditorPressed,
      this.onMorePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Inchs.left),
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        color: AppTheme.cardColor(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          child: Row(
            children: [
              Text(title),
              if (count > 0) Text('($count个)'),
              const Spacer(),
              if (editor)
                QYButtom(
                  width: 40,
                  height: 40,
                  onPressed: (_) {
                    onEditorPressed?.call();
                  },
                  alignment: Alignment.centerRight,
                  image: Icon(Icons.add),
                ),
              QYButtom(
                width: 40,
                height: 40,
                onPressed: (_) {
                  onMorePressed?.call();
                },
                alignment: Alignment.centerRight,
                image: Icon(Icons.more_vert),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistTile extends StatelessWidget {
  final MusicPlayList playList;
  final bool enableBottomRadius;
  final bool enableNickName;
  final VoidCallback? onPressed;

  const PlaylistTile(
      {Key? key,
      required this.playList,
      required this.enableBottomRadius,
      required this.enableNickName,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.cardColor(context),
      borderRadius: enableBottomRadius
          ? const BorderRadius.vertical(bottom: Radius.circular(4))
          : null,
      child: QYBounce(
        absorbOnMove: true,
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _buildLeading(),
              QYSpacing(
                width: 10,
              ),
              Expanded(child: _buildTitle(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    Widget child = Stack(
      alignment: Alignment.center,
      children: [
        ImageLoadView(
          imagePath:
              ImageCompressHelper.musicCompress(playList.coverImgUrl, 50, 50),
          width: 50,
          height: 50,
        ),
        if (playList.isPrivacy)
          Align(
              child: Image.asset(
            ImageHelper.wrapMusicPng('user_playlist_privacy_onlyme'),
            width: 18,
          )),
        if (playList.highQuality)
          Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                ImageHelper.wrapMusicPng('icon_play_list_hot'),
                width: 20,
              ))
      ],
    );

    return Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: child,
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playList.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
        ),
        QYSpacing(
          height: 4,
        ),
        Row(
          children: [
            Text(
              '${playList.trackCount}首',
              style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
            ),
            if (enableNickName)
              Expanded(
                child: Text(
                  ',    by ${playList.creator?.nickname}',
                  style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
                ),
              )
          ],
        )
      ],
    );
  }
}
