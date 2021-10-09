import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/search/music_search_bar.dart';
import 'package:flutter_app/page/search/music_search_normal.dart';
import 'package:flutter_app/page/search/music_search_suggestion.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/search/music_search_view_model.dart';
import 'package:provider/provider.dart';

enum SearchContainerBody { normal, suggestions }

class MusicSearchContainer extends StatefulWidget {
  @override
  _MusicSearchContainerState createState() => _MusicSearchContainerState();
}

class _MusicSearchContainerState extends State<MusicSearchContainer> {
  late TextEditingController _textController;
  late ValueNotifier<String> _onTextChanged = ValueNotifier('-1');
  late ValueNotifier<SearchContainerBody?> _currentBodyNotifier =
      ValueNotifier(null);
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _currentBody = SearchContainerBody.normal;
    _textController = TextEditingController();
    _textController.addListener(_textControllerListener);
    _onTextChanged.addListener(_textChangedListener);
    _currentBodyNotifier.addListener(_onInputBodyChanged);

    /// 延迟一个动画的时长
    Future.delayed(Duration(milliseconds: 330), () {
      _focusNode.requestFocus();
    });

    super.initState();
  }

  @override
  void dispose() {
    _onTextChanged.removeListener(_textChangedListener);
    _textController.removeListener(_textControllerListener);
    _currentBodyNotifier.removeListener(_onInputBodyChanged);

    _textController.dispose();
    super.dispose();
  }

  SearchContainerBody? get _currentBody => _currentBodyNotifier.value;
  set _currentBody(SearchContainerBody? value) {
    _currentBodyNotifier.value = value;
  }

  void _textControllerListener() {
    LogUtil.v('数文字变化');
    _onTextChanged.value = _textController.text;
  }

  void _textChangedListener() {
    if (_onTextChanged.value.length > 0) {
      _currentBody = SearchContainerBody.suggestions;
    } else {
      _currentBody = SearchContainerBody.normal;
    }
  }

  void _onInputBodyChanged() {
    LogUtil.v('刷新页面');
    setState(() {});
  }

  void _onSearch(BuildContext context, String keyWord) {
    if (keyWord.length <= 0) return;
    var searchViewModel = MusicSearchViewModel.of(context);
    searchViewModel.insertHistory(keyWord);
    _focusNode.unfocus();
    _textController.clear();
    Navigator.of(context)
        .pushNamed(MyRouterName.music_search_result, arguments: keyWord)
        .then((value) {
      if (value == null) return;
      var parameter = value as Map;
      if (parameter['showKeyBoard'] != null) {
        var showKeyBoard = parameter['showKeyBoard'] as bool;
        if (showKeyBoard) _focusNode.requestFocus();
      }
      if (parameter['searchWord'] != null) {
        var searchWord = parameter['searchWord'] as String;
        _textController.text = searchWord;
      }
    });
  }

  /// searchBar
  Widget _buildSearchBar(BuildContext context) {
    return MusicSearchBar(
      controller: _textController,
      focusNode: _focusNode,
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSearch: (value) {
        _onSearch(context, value);
      },
    );
  }

  Widget _buildNormal(BuildContext context) {
    return MusicSearchNormal(
      onSearch: (value) {
        _onSearch(context, value);
      },
    );
  }

  Widget _buildSuggestion(BuildContext context) {
    return MusicSearchSuggestion(
      textController: _textController,
      onSearch: (value) {
        _onSearch(context, value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? body;
    switch (_currentBody) {
      case SearchContainerBody.normal:
        body = KeyedSubtree(
          key: const ValueKey<SearchContainerBody>(SearchContainerBody.normal),
          child: Builder(
            builder: (context) {
              return _buildNormal(context);
            },
          ),
        );
        break;
      case SearchContainerBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<SearchContainerBody>(
              SearchContainerBody.suggestions),
          child: Builder(
            builder: (context) {
              return _buildSuggestion(context);
            },
          ),
        );
        break;
      case null:
        break;
    }
    return ChangeNotifierProvider(
      create: (context) => MusicSearchViewModel(),
      child: Scaffold(
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return _buildSearchBar(context);
              },
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 335),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
