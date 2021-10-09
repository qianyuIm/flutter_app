import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'package:flustars/flustars.dart';
import 'package:flutter_app/app_start.dart';
import 'package:flutter_app/config/category_item.dart';
import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/helper/bool_helper.dart';
import 'package:flutter_app/helper/http_helper.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/comment/comment_container.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/model/music/internal_video_urlInfo.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_artist_detail.dart';
import 'package:flutter_app/model/music/music_daily_recommend.dart';
import 'package:flutter_app/model/music/music_lyric.dart';
import 'package:flutter_app/model/music/music_metadata.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_ranking.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_user_box_event.dart';
import 'package:flutter_app/model/music/video_category.dart';

import 'package:flutter_app/network/base_api.dart';

final MusicApi musicApi = MusicApi();

class MusicApi extends BaseApi {
  /// 默认 0 全部
  static final mvAllAreaSupport = <int, CategoryItem>{
    -1: CategoryItem(
      titleKey: 'region',
      titleValue: 'Region:'
    ),
    0: CategoryItem(
      titleKey: 'all',
      titleValue: 'All'
    ),
    1: CategoryItem(
      titleKey: 'mainland',
      titleValue: 'Mainland'
    ),
    2: CategoryItem(
      titleKey: 'ht',
      titleValue: 'HT'
    ),
    3: CategoryItem(
      titleKey: 'ea',
      titleValue: 'EA'
    ),
    4: CategoryItem(
      titleKey: 'kr',
      titleValue: 'KR'
    ),
    5: CategoryItem(
      titleKey: 'jp',
      titleValue: 'JP'
    ),
  };

  /// 默认 0 全部
  static final mvAllTypeSupport = <int, CategoryItem>{
    -1: CategoryItem(
      titleKey: 'type',
      titleValue: 'Type:'
    ),
    0: CategoryItem(
      titleKey: 'all',
      titleValue: 'All'
    ),
    1: CategoryItem(
      titleKey: 'official',
      titleValue: 'Official'
    ),
    2: CategoryItem(
      titleKey: 'native',
      titleValue: 'Native'
    ),
    3: CategoryItem(
      titleKey: 'live',
      titleValue: 'Live'
    ),
    4: CategoryItem(
      titleKey: 'netease',
      titleValue: 'Netease'
    ),
  };

  /// 默认 2 最新
  static final mvAllOrderSupport = <int, CategoryItem>{
    -1: CategoryItem(
      titleKey: 'sort',
      titleValue: 'Sort:'
    ),
    0: CategoryItem(
      titleKey: 'fastest_rising',
      titleValue: 'Fastest Rising'
    ),
    1: CategoryItem(
      titleKey: 'hottest',
      titleValue: 'Hottest'
    ),
    2: CategoryItem(
      titleKey: 'latest',
      titleValue: 'Latest'
    ),
  };

  /// 歌手详情页面使用这个请求不成功
  // static String kBaseUrl = 'http://120.53.224.74:3000';
  static String kBaseUrl = 'https://music-api-ten.vercel.app/';

  
  /// 每日推荐歌曲
  static String kDailyRecommendSongsUrl = '/recommend/songs';

  /// 排行榜内容摘要
  static String kToplistDetailUrl = '/toplist/detail';

  /// 歌手排行榜
  static String kToplistArtistlUrl = '/toplist/artist';

  /// 歌手详情
  static String kArtistDetailUrl = '/artist/detail';

  ///相似歌手
  static String kSimiArtistsUrl = '/simi/artist';

  /// 用户动态
  static String kUserEventUrl = '/user/event';

  

  
  /// 获取音乐 url
  static String kSongUrl = '/song/url';

  /// 获取歌词
  static String kLyricUrl = '/lyric?';

  /// 获取歌曲评论
  static String kSongCommentUrl = '/comment/music';

  /// 获取视频地址
  static String kVideoUrl = '/video/url';

  /// 歌手MV
  static String kArtistMvUrl = '/artist/mv';

  /// 获取mv播放地址
  static String kMVUrl = '/mv/url';

  /// mv 详细数据
  static String kMVDetailUrl = '/mv/detail';

  /// 获取 mv 点赞转发评论数数据
  static String kMVDetaiInfoUrl = '/mv/detail/info';

  /// 歌手热门50首歌曲
  static String kArtistTopSongUrl = '/artist/top/song';

  /// 歌手的全部专辑
  static String kArtistAlbumsUrl = '/artist/album';

  /// 资源点赞
  static String kResourceLikeUrl = 'resource/like';

  /// 视频分类列表
  static String kVideoCategoryListUrl = '/video/category/list';

  /// 获取推荐视频
  static String kVideoTimelineRecommendUrl = '/video/timeline/recommend';

  /// 获取视频标签/分类下的视频
  static String kVideoGroupUrl = '/video/group';

  /// 获取视频标签列表
  static String kVideoGroupList = '/video/group/list';

  /// 获取全部的MV
  static String kMvAllUrl = '/mv/all';

  /// 获取视频评论
  static String kCommentVideoUrl = '/comment/video';

  /// 新版获取视频评论
  static String kNewCommentVideoUrl = '/comment/new';

  /// 获取热门评论
  static String kHotCommentUrl = 'comment/hot';

  

  @override
  void init() {
    options.baseUrl = kBaseUrl;
    options.followRedirects = false;
    interceptors.add(MusicInterceptor());
    interceptors.add(CookieManager(PersistCookieJar(
        ignoreExpires: true,
        storage:
            FileStorage(AppStart.temporaryDirectory.path + "/.cookies/"))));
  }

  

  /// 获取每日推荐歌单
  static Future loadkDailyRecommendSongsData() async {
    var response = await musicApi.get(kDailyRecommendSongsUrl);
    return MusicDailyRecommend.fromJson(response.data['data']);
  }

  /// 获取排行榜内容摘要
  static Future loadToplistDetailData() async {
    var response = await musicApi.get(kToplistDetailUrl);
    return MusicRanking.fromJson(response.data);
  }

  /// 获取歌手排行榜 1: 华语 2: 欧美 3: 韩国 4: 日本
  static Future loadToplistArtistData(int type) async {
    var response = await musicApi
        .get(kToplistArtistlUrl, queryParameters: {'type': '$type'});
    return response.data['list']['artists']
        .map<MusicArtist>((artist) => MusicArtist.fromJson(artist))
        .toList();
  }

  /// 歌手详情
  static Future loadArtistDetailData(int artistId) async {
    var response = await musicApi
        .get(kArtistDetailUrl, queryParameters: {'id': '$artistId'});
    return MusicArtistDetail.fromJson(response.data['data']);
  }

  /// 相似歌手
  static Future loadSimiArtistsData(int artistId) async {
    var response = await musicApi
        .get(kSimiArtistsUrl, queryParameters: {'id': '$artistId'});
    return response.data['artists']
        .map<MusicArtist>((artist) => MusicArtist.fromJson(artist))
        .toList();
  }

  /// 获取用户动态
  static Future loadUserEventData(int uid, int? lasttime) async {
    var queryParameters = {'uid': uid, 'limit': 30};
    if (lasttime != null) {
      queryParameters['lasttime'] = lasttime;
    }
    var response =
        await musicApi.get(kUserEventUrl, queryParameters: queryParameters);
    return MusicUserBoxEvent.fromJson(response.data);
  }

  

  
  /// 获取音乐URL
  static Future<List<MusicMetadata>> loadSongUrlData(int id) async {
    /// 从缓存中查找歌曲url 判断是否过期
    var song = await LocalDb.instance.currentPlayingDb.queryOne(id);
    if (song?.metadata != null) {
      if (!song!.metadata!.isExpi) {
        return [song.metadata!];
      }
    }
    var response = await musicApi.get(kSongUrl, queryParameters: {'id': id});
    return response.data['data']
        .map<MusicMetadata>(
            (metadata) {
              var metadataItem = MusicMetadata.fromJson(metadata);
              metadataItem.insertDbTime = TimeHelper.now();
              return metadataItem;
              })
        .toList();
  }

  /// 获取歌词信息
  static Future<MusicLyric> loadSongLyricData(int songId) async {
    /// 从缓存中查找歌词
    var lyric = await LocalDb.instance.musicLyricDb.queryOne(songId);
    if (lyric != null) {
      return lyric;
    }
    var response =
        await musicApi.get(kLyricUrl, queryParameters: {'id': songId});
    var lyricItem = MusicLyric.fromJson(response.data);
    lyricItem.songId = songId;
    LocalDb.instance.musicLyricDb.insert(lyricItem);
    return lyricItem;
  }

  static Future loadSongCommontData(int songId) async {
    
  }

  /// 获取视频 播放地址 => UrlInfo
  static Future<List<InternalVideoUrlInfo>> loadVideoUrlData(
      String videoId) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      return [
        InternalVideoUrlInfo.fromJson(
            {'url': 'https://static.ybhospital.net/test-video-1.mp4'})
      ];
    }

    var response =
        await musicApi.get(kVideoUrl, queryParameters: {'id': videoId});
    return response.data['urls']
        .map<InternalVideoUrlInfo>((url) => InternalVideoUrlInfo.fromJson(url))
        .toList();
  }

  /// 获取mv播放地址 分辨率默认1080
  static Future<MusicMVUrl> loadMVUrlData(int mvId, {int r = 480}) async {
    var response =
        await musicApi.get(kMVUrl, queryParameters: {'id': mvId, 'r': r});

    /// 这里做http => https
    var musicuRL = MusicMVUrl.fromJson(response.data['data']);
    musicuRL.url = HttpHelper.transform(musicuRL.url);
    return musicuRL;
  }

  /// 获取mv详情
  static Future<InternalMvDetail> loadMVDetaiData(int mvid) async {
    var response =
        await musicApi.get(kMVDetailUrl, queryParameters: {'mvid': mvid});
    return InternalMvDetail.fromJson(response.data);
  }

  /// 获取 mv 点赞转发评论数数据
  static Future<InternalMvDetailInfo> loadMVDetaiInfoData(int mvid) async {
    var response =
        await musicApi.get(kMVDetaiInfoUrl, queryParameters: {'mvid': mvid});
    return InternalMvDetailInfo.fromJson(response.data);
  }

  /// 获取视频播放地址
  static Future loadArtistMvData(int artistId, int offset) async {
    var response = await musicApi.get(kArtistMvUrl,
        queryParameters: {'id': artistId, 'limit': 20, 'offset': offset});
    return response.data;
  }

  /// 获取歌手的50首人们歌曲
  static Future loadArtistTopSongData(int artistId) async {
    var response = await musicApi
        .get(kArtistTopSongUrl, queryParameters: {'id': artistId});
    return response.data['songs']
        .map<MusicSong>((url) => MusicSong.fromJson(url))
        .toList();
  }

  /// 获取歌手的50首人们歌曲
  static Future loadArtistAlbumsData(int artistId, int offset) async {
    var response = await musicApi.get(kArtistAlbumsUrl,
        queryParameters: {'id': artistId, 'limit': 30, 'offset': offset});
    return response.data;
  }

  /// 资源点赞
  /// id 资源id
  /// type 1: mv,4: 电台,6: 动态
  static Future<bool> loadResourceLikeData(bool liked, int id, int type) async {
    var response = await musicApi.get(kResourceLikeUrl, queryParameters: {
      'id': id,
      'type': type,
      't': BoolHelper.intValue(liked)
    });
    LogUtil.v(response);

    return response.data['code'] == 200;
  }

  /// 获取视频标签列表
  static Future loadVideoGroupListData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_internal_video_group_list);

      var object = json.decode(response);
      return object['data']
          .map<VideoCategory>((category) => VideoCategory.fromJson(category))
          .toList();
    }
    var response = await musicApi.get(kVideoGroupList);
    return response.data['data']
        .map<VideoCategory>((category) => VideoCategory.fromJson(category))
        .toList();
  }

  /// 视频分类列表
  static Future loadVideoCategoryListData() async {
    var response = await musicApi.get(kVideoCategoryListUrl);
    return response.data['data']
        .map<VideoCategory>((category) => VideoCategory.fromJson(category))
        .toList();
  }

  /// 获取推荐视频
  static Future loadVideoTimelineRecommendData(int offset) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_internal_video_recommend);
      var object = json.decode(response);
      return object;
    }
    var response = await musicApi.get(kVideoTimelineRecommendUrl,
        queryParameters: {
          'offset': offset,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
    return response.data;
  }

  /// 获取视频标签/分类下的视频
  static Future loadVideoGroupData(int categoryId, int offset) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_internal_video_group);
      var object = json.decode(response);
      return object;
    }

    var response = await musicApi.get(kVideoGroupUrl,
        queryParameters: {'id': categoryId, 'offset': offset});
    return response.data;
  }

  /// 获取全部的MV
  static Future loadMvAllData(int area, int type, int order, int offset) async {
    var areaString = mvAllAreaSupport[area];
    var typeString = mvAllTypeSupport[type];
    var orderString = mvAllOrderSupport[order];
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_internal_mv);
      var object = json.decode(response);
      return object;
    }
    var response = await musicApi.get(kMvAllUrl, queryParameters: {
      'area': areaString,
      'type': typeString,
      'order': orderString,
      'limit': 30,
      'offset': offset,
    });
    return response.data;
  }

  /// 获取视频评论数据
  static Future<CommentContainer> loadCommentVideoData(String videoId,
      {int limit = 20, required int offset, int? before}) async {
    Map<String, dynamic> _queryParameters = {};
    if (before == null) {
      _queryParameters = {'id': videoId, 'limit': limit, 'offset': offset};
    } else {
      _queryParameters = {
        'id': videoId,
        'limit': limit,
        'offset': offset,
        'before': before
      };
    }
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_comment_internal_video);

      var object = json.decode(response);
      return CommentContainer.fromJson(object);
    }

    var response =
        await musicApi.get(kCommentVideoUrl, queryParameters: _queryParameters);
    return CommentContainer.fromJson(response.data);
  }

  /// 新版评论接口
  /// resourceId: 资源id
  /// commentType: 数字 , 资源类型 , 对应歌曲 , mv, 专辑 , 歌单 , 电台, 视频对应以下类型
  /// sortType: 排序方式 : 2:按热度排序,3:按时间排序 ， 按推荐排序 数字不确定
  /// pageNo: 分页参数,第N页,默认为1
  /// pageSize: 分页参数,每页多少条数据,默认20
  static Future<CommentContainer> loadNewCommentData(
      String resourceId, int commentType,
      {int sortType = 3,
      int pageNo = 1,
      int pageSize = 20,
      String? cursor}) async {
    /// 组合参数
    Map<String, dynamic> _queryParameters = {};
    _queryParameters = {
      'id': resourceId,
      'type': commentType,
      'sortType': sortType,
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    if (sortType == 3 && pageNo != 1) {
      assert(cursor != null, 'cursor 不能为mull');
      _queryParameters['cursor'] = cursor;
    }

    var response = await musicApi.get(kNewCommentVideoUrl,
        queryParameters: _queryParameters);
    return CommentContainer.fromJson(response.data['data']);
  }

  
}

class MusicInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// 添加一个固定参数
    options.queryParameters['realIP'] = '116.25.146.177';
    LogUtil.v('请求 => ${options.uri}');
    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    /// 判断请求回来的结果
    if (response.data['code'] != 200 && response.data['msg'] != null) {
      throw MusicException(response.data['msg'] as String);
    }
    // LogUtil.v('请求完成 => ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 301) {
      throw const UnAuthorizedException();
    }
    super.onError(err, handler);
  }
}

///  一些错误提示
class MusicException implements Exception {
  final String? message;
  const MusicException(this.message);
  @override
  String toString() => 'MusicException ${this.message}';
}

/// 用于未登录,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();
  @override
  String toString() => 'UnAuthorizedException';
}
