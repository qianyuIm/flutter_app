
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/model/search/music_hot_search.dart';
import 'package:flutter_app/model/search/music_search_suggest_match.dart';
import 'package:flutter_app/network/music_api/music_api_search_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:provider/provider.dart';

const int _maxHistoryLength = 15;

class MusicSearchViewModel extends ViewStateModel {
  List<String> historyItems = [];
  List<MusicHotSearch> _hotSearchItems = [];
  List<MusicHotSearch> showHotSearchItems = [];
  List<MusicSearchSuggestMatch> searchSuggest = [];
  bool showAllHot = false;
  String suggestionKeyWord = '';

  /// 是否有历史搜索记录
  bool get hasHistory => historyItems.length != 0;
  MusicSearchViewModel() {
    loadHistory();
  }

  static MusicSearchViewModel of(BuildContext context, {bool listen = false}) {
    return Provider.of<MusicSearchViewModel>(context, listen: listen);
  }
  
  setSearchSuggestEmpty() {
    searchSuggest = [];
    notifyListeners();
  }
  /// 加载建议数据
  Future loadSuggestion(String keyWord) async {
    suggestionKeyWord = keyWord;
    searchSuggest = await MusicApiSearchImp.loadSearchSuggestData(keyWord);
    notifyListeners();
  }

  /// 加载热搜列表
  Future<List<MusicHotSearch>> loadHotSearch() async {
    if (_hotSearchItems.length == 0) {
      _hotSearchItems = await MusicApiSearchImp.loadSearchHotData();
      if (_hotSearchItems.length > 10) {
        notifyListeners();
        showHotSearchItems.addAll(_hotSearchItems.sublist(0, 10));
      } else {
        showHotSearchItems.addAll(_hotSearchItems);
      }
    }
    return _hotSearchItems;
  }
  bool hotMoreThan10() {
    return _hotSearchItems.length > 10;
  }
  double getMaxGridHeight() {
    return _hotSearchItems.length / 2 * 50.0;
  }

  switchShowAll() {
    showAllHot = !showAllHot;
    if (showAllHot) {
      showHotSearchItems.addAll(_hotSearchItems.sublist(10));
    } else {
      showHotSearchItems.sublist(0, 10);
    }
    notifyListeners();
  }

  /// 加载历史记录
  void loadHistory() {
    /// 从数据库查找
    historyItems =
        SpUtil.getStringList(SpConfig.musicSearchHistoryKey, defValue: [])!;
  }

  /// 插入记录
  void insertHistory(String history) {
    if (historyItems.contains(history)) {
      historyItems.remove(history);
    }
    if (historyItems.length == 0) {
      historyItems.add(history);
    } else {
      historyItems.insert(0, history);
    }

    /// 判断个数
    if (historyItems.length >= _maxHistoryLength) {
      historyItems = historyItems.sublist(0, _maxHistoryLength);
    }

    notifyListeners();
    _putLocal();
  }

  void clearHistory() {
    historyItems = [];
    notifyListeners();
    _putLocal();
  }

  void _putLocal() async {
    await SpUtil.putStringList(SpConfig.musicSearchHistoryKey, historyItems);
  }
}
