
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/debounce_helper.dart';
import 'package:flutter_app/model/search/music_search_suggest_match.dart';
import 'package:flutter_app/view_model/search/music_search_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicSearchSuggestion extends StatefulWidget {
  final TextEditingController textController;
  final ValueChanged<String>? onSearch;
  const MusicSearchSuggestion(
      {Key? key, required this.textController, this.onSearch})
      : super(key: key);

  @override
  _MusicSearchSuggestionState createState() => _MusicSearchSuggestionState();
}

class _MusicSearchSuggestionState extends State<MusicSearchSuggestion> {
  late ValueNotifier<String> _onTextChanged = ValueNotifier('-1');
  late MusicSearchViewModel _searchViewModel;
  @override
  void initState() {
    _searchViewModel = MusicSearchViewModel.of(context);
    widget.textController.addListener(_onTextControllerListener);
    _onTextChanged.addListener(_onTextChangedListener);

    /// 第一次手动调用
    _onTextControllerListener();
    super.initState();
  }

  @override
  void dispose() {
    _onTextChanged.removeListener(_onTextChangedListener);
    widget.textController.removeListener(_onTextControllerListener);
    super.dispose();
  }

  void _onTextControllerListener() {
    _onTextChanged.value = widget.textController.text;
  }

  void _onTextChangedListener() {
    var keyword = _onTextChanged.value;

    /// 数据请求
    DebounceHelper.duration(
        const Duration(milliseconds: 800), _loadRequest, [keyword]);
  }

  void _loadRequest(String keyword) {
    if (keyword.length > 0) {
      LogUtil.v('music_search_suggestion 数据请求');

      /// 请求数据
      _searchViewModel.loadSuggestion(keyword);
    } else {
      LogUtil.v('music_search_suggestion 清空');
      _searchViewModel.setSearchSuggestEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchViewModel = MusicSearchViewModel.of(context, listen: true);
    LogUtil.v(
        'MusicSearchSuggestion build count=> ${searchViewModel.searchSuggest.length}');
    var titleColor = AppTheme.titleColor(context);
    var subTitleColor = AppTheme.subtitleColor(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: AppTheme.scaffoldBackgroundColor(context),
        height: Inchs.screenHeight - Inchs.statusBarHeight + 44,
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: searchViewModel.searchSuggest.length,
          itemBuilder: (context, index) {
            return _buildSuggestItem(searchViewModel.searchSuggest[index],
                searchViewModel.suggestionKeyWord, titleColor, subTitleColor);
          },
        ),
      ),
    );
  }

  Widget _buildSuggestItem(MusicSearchSuggestMatch suggestItem, String keyWord,
      Color titleColor, Color subTitleColor) {
    if (suggestItem.isEmpty) {
      return InkWell(
        onTap: () {
          widget.onSearch?.call(suggestItem.keyword);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
          child: Text(
            '搜索 "${suggestItem.keyword}"',
            style: AppTheme.subtitleStyle(context).copyWith(color: Colors.blue),
          ),
        ),
      );
    }
    var title = (suggestItem.keyword.length >= keyWord.length)
        ? suggestItem.keyword.substring(0, keyWord.length)
        : '';
    var subTitle = (suggestItem.keyword.length >= keyWord.length)
        ? suggestItem.keyword.substring(keyWord.length)
        : suggestItem.keyword;

    return InkWell(
      onTap: () {
        widget.onSearch?.call(suggestItem.keyword);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 22,
              color: subTitleColor,
            ),
            QYSpacing(
              width: 5,
            ),
            RichText(
              text: TextSpan(
                  text: title,
                  style: AppTheme.subtitleStyle(context).copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  children: [
                    TextSpan(
                        text: subTitle,
                        style: AppTheme.subtitleStyle(context)
                            .copyWith(color: subTitleColor, fontSize: 16))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
