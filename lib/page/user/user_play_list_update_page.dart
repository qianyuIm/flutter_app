import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/network/music_api/music_api_user_imp.dart';
import 'package:flutter_app/page/user/user_play_list_section.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// 控制面板
Future<T> _showBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final result = await showCustomModalBottomSheet(
    expand: false,
    enableDrag: false,
    context: context,
    builder: builder,
    containerWidget: (_, animation, child) => SafeArea(
      top: false,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    ),
  );

  return result;
}

class UserPlaylistUpdateDialog extends StatelessWidget {
  static void show(
      BuildContext context, String title, int count, VoidCallback? onPressed) {
    _showBottomSheet(
      context: context,
      builder: (context) {
        return UserPlaylistUpdateDialog(
          title: title,
          count: count,
          onPressed: onPressed,
        );
      },
    );
  }

  const UserPlaylistUpdateDialog(
      {Key? key, required this.title, required this.count, this.onPressed})
      : super(key: key);

  final String title;
  final int count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppTheme.scaffoldBackgroundColor(context),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTitle(), Divider(), _buildButton(context)],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title),
          if (count > 0) Text('($count)'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    var color = (count > 0)
        ? AppTheme.subtitleColor(context)
        : AppTheme.of(context).disabledColor;
    return QYBounce(
        onPressed: (count > 0) ? onPressed : null,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Image.asset(
                ImageHelper.wrapMusicPng('user_playlist_update'),
                color: color,
                width: 28,
              ),
              Text(
                S.of(context).user_playlist_manager,
                style: AppTheme.subtitleCopyStyle(context,color: color),
              ),
            ],
          ),
        ));
  }
}

class UserPlaylistUpdate extends StatefulWidget {
  final List<MusicPlayList> playlists;
  final bool enableNickName;

  const UserPlaylistUpdate(
      {Key? key, required this.playlists, required this.enableNickName})
      : super(key: key);

  @override
  _UserPlaylistUpdateState createState() => _UserPlaylistUpdateState();
}

class _UserPlaylistUpdateState extends State<UserPlaylistUpdate> {
  String _title = '管理歌单';
  bool _selected = false;
  late List<MusicPlayList> _playlists;
  late Map<MusicPlayList, bool> _map = {};
  late List<MusicPlayList> _constantPlaylists;
  @override
  void initState() {
    super.initState();

    /// 直接赋值会一起修改
    _playlists = widget.playlists;
    _constantPlaylists = List.from(widget.playlists);
    _playlists.forEach((element) {
      _map[element] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var titleStyle = AppTheme.subtitleStyle(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.cardColor(context),
        leadingWidth: 80,
        title: Text(_title),
        leading: QYBounce(
          onPressed: () {
            _selected = !_selected;
            if (_selected) {
              _map.forEach((key, value) {
                _map[key] = true;
              });
              _title = '已选中${_playlists.length}个歌单';
            } else {
              _map.forEach((key, value) {
                _map[key] = false;
              });

              _title = '管理歌单';
            }
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.only(left: Inchs.left),
            alignment: Alignment.centerLeft,
            child: _selected
                ? Text(
                    '取消全选',
                    style: titleStyle,
                  )
                : Text(
                    '全选',
                    style: titleStyle,
                  ),
          ),
        ),
        actions: [
          QYBounce(
            onPressed: () async {
              /// 首先判断是否需要更新顺序
              bool isEquals = const IterableEquality()
                  .equals(_constantPlaylists, _playlists);
              if (!isEquals) {
                var ids = _playlists.map((e) => e.id).toList();
                
                await MusicApiUserImp.loadPlaylistOrderUpdateData(ids);
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              padding: EdgeInsets.only(right: Inchs.right),
              alignment: Alignment.centerLeft,
              child: Text(
                '完成',
                style: titleStyle,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: _buildListView()), _buildDelete()],
      ),
    );
  }

  Widget _buildListView() {
    var cardColor = AppTheme.cardColor(context);
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        var playList = _playlists[index];
        return _buildListItem(playList, index, _map[playList]!, cardColor);
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final MusicPlayList item = _playlists.removeAt(oldIndex);
          _playlists.insert(newIndex, item);
        });
      },
    );
  }

  Widget _buildListItem(
      MusicPlayList playList, int index, bool selected, Color cardColor) {
    return Container(
      key: ValueKey(playList),
      color: cardColor,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          QYButtom(
              absorbOnMove: true,
              image: selected
                  ? Image.asset(
                      ImageHelper.wrapMusicPng('user_create_checkbox_selected'),
                      width: 16,
                    )
                  : Image.asset(
                      ImageHelper.wrapMusicPng('user_create_checkbox'),
                      width: 15,
                    ),
              onPressed: (_) {
                // 6956345239,361919728
                _map[playList] = !_map[playList]!;
                var selected = _map.values.where((element) => element == true);
                if (selected.isEmpty) {
                  _title = '管理歌单';
                } else {
                  _title = '已选中${selected.length}个歌单';
                }

                setState(() {});
              },
              title: Expanded(
                child: Container(
                    padding: EdgeInsets.only(right: 40),
                    child: PlaylistTile(
                      playList: playList,
                      enableBottomRadius: false,
                      enableNickName: widget.enableNickName,
                    )),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: ReorderableDragStartListener(
                index: index,
                child: Container(
                  color: cardColor,
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.reorder,
                    color: AppTheme.subtitleColor(context),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildDelete() {
    var hasSelected = _map.containsValue(true);
    var color = hasSelected
        ? AppTheme.subtitleColor(context)
        : AppTheme.of(context).disabledColor;
    return QYBounce(
      onPressed: () async {
        if (hasSelected) {
          var ids = _playlists
              .where((element) => _map[element] == true)
              .map((e) => e.id)
              .toList();
          var result = await MusicApiUserImp.loadPlaylistDeleteData(ids);
          if (result) {
            _playlists.removeWhere((element) => _map[element] == true);
            _map.removeWhere((key, value) => value == true);
            _title = '管理歌单';
            setState(() {});
          }
        }
      },
      child: Container(
        color: AppTheme.cardColor(context),
        height: 50 + Inchs.bottomBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageHelper.wrapMusicPng('user_playlist_delete'),
              width: 24,
              color: color,
            ),
            QYSpacing(
              width: 6,
            ),
            Text(
              '删除',
              style: AppTheme.subtitleCopyStyle(context,color: color),
            )
          ],
        ),
      ),
    );
  }
}
