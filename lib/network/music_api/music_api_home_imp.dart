import 'dart:convert';

import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_personalized.dart';
import 'package:flutter_app/model/music/home/music_banner.dart';
import 'package:flutter_app/model/music/home/music_calendar.dart';
import 'package:flutter_app/model/music/home/music_per_new_song.dart';
import 'package:flutter_app/model/music/home/music_personalized.dart';
import 'package:flutter_app/model/music/home/music_privatecontent.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
/// music home 相关接口
class MusicApiHomeImp {
  /// 轮播图接口
  static String kBannerUrl = '/banner?type=2';

  /// 推荐歌单
  static String kPersonalizedUrl = '/personalized?limit=10';

  /// 独家放送
  static String kPrivatecontentUrl = '/personalized/privatecontent';

  /// 推荐新音乐
  static String kPersonalizedNewsongUrl = '/personalized/newsong';

  /// 推荐MV
  static String kPersonalizedMvUrl = '/personalized/mv';
/// 推荐电台
  static String kPersonalizedDjProgramUrl = '/personalized/djprogram';

  /// 音乐日历(登录后)
  static String kCalendarUrl = '/calendar';

  /// music banner数据
  static Future loadBannerData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_banner);
      var object = json.decode(response);
      return object['banners']
          .map<MusicBanner>((banner) => MusicBanner.fromJson(banner))
          .toList();
    }
    var response = await musicApi.get(kBannerUrl);
    return response.data['banners']
        .map<MusicBanner>((banner) => MusicBanner.fromJson(banner))
        .toList();
  }

  /// 推荐歌单(未登录)数据
  static Future<List<MusicPersonalized>> loadPersonalizedData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_home_personalized);
      var map = json.decode(response);
      return map['result']
          .map<MusicPersonalized>(
              (personalized) => MusicPersonalized.fromJson(personalized))
          .toList();
    }
    var response = await musicApi.get(kPersonalizedUrl);
    return response.data['result']
        .map<MusicPersonalized>(
            (personalized) => MusicPersonalized.fromJson(personalized))
        .toList();
  }

  /// 独家放送 3个
static Future<List<MusicPrivateContent>> loadPrivatecontentData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_privatecontent);
      var map = json.decode(response);
      return map['result']
          .map<MusicPrivateContent>(
              (privateContent) => MusicPrivateContent.fromJson(privateContent))
          .toList();
    }
    var response = await musicApi.get(kPrivatecontentUrl);
    return response.data['result']
        .map<MusicPrivateContent>((privateContent) => MusicPrivateContent.fromJson(privateContent))
        .toList();
  }
  /// 推荐新音乐 十首
  static Future<List<MusicPerNewSong>> loadPersonalizedNewSongData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_newsong);
      var map = json.decode(response);
      return map['result']
          .map<MusicPerNewSong>(
              (newSong) => MusicPerNewSong.fromJson(newSong))
          .toList();
    }
    var response = await musicApi.get(kPersonalizedNewsongUrl);
    return response.data['result']
        .map<MusicPerNewSong>((newSong) => MusicPerNewSong.fromJson(newSong))
        .toList();
  }

  /// 推荐MV 4首
  static Future<List<MusicMV>> loadPersonalizedMvData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_mv);
      var map = json.decode(response);
      return map['result'].map<MusicMV>((mv) => MusicMV.fromJson(mv)).toList();
    }
    var response = await musicApi.get(kPersonalizedMvUrl);
    return response.data['result']
        .map<MusicMV>((mv) => MusicMV.fromJson(mv))
        .toList();
  }
  /// 推荐电台 
  static Future<List<MusicDjPersonalized>> loadPersonalizedDjProgramData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_djprogram);
      var map = json.decode(response);
      return map['result'].map<MusicDjPersonalized>((dj) => MusicDjPersonalized.fromJson(dj)).toList();
    }
    var response = await musicApi.get(kPersonalizedDjProgramUrl);
    return response.data['result']
        .map<MusicDjPersonalized>((dj) => MusicDjPersonalized.fromJson(dj))
        .toList();
  }

  /// 音乐日历 登录
  static Future<List<MusicCalendar>> loadCalendarUrlData(
      {required int startTime, required int endTime}) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_home_calendar);
      var map = json.decode(response);
      return map['data']['calendarEvents']
          .map<MusicCalendar>((calendar) => MusicCalendar.fromJson(calendar))
          .toList();
    }
    var response = await musicApi.get(kCalendarUrl,
        queryParameters: {'startTime': startTime, 'endTime': endTime});
    return response.data['data']['calendarEvents']
        .map<MusicCalendar>((calendar) => MusicCalendar.fromJson(calendar))
        .toList();
  }
}
