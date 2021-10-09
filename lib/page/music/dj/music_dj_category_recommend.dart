import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie_recommend.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/dj/music_dj_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicDJCategoryRecommendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MusicDJCategoryRecommendViewModel>(
      viewModel: MusicDJCategoryRecommendViewModel(),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return SliverToBoxAdapter(child: ViewStateBusyWidget());
        } else if (viewModel.isError && viewModel.categorieRecommends.isEmpty) {
          return SliverToBoxAdapter(
              child: ViewStateErrorWidget(
                  error: viewModel.viewStateError!,
                  onPressed: viewModel.initData));
        } else if (viewModel.isEmpty) {
          return SliverToBoxAdapter(
              child: ViewStateEmptyWidget(onPressed: viewModel.initData));
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            MusicDJCategorieRecommend section =
                viewModel.categorieRecommends[index];
            return _MusicDJCategorySection(
              categorieRecommend: section,
            );
          }, childCount: viewModel.categorieRecommends.length),
        );
      },
    );
  }
}

class _MusicDJCategorySection extends StatelessWidget {
  final MusicDJCategorieRecommend categorieRecommend;

  const _MusicDJCategorySection({Key? key, required this.categorieRecommend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 4),
      child: Column(
        children: [
          _buildHeader(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 6),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            categorieRecommend.categoryName,
            style: AppTheme.titleStyle(context),
          ),
          QYButtom(
            absorbOnMove: true,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 4),
            height: 26,
            title: Text(S.of(context).more),
            imageAlignment: ImageAlignment.right,
            image: Icon(
              Icons.chevron_right,
              color: AppTheme.subtitleColor(context),
              size: 20,
            ),
            imageMargin: 0,
            border: Border.all(color: AppTheme.primaryColor(context)),
            borderRadius: BorderRadius.circular(13),
            onPressed: (_) {
              var arguments = {'categoryId': categorieRecommend.categoryId, 'categoryName': categorieRecommend.categoryName};
              Navigator.of(context).pushNamed(MyRouterName.dj_category_detail,
                  arguments: arguments);
            },
          )
        ]));
  }

  Widget _buildContent(BuildContext context) {
    final imageWidth =
        (Inchs.screenWidth - Inchs.left - Inchs.right - 12) / 3;
    return Container(
      padding: EdgeInsets.only(top: 6),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categorieRecommend.radios!
              .map(
                (djRadio) => QYBounce(
                  absorbOnMove: true,
                  onPressed: () {
                    LogUtil.v('object');
                  },
                    child: Container(
                  width: imageWidth,
                  height: imageWidth + 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ImageLoadView(
                            imagePath: ImageCompressHelper.musicCompress(
                                djRadio.picUrl, imageWidth, imageWidth),
                            radius: 5,
                            width: imageWidth,
                            height: imageWidth,
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 4, right: 4),
                                height: 20,
                                color: Colors.black.withAlpha(30),
                                child: Text(
                                  djRadio.dj?.nickname ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.subtitleStyle(context)
                                      .copyWith(color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                      QYSpacing(
                        height: 4,
                      ),
                      Text(
                        djRadio.rcmdText ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )),
              )
              .toList()),
    );
  }
}
