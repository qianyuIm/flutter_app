import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/network/music_api/music_api_user_imp.dart';
import 'package:flutter_app/page/search/music_search_bar.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/page_need_login.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
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

class UserCreatePlaylist extends StatefulWidget {
  static void show(BuildContext context) {
    _showBottomSheet(
      context: context,
      builder: (context) {
        return UserCreatePlaylist(
          headerHeight: 40,
          titleHeight: 40,
          contentHeight: 40,
          privacyHeight: 40,
        );
      },
    );
  }

  const UserCreatePlaylist(
      {Key? key,
      required this.headerHeight,
      required this.titleHeight,
      required this.contentHeight,
      required this.privacyHeight})
      : super(key: key);

  final double headerHeight;
  final double titleHeight;
  final double contentHeight;
  final double privacyHeight;

  @override
  _UserCreatePlaylistState createState() => _UserCreatePlaylistState();
}

class _UserCreatePlaylistState extends State<UserCreatePlaylist> {
  bool _privacy = false;
  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var containerHeight = MediaQuery.of(context).viewInsets.bottom +
        widget.headerHeight +
        widget.titleHeight +
        widget.contentHeight +
        widget.privacyHeight;
    return Container(
        height: containerHeight,
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor(context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: PageNeedLogin(
          unLoginPressed: () {
            Navigator.of(context).pop();
          },
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildTitle(context),
                _buildContent(),
                _buildPrivacy()
              ],
            );
          },
        ));
  }

  Widget _buildHeader() {
    return Container(
      height: widget.headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QYBounce(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).user_create_playlist_cancel,
              style: AppTheme.titleStyle(context),
            ),
          ),
          UserInputButton(
            controller: _controller,
            onPressed: () {
              LogUtil.v('点击完成');
              focusNode.unfocus();
              create();
            },
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.titleHeight,
      child: Text(
        S.of(context).user_create_playlist_title,
        style: AppTheme.titleStyle(context).copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      height: widget.contentHeight,
      child: TextField(
        textInputAction: TextInputAction.done,
        autofocus: true,
        maxLines: 1,
        controller: _controller,
        focusNode: focusNode,
        onSubmitted: (value) {
          LogUtil.v('value => $value');
          if (value.isNotEmpty) {
            create();
          }
        },
        decoration: InputDecoration(
          hintText: S.of(context).user_create_playlist_hint,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          suffixIcon: MusicSearchBarSuffixIcon(
            controller: _controller,
            onClear: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacy() {
    return Container(
        height: widget.privacyHeight,
        child: QYButtom(
          onPressed: (_) {
            setState(() {
              _privacy = !_privacy;
            });
          },
          image: _privacy
              ? Image.asset(
                  ImageHelper.wrapMusicPng('user_create_checkbox_selected'),
                  width: 16,
                )
              : Image.asset(
                  ImageHelper.wrapMusicPng('user_create_checkbox'),
                  width: 15,
                ),
          title: Text(S.of(context).user_create_playlist_privacy),
        ));
  }

  void create() async {
    var playlist = await MusicApiUserImp.loadPlaylistCreateData(
        _controller.text,
        privacy: _privacy);

    /// 跳转
    Navigator.of(context).pop();
    Navigator.of(context)
        .pushNamed(MyRouterName.play_list_detail, arguments: playlist.id);
  }
}

class UserInputButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onPressed;

  const UserInputButton({Key? key, required this.controller, this.onPressed})
      : super(key: key);

  @override
  _UserInputButtonState createState() => _UserInputButtonState();
}

class _UserInputButtonState extends State<UserInputButton> {
  late ValueNotifier<bool> _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(widget.controller.text.isEmpty);
    widget.controller.addListener(() {
      if (mounted) _notifier.value = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, bool value, child) {
        return QYButtom(
          color: AppTheme.scaffoldBackgroundColor(context),
          enable: value,
          onPressed: (_) {
            widget.onPressed?.call();
          },
          title: Text(
            S.of(context).user_create_playlist_complete,
            style: AppTheme.titleStyle(context),
          ),
        );
      },
    );
  }
}
