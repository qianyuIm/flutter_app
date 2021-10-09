import 'package:flutter/material.dart';
import 'package:flutter_app/page/video/video/internal_category_tabbar_view.dart';
import 'package:flutter_app/page/video/video/internal_video_page.dart';
import 'package:flutter_app/page/video/video/internal_video_recommend_page.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music_player_manager.dart';
import 'package:flutter_app/view_model/video/internal_video_view_model.dart';

class InternalVideoContainerPage extends StatefulWidget {


  @override
  _InternalVideoContainerPageState createState() =>
      _InternalVideoContainerPageState();
}

class _InternalVideoContainerPageState extends State<InternalVideoContainerPage>
    with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  Function(bool)? scrollCallBack;
  
  InternalVideoContainerCategoryViewModel? _viewModel;
 
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    /// 暂停音乐播放
    var playerManager = MusicPlayerManager.of(context);
    playerManager.pause();
  }

  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ProviderWidget<InternalVideoContainerCategoryViewModel>(
        viewModel: InternalVideoContainerCategoryViewModel(),
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
          return InternalCategoryTabBarView(
            initialIndex: 0,
            itemCount: viewModel.categorys.length,
            items: viewModel.categorys,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MyRouterName.internal_video_category)
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
              var key = GlobalObjectKey(category.category.categoryId);
              var itemPage = key.currentWidget;
              if (itemPage == null) {
                if (category.category.categoryId == kRecommendedCategoryId) {
                  return InternalVideoRecommendPage(
                    key: key,
                    category: category.category
                  );
                } else {
                  return InternalVideoPage(
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
      ),
    );
  }

  void listenerPopTabLengthChange(bool isChange) {
    if (isChange) {
     _viewModel?.initData();
    }
  }
  
}
