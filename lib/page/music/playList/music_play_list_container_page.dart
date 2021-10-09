
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/page/music/bottom/bottom_player_box_controller.dart';
import 'package:flutter_app/page/music/playList/music_highquality_play_list_page.dart';
import 'package:flutter_app/page/music/playList/music_play_list_page.dart';
import 'package:flutter_app/page/music/playList/playlist_category_tabbar_view.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';

/// 歌单广场  
class MusicPlaylistContainerPage extends StatefulWidget {
  @override
  _MusicPlaylistContainerPageState createState() => _MusicPlaylistContainerPageState();
}

class _MusicPlaylistContainerPageState extends State<MusicPlaylistContainerPage> {
   MusicPlaylistContainerViewModel? _viewModel;


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).playlist_square),),
      body: BottomPlayerBoxController(
          child: ProviderWidget<MusicPlaylistContainerViewModel>(
        viewModel: MusicPlaylistContainerViewModel(),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
           _viewModel = viewModel;
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError && viewModel.categorys.isEmpty) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: () async {
                  /// 未登录
                  if (viewModel.viewStateError!.isUnauthorizedError) {
                    Navigator.of(context)
                        .pushNamed(MyRouterName.music_login,
                            arguments: MyRouterName.tab)
                        .then((_) {
                      final arguments =
                          ModalRoute.of(context)?.settings.arguments as Map;
                      final value = arguments[MyRouter.key];
                      if (value == MyRouter.value) {
                        viewModel.initData();
                      }
                    });
                  } else {
                    viewModel.initData();
                  }
                });
          } else if (viewModel.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }
          return PlaylistCategoryTabbarView(
            initialIndex: 0,
            itemCount: viewModel.categorys.length,
            items: viewModel.categorys,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MyRouterName.play_list_category)
                  .then((value) {
                listenerPopTabLengthChange(value as bool);
              });
            },
            tabBuilder: (context, index) {
              var category = viewModel.categorys[index];
              return Tab(
                text: category.category.name,
              );
            },
            pageBuilder: (context, index) {
              var category = viewModel.categorys[index];
              var key = GlobalObjectKey(category.category.name);
              var itemPage = key.currentWidget;
              if (itemPage == null) {
                if (category.category.name == '精品') {
                  return MusicHighqualityPlaylistPage(
                    key: key,
                    category: category.category
                  );
                  
                } else {
                  return MusicPlaylistPage(
                    key: key,
                    category: category.category,
                  );
                }
              } else {
                // LogUtil.v('已经存在的=>${category.category.name}');
              }
              return itemPage;
            },
          );
        },
      )),
    );
  }
  void listenerPopTabLengthChange(bool isChange) {
    if (isChange) {
     _viewModel?.initData();
    }
  }
}