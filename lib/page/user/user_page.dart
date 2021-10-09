import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/page/user/user_favorite_section.dart';
import 'package:flutter_app/page/user/user_play_list_section.dart';
import 'package:flutter_app/page/user/user_preset_grid_section.dart';
import 'package:flutter_app/page/user/user_profile_section.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/scroll_controller_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:flutter_app/widget/animated_widget.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/music_persistent_header_delegate.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _tab_titles = ['创建歌单', '收藏歌单'];

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late double _triggerHeight;
  late ScrollController _scrollController;
  late TabController _tabController;
  bool _scrollerAnimating = false;
  bool _tabAnimating = false;
  bool _initialize = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    /// 刷新用户状态
    var userManager = MusicUserManager.of(context);
    Future.wait([userManager.initialize()])
        .then((value) => {LogUtil.v('刷新完成')});
    _triggerHeight = 70;
    _scrollController = ScrollController();
    _tabController = TabController(length: _tab_titles.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var userItem = MusicUserManager.of(context, listen: true);
    return ProviderWidget2<ScrollControllerViewModel, UserPlaylistViewModel>(
      viewModel1: ScrollControllerViewModel(_scrollController, _triggerHeight),
      viewModel2: UserPlaylistViewModel(userItem),
      onModelReady: (viewModel, viewMode2) {
        viewModel.init();
        viewMode2.initData();
      },
      builder: (context, viewModel1, viewMode2, child) {
        return VisibilityDetector(
          key: Key('_UserPageState'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction == 1.0) {
              if (_initialize && !viewMode2.isBusy && userItem.isLogin) {
                LogUtil.v('再次请求数据');

                /// 刷新用户的歌单
                viewMode2.initData();
              }
              _initialize = true;
            }
          },
          child: CustomScrollView(
            controller: viewModel1.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppbar(viewModel1.trigger),
              _buildUserProfileSection(),
              _buildUserPresetGridSection(),
              _buildUserFavoriteSection(),
              _buildTabs(),
              _builPlaylistSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppbar(bool trigger) {
    var userItem = MusicUserManager.of(context).userDetail;
    Widget? title;
    if (userItem != null) {
      title = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageLoadView(
            imagePath: ImageCompressHelper.musicCompress(
                userItem.profile?.avatarUrl, 40, 40),
            width: 40,
            height: 40,
            radius: 20,
          ),
          QYSpacing(
            width: 4,
          ),
          Text(userItem.profile?.nickname ?? ''),
        ],
      );
    } else {
      title = Image.asset(
        ImageHelper.wrapMusicPng('music_default_avatar'),
        width: 40,
      );
    }
    return SliverAppBar(
      pinned: true,
      actions: [
        QYBounce(
          onPressed: () {
            Navigator.of(context).pushNamed(MyRouterName.app_setting);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Inchs.right),
            child: Image.asset(
              ImageHelper.wrapMusicPng('user_setting'),
              width: 26,
              color: AppTheme.iconColor(context),
            ),
          ),
        )
      ],
      title: EmptyAnimatedSwitcher(display: trigger, child: title),
    );
  }

  Widget _buildUserProfileSection() {
    return SliverToBoxAdapter(
      child: UserProfileSection(),
    );
  }

  Widget _buildUserPresetGridSection() {
    return SliverToBoxAdapter(
      child: UserPresetGridSection(),
    );
  }

  Widget _buildUserFavoriteSection() {
    return SliverToBoxAdapter(child: UserFavoriteSection());
  }

  Widget _buildTabs() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MusicPersistentHeaderDelegate(
          minHeight: kUserPlayListHeaderHeight,
          maxHeight: kUserPlayListHeaderHeight,
          child: Container(
            color: AppTheme.scaffoldBackgroundColor(context),
            child: TabBar(
              controller: _tabController,
              onTap: (value) {
                if (_scrollerAnimating || _tabAnimating) {
                  return;
                }
                _onTapScroll(UserPlaylistType.values[value]);
              },
              tabs: [
                Tab(text: S.of(context).user_tab_playlist_create,),
                Tab(text: S.of(context).user_tab_playlist_subscribe,)
              ],
            ),
          )),
    );
  }

  Widget _builPlaylistSection() {
    return NotificationListener<UserPlayListTypeNotification>(
        onNotification: (notification) {
          _updateCurrentTabSelection(notification.type);
          return true;
        },
        child: UserPlaylistSection(
          scrollController: _scrollController,
        ));
  }

  Future<void> _updateCurrentTabSelection(UserPlaylistType type) async {
    if (_tabController.index == type.index) {
      return;
    }
    if (_tabController.indexIsChanging || _scrollerAnimating || _tabAnimating) {
      return;
    }
    _tabAnimating = true;
    _tabController.animateTo(type.index);
    Future.delayed(kTabScrollDuration + const Duration(milliseconds: 100))
        .whenComplete(() {
      _tabAnimating = false;
    });
  }

  void _computeScroller(
    void Function(
      UserPlayListSliverKey? sliverKey,
      List<Element> children,
      int start,
      int end,
    )
        callback,
  ) {
    SliverMultiBoxAdaptorElement? playListSliver;
    void playListSliverFinder(Element element) {
      if (element.widget.key is UserPlayListSliverKey) {
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

    final UserPlayListSliverKey? sliverKey =
        playListSliver!.widget.key as UserPlayListSliverKey?;
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

  /// 点击滚动
  void _onTapScroll(UserPlaylistType type) {
    _scrollerAnimating = true;
    _computeScroller((sliverKey, children, start, end) {
      final target = type == UserPlaylistType.created
          ? sliverKey?.createdPosition
          : sliverKey?.subscribedPosition;
      if (target == null) return;
      final position = _scrollController.position;
      if (target >= start && target <= end) {
        final Element toShow = children[target - start];
        position
            .ensureVisible(toShow.renderObject!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .whenComplete(() {
          _scrollerAnimating = false;
        });
      } else if (target < start) {
        position
            .ensureVisible(
          children.first.renderObject!,
          duration: const Duration(milliseconds: 150),
          curve: Curves.linear,
        )
            .then((_) {
          WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
            _onTapScroll(type);
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
          WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
            _onTapScroll(type);
          });
        });
      }
    });
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
