import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'package:flutter_app/model/search/music_default_search.dart';
import 'package:flutter_app/model/search/music_hot_search.dart';
import 'package:flutter_app/model/search/music_search_result.dart';
import 'package:flutter_app/model/search/music_search_suggest_match.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'dart:convert';

import 'package:flutter_app/view_model/search/music_search_result_view_model.dart';

class MusicApiSearchImp {
  /// 默认搜索关键词
  static String kSearchDefaultUrl = '/search/default';

  /// 热搜列表(详细)
  static String kSearchHotUrl = '/search/hot/detail';

  /// 搜索建议
  static String kSearchSuggestUrl = '/search/suggest';

  /// 搜索
  static String kCloudSearchUrl = '/cloudsearch';
  static String kSearchUrl = '/search';

  /// 可获取默认搜索关键词
  static Future<MusicDefaultSearch> loadSearchDefaultData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_search_default);
      var object = json.decode(response);
      return MusicDefaultSearch.fromJson(object['data']);
    }
    var response = await musicApi.get(kSearchDefaultUrl);
    return MusicDefaultSearch.fromJson(response.data['data']);
  }

  /// 可获取热门搜索列表
  static Future<List<MusicHotSearch>> loadSearchHotData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_search_hot);

      var object = json.decode(response);
      return object['data']
          .map<MusicHotSearch>((hot) => MusicHotSearch.fromJson(hot))
          .toList();
    }
    var response = await musicApi.get(kSearchHotUrl);
    return response.data['data']
        .map<MusicHotSearch>((hot) => MusicHotSearch.fromJson(hot))
        .toList();
  }

  /// 传入搜索关键词可获得搜索建议
  static Future<List<MusicSearchSuggestMatch>> loadSearchSuggestData(
      String keywords,
      {String type = 'mobile',
      bool isLocalJson = false}) async {
    if (QYConfig.isLocalJson && isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_search_suggest);

      var object = json.decode(response);
      return object['result']['allMatch']
          .map<MusicSearchSuggestMatch>(
              (match) => MusicSearchSuggestMatch.fromJson(match))
          .toList();
    }
    var response = await musicApi.get(kSearchSuggestUrl,
        queryParameters: {'keywords': keywords, 'type': type});
    if (response.data['result']['allMatch'] == null) {
      return [MusicSearchSuggestMatch(keywords, true)];
    }
    return response.data['result']['allMatch']
        .map<MusicSearchSuggestMatch>(
            (match) => MusicSearchSuggestMatch.fromJson(match))
        .toList();
  }

  /// 搜索歌词的时候使用
  static Future<MusicSearchResult> loadSearchData(
      String keywords, int limit, int offset,
      {int type = 1}) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = '';
      if (type == 1) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_song);
      } else if (type == 10) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_album);
      } else if (type == 100) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_artist);
      } else if (type == 1000) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_playList);
      } else if (type == 1002) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_userprofile);
      } else if (type == 1004) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_mv);
      } else if (type == 1006) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_lyric);
      } else if (type == 1009) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_djRadio);
      } else if (type == 1014) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_video);
      }

      var object = json.decode(response);
      return MusicSearchResult.fromJson(object['result']);
    }
    var response = await musicApi.get(kSearchUrl, queryParameters: {
      'keywords': keywords,
      'limit': limit,
      'offset': offset,
      'type': type
    });
    return MusicSearchResult.fromJson(response.data['result']);
  }

  /// 传入搜索关键词可获得搜索结果
  static Future<MusicSearchResult> loadCloudSearchData(
      String keywords, int limit, int offset,
      {int type = 1}) async {
    if (type == MusicSearchType.lyrics.value ||
        type == MusicSearchType.comprehensive.value) {
      return loadSearchData(keywords, limit, offset, type: type);
    }
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = '';
      if (type == 1) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_song);
      } else if (type == 10) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_album);
      } else if (type == 100) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_artist);
      } else if (type == 1000) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_playList);
      } else if (type == 1002) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_userprofile);
      } else if (type == 1004) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_mv);
      } else if (type == 1006) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_lyric);
      } else if (type == 1009) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_djRadio);
      } else if (type == 1014) {
        response = await LocalJsonHelper.localJson(
            LocalJsonType.music_search_result_video);
      }
      var object = json.decode(response);
      return MusicSearchResult.fromJson(object['result']);
    }
    var response = await musicApi.get(kCloudSearchUrl, queryParameters: {
      'keywords': keywords,
      'limit': limit,
      'offset': offset,
      'type': type
    });
    return MusicSearchResult.fromJson(response.data['result']);
  }
}
