import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'dart:convert';

import 'package:flutter_app/model/music/dj/music_dj_banner.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie_recommend.dart';
import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/model/music/dj/music_dj_rank.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
/// music dj 相关接口
class MusicApiDjImp {
  /// 轮播图接口
  static String kDjBannerUrl = 'dj/banner';

  /// 电台个性推荐
  static String kDjPersonalizeRecommendUrl = 'dj/personalize/recommend';

  /// 电台 24小时节目榜
  static String kDJProgramToplistHoursUrl = '/dj/program/toplist/hours';

  /// 电台 节目榜 (入口在电台排行榜中)
  static String kDjProgramToplistUrl = 'dj/program/toplist';

  /// 电台 新晋/热门电台榜 (入口在电台排行榜中)
  static String kDjToplistUrl = 'dj/toplist';

  /// 电台 24小时主播榜
  static String kDJToplistHoursUrl = '/dj/toplist/hours';

  /// 电台主播新人榜
  static String kDJToplistNewComerUrl = '/dj/toplist/newcomer';

  /// 电台主播最热榜
  static String kDJToplistPopularUrl = '/dj/toplist/popular';

  /// 电台 分类
  static String kDjCatelistUrl = 'dj/catelist';

  /// 电台 推荐类型 需登录
  static String kDjCategoryRecommendUrl = 'dj/category/recommend';

  /// music DJ banner数据
  static Future<List<MusicDjBanner>> loadDJBannerData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_banner);
      var object = json.decode(response);
      return object['data']
          .map<MusicDjBanner>((banner) => MusicDjBanner.fromJson(banner))
          .toList();
    }
    var response = await musicApi.get(kDjBannerUrl);
    return response.data['data']
        .map<MusicDjBanner>((banner) => MusicDjBanner.fromJson(banner))
        .toList();
  }

  /// music 电台个性推荐
  static Future<List<MusicDjRadio>> loadDJPersonalizeRecommendData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_dj_personalize_recommend);
      var object = json.decode(response);
      return object['data']
          .map<MusicDjRadio>((radio) => MusicDjRadio.fromJson(radio))
          .toList();
    }
    var response = await musicApi.get(kDjPersonalizeRecommendUrl);
    return response.data['data']
        .map<MusicDjRadio>((radio) => MusicDjRadio.fromJson(radio))
        .toList();
  }

  /// music 电台 24小时节目榜 限制30个
  static Future<List<MusicDjRank>> loadDJProgramToplistHoursData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_program_hours);
      var object = json.decode(response);
      return object['data']['list']
          .map<MusicDjRank>((radio) => MusicDjRank.fromJson(radio))
          .toList();
    }
    var response = await musicApi
        .get(kDJProgramToplistHoursUrl, queryParameters: {'limit': 30});
    return response.data['data']['list']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  /// music 电台 节目榜 限制30个
  static Future<List<MusicDjRank>> loadDJProgramToplistData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_dj_program_toplist);
      var object = json.decode(response);
      return object['toplist']
          .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
          .toList();
    }
    var response = await musicApi
        .get(kDjProgramToplistUrl, queryParameters: {'limit': 30});
    return response.data['toplist']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  /// music 电台 新晋\热门电台榜 限制30个
  static Future<List<MusicDjRank>> loadDJToplistData(String type) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_toplist);
      var object = json.decode(response);
      return object['toplist']
          .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
          .toList();
    }
    var response = await musicApi
        .get(kDjToplistUrl, queryParameters: {'type': type, 'limit': 30});
    return response.data['toplist']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  /// music 电台 24小时主播榜 限制30个
  static Future<List<MusicDjRank>> loadDJToplistHoursData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_toplist_hours);
      var object = json.decode(response);
      return object['data']['list']
          .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
          .toList();
    }
    var response =
        await musicApi.get(kDJToplistHoursUrl, queryParameters: {'limit': 30});
    return response.data['data']['list']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  /// music 电台 主播新人榜 限制30个
  static Future<List<MusicDjRank>> loadDJToplistNewComerData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_toplist_hours);
      var object = json.decode(response);
      return object['data']['list']
          .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
          .toList();
    }
    var response = await musicApi
        .get(kDJToplistNewComerUrl, queryParameters: {'limit': 30});
    return response.data['data']['list']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  ///  music 电台 主播最热榜 限制30个
  static Future<List<MusicDjRank>> loadDJToplistPopularData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_dj_toplist_popular);
      var object = json.decode(response);
      return object['data']['list']
          .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
          .toList();
    }
    var response = await musicApi
        .get(kDJToplistPopularUrl, queryParameters: {'limit': 30});
    return response.data['data']['list']
        .map<MusicDjRank>((rank) => MusicDjRank.fromJson(rank))
        .toList();
  }

  /// music 电台 分类
  static Future<List<MusicDjCategorie>> loadDJCatelistData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_dj_categories);
      var object = json.decode(response);
      var categories = object['categories']
          .map<MusicDjCategorie>(
              (categorie) => MusicDjCategorie.fromJson(categorie))
          .toList() as List<MusicDjCategorie>;
      MusicDjCategorie radioCategorie =
          MusicDjCategorie('我的博客', -1, false, true);
      MusicDjCategorie rankCategorie = MusicDjCategorie('排行榜', -2, true, false);

      categories.insertAll(0, [radioCategorie, rankCategorie]);
      return categories;
    }
    var response = await musicApi.get(kDjCatelistUrl);
    var categories = response.data['categories']
        .map<MusicDjCategorie>(
            (categorie) => MusicDjCategorie.fromJson(categorie))
        .toList() as List<MusicDjCategorie>;
    MusicDjCategorie radioCategorie = MusicDjCategorie('我的博客', -1, false, true);
    MusicDjCategorie rankCategorie = MusicDjCategorie('排行榜', -2, true, false);

    categories.insertAll(0, [radioCategorie, rankCategorie]);
    return categories;
  }

  /// music 电台  推荐类型
  static Future<List<MusicDJCategorieRecommend>>
      loadDjCategoryRecommendData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_dj_category_recommend);
      var object = json.decode(response);

      return object['data']
          .map<MusicDJCategorieRecommend>(
              (categorie) => MusicDJCategorieRecommend.fromJson(categorie))
          .toList();
    }
    var response = await musicApi.get(kDjCategoryRecommendUrl);
    return response.data['data']
        .map<MusicDJCategorieRecommend>(
            (categorie) => MusicDJCategorieRecommend.fromJson(categorie))
        .toList();
  }
}
