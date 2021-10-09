import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_icon.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/qy_toast.dart';

class MusicDJCategoryPage extends StatefulWidget {
  @override
  _MusicDJCategoryPageState createState() => _MusicDJCategoryPageState();
}

class _MusicDJCategoryPageState extends State<MusicDJCategoryPage> {
  double _scrollRatio = 0;
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicDJCategorieViewModel>(
      viewModel: MusicDJCategorieViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError && viewModel.categories.isEmpty) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return _buildCategory(viewModel.categories);
      },
    );
  }

  void categoryOnPressed(MusicDjCategorie categorie) {
    if (categorie.isMyDj) {
      QYToast.showError(context, '暂无');
    } else if (categorie.isRank) {
      Navigator.of(context)
          .pushNamed(MyRouterName.dj_rank);
    } else {
      var arguments = {
        'categoryId': categorie.id,
        'categoryName': categorie.name
      };
      Navigator.of(context)
          .pushNamed(MyRouterName.dj_category_detail, arguments: arguments);
    }
  }

  Widget _buildCategory(List<MusicDjCategorie> categories) {
    var color = AppTheme.primaryColor(context);
    var itemRender = categories
        .map((categorie) => QYBounce(
              absorbOnMove: true,
              onPressed: () {
                categoryOnPressed(categorie);
              },
              child: Container(
                width: Inchs.adapter(345 / 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: Inchs.adapter(40),
                          height: Inchs.adapter(40),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Inchs.adapter(40) / 2),
                              color: color.withAlpha(80)),
                        ),
                        _buildCenterImage(categorie)
                      ],
                    ),
                    QYSpacing(height: 4),
                    Text(categorie.name,
                        style: AppTheme.subtitleStyle(context)),
                  ],
                ),
              ),
            ))
        .toList();
    double indicatorBoxWidth = Inchs.adapter(34);
    double indicatorHeight = Inchs.adapter(3.5);
    double indicatorWidth = Inchs.adapter(15);
    double scrollValue = _scrollRatio * (indicatorBoxWidth - indicatorWidth);
    return Column(
      children: [
        QYSpacing(height: 4),
        Container(
          height: Inchs.adapter(70),
          child: NotificationListener(
            onNotification: (ScrollNotification note) {
              setState(() {
                _scrollRatio =
                    note.metrics.pixels / note.metrics.maxScrollExtent;
              });
              return true;
            },
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding:
                  EdgeInsets.only(left: Inchs.left, right: Inchs.right),
              children: itemRender,
            ),
          ),
        ),
        SizedBox(
          height: Inchs.adapter(8),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(indicatorHeight / 2),
              ),
              child: Container(
                width: indicatorBoxWidth,
                height: indicatorHeight,
                child: Stack(alignment: Alignment.centerLeft, children: [
                  Positioned(
                    left: scrollValue,
                    child: Container(
                      width: indicatorWidth,
                      height: indicatorHeight,
                      color: color,
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
        QYSpacing(height: 4)
      ],
    );
  }

  Widget _buildCenterImage(MusicDjCategorie categorie) {
    if (categorie.isRank) {
      return Center(
        child: Icon(
          QyIcon.icon_ranking,
          color: Colors.white,
        ),
      );
    } else if (categorie.isMyDj) {
      return Center(
        child: Icon(
          QyIcon.icon_radio,
          color: Colors.white,
        ),
      );
    }
    return Center(
        child: ImageLoadView(
      imagePath: categorie.pic96x96Url ?? '',
      width: Inchs.adapter(30),
      height: Inchs.adapter(30),
    ));
  }
}
