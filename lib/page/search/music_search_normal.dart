import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/model/search/music_hot_search.dart';
import 'package:flutter_app/page/search/music_history_container.dart';
import 'package:flutter_app/view_model/search/music_search_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:provider/provider.dart';

class MusicSearchNormal extends StatefulWidget {
    final ValueChanged<String>? onSearch;

  const MusicSearchNormal({Key? key, this.onSearch}) : super(key: key);


  @override
  _MusicSearchNormalState createState() => _MusicSearchNormalState();
}

class _MusicSearchNormalState extends State<MusicSearchNormal> {
  late Future<List<MusicHotSearch>> _hotSearchFuture;

  @override
  void initState() {
    _hotSearchFuture = _loadHotSearch();
        // LogUtil.v('_MusicSearchNormalState初始化');
    super.initState();
  }

  @override
  void dispose() {
    // LogUtil.v('_MusicSearchNormalState移除了');
    super.dispose();
  }

  Future<List<MusicHotSearch>> _loadHotSearch() async {
    var searchViewModel = MusicSearchViewModel.of(context);
    return searchViewModel.loadHotSearch();
  }

  /// 广告
  Widget _buildAdvertising() {
    return Container(
      margin: EdgeInsets.all(Inchs.left),
      height: 40,
      width: Inchs.screenWidth,
      color: Colors.red.withAlpha(100),
      child: Center(
        child: Text('我是广告'),
      ),
    );
  }

  Widget _buildHistory() {
    return MusicHistoryContainer(
      onSearch: widget.onSearch,
    );
  }

  Widget _buildHotSearch(BuildContext context) {
    var searchViewModel = MusicSearchViewModel.of(context);
    return FutureBuilder(
      future: _hotSearchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
            width: Inchs.screenWidth,
            height: searchViewModel.showAllHot ? searchViewModel.getMaxGridHeight() : 250,
            child: GridView.builder(
              itemCount: searchViewModel.showHotSearchItems.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 50),
              itemBuilder: (context, index) {
                return _hotSearchItem(
                    searchViewModel.showHotSearchItems[index], index);
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _hotSearchItem(MusicHotSearch hotSearchItem, int index) {
    bool isHot = index < 3;
    var numColor = isHot ? Colors.red : AppTheme.titleColor(context);
    var titleColor = isHot
        ? AppTheme.titleColor(context)
        : AppTheme.subtitleColor(context);
    return InkWell(
      onTap: () {
        var searchWord = hotSearchItem.searchWord!;
        widget.onSearch?.call(searchWord);
      },
      child: Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text('${index + 1}',
              style: AppTheme.titleStyle(context)
                  .copyWith(fontSize: 16, color: numColor)),
          QYSpacing(
            width: 10,
          ),
          Text(
            '${hotSearchItem.searchWordAdapter()}',
            style: AppTheme.titleStyle(context)
                .copyWith(fontSize: 16, color: titleColor),
          ),
          QYSpacing(
            width: 6,
          ),
          if (hotSearchItem.hotTag().isNotEmpty)
            ImageLoadView(
              imagePath: hotSearchItem.hotTag(),
              width: 25,
              height: 15,
            )
        ],
      ),
    ),
    );
  }

  Widget _buildMore() {
    var viewModel = Provider.of<MusicSearchViewModel>(context);
    // LogUtil.v('我来了');
    if (viewModel.hotMoreThan10() && !viewModel.showAllHot) {
      return GestureDetector(
        onTap: viewModel.switchShowAll,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).expansion_more,
                style: AppTheme.subtitleStyle(context).copyWith(fontSize: 16),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 32,
                color: AppTheme.subtitleColor(context),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldBackgroundColor = AppTheme.scaffoldBackgroundColor(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: scaffoldBackgroundColor,
        height: Inchs.screenHeight - Inchs.statusBarHeight + 44,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildAdvertising(),
                _buildHistory(),
                _buildHotSearch(context),
                _buildMore(),
              ],
            )),
      ),
    );
  }
}
