import 'package:flutter/services.dart';
import 'package:flutter_app/helper/string_helper.dart';

enum LocalJsonType {
  /// banner
  music_home_banner,

  /// 推荐歌单
  music_home_personalized,

  /// 独家放送
  music_home_privatecontent,

  /// 推荐最新音乐
  music_home_newsong,

  /// 推荐mv
  music_home_mv,

  /// 推荐电台
  music_home_djprogram,

  /// 音乐日历
  music_home_calendar,

  /// 视频评论
  music_comment_internal_video,

  /// 视频标签/分类下的视频
  music_internal_video_group,

  /// 视频分类标签列表
  music_internal_video_group_list,

  /// 视频推荐视频
  music_internal_video_recommend,

  /// mv
  music_internal_mv,

  /// 默认搜索关键词
  music_search_default,

  /// 热搜搜索关键词
  music_search_hot,

  /// 搜索建议
  music_search_suggest,

  /// 单曲搜索结果
  music_search_result_song,

  /// 专辑搜索结果
  music_search_result_album,

  /// 歌手搜索结果
  music_search_result_artist,

  /// 视频搜索结果
  music_search_result_video,

  /// 歌单搜索结果
  music_search_result_playList,

  /// 歌词搜索结果
  music_search_result_lyric,

  /// mv搜索结果
  music_search_result_mv,

  /// 电台搜索结果
  music_search_result_djRadio,

  /// 用户搜索结果
  music_search_result_userprofile,

  /// 电台banner
  music_dj_banner,

  /// 电台个性化推荐
  music_dj_personalize_recommend,

  /// 电台24小时节目榜
  music_dj_program_hours,

  /// 电台节目榜
  music_dj_program_toplist,

  /// 电台新晋\热门电台榜
  music_dj_toplist,

  /// 电台24小时主播榜
  music_dj_toplist_hours,

  /// 电台新人主播榜
  music_dj_toplist_new_comer,

  /// 电台最热主播榜
  music_dj_toplist_popular,

  /// 电台 分类
  music_dj_categories,

  /// 电台推荐类型
  music_dj_category_recommend,

  /// 歌单分类
  music_play_list_categorys,
  /// 分类歌单
  music_top_play_list,
  /// 用户歌单
  music_user_playlist,
  /// 歌单详情
  music_play_list_detail,
  /// 歌单详情歌曲信息
  music_play_list_songs

  

}

class LocalJsonHelper {
  /// 获取本地json数据
  static Future<String> localJson(LocalJsonType localJsonType) async {
    switch (localJsonType) {
        
      /// music home 相关
      case LocalJsonType.music_home_banner:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_banner'));
      case LocalJsonType.music_home_personalized:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_personalized'));
      case LocalJsonType.music_home_privatecontent:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_privatecontent'));
      case LocalJsonType.music_home_newsong:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_newsong'));
      case LocalJsonType.music_home_mv:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_mv'));
      case LocalJsonType.music_home_djprogram:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_djprogram'));
      case LocalJsonType.music_home_calendar:
        return rootBundle
            .loadString(StringHelper.wrapJsonHome('music_home_calendar'));

      /// music internal video  mv 相关
      case LocalJsonType.music_comment_internal_video:
        return rootBundle.loadString(
            StringHelper.wrapJsonComment('music_comment_internal_video'));
      case LocalJsonType.music_internal_video_group:
        return rootBundle.loadString(
            StringHelper.wrapJsonInternal('music_internal_video_group'));
      case LocalJsonType.music_internal_video_recommend:
        return rootBundle.loadString(
            StringHelper.wrapJsonInternal('music_internal_video_recommend'));
      case LocalJsonType.music_internal_video_group_list:
        return rootBundle.loadString(
            StringHelper.wrapJsonInternal('music_internal_video_group_list'));
      case LocalJsonType.music_internal_mv:
        return rootBundle
            .loadString(StringHelper.wrapJsonInternal('music_internal_mv'));

      /// music search 相关
      case LocalJsonType.music_search_default:
        return rootBundle
            .loadString(StringHelper.wrapJsonSearch('music_search_default'));
      case LocalJsonType.music_search_hot:
        return rootBundle
            .loadString(StringHelper.wrapJsonSearch('music_search_hot'));
      case LocalJsonType.music_search_suggest:
        return rootBundle
            .loadString(StringHelper.wrapJsonSearch('music_search_suggest'));
      case LocalJsonType.music_search_result_song:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_song'));
      case LocalJsonType.music_search_result_album:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_album'));
      case LocalJsonType.music_search_result_artist:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_artist'));
      case LocalJsonType.music_search_result_lyric:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_lyric'));
      case LocalJsonType.music_search_result_djRadio:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_djRadio'));
      case LocalJsonType.music_search_result_mv:
        return rootBundle
            .loadString(StringHelper.wrapJsonSearch('music_search_result_mv'));
      case LocalJsonType.music_search_result_playList:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_playList'));
      case LocalJsonType.music_search_result_video:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_video'));
      case LocalJsonType.music_search_result_userprofile:
        return rootBundle.loadString(
            StringHelper.wrapJsonSearch('music_search_result_userprofile'));

      /// music dj 相关
      case LocalJsonType.music_dj_banner:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_banner'));
      case LocalJsonType.music_dj_personalize_recommend:
        return rootBundle.loadString(
            StringHelper.wrapJsonDj('music_dj_personalize_recommend'));
      case LocalJsonType.music_dj_program_hours:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_program_hours'));
      case LocalJsonType.music_dj_program_toplist:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_program_toplist'));
      case LocalJsonType.music_dj_toplist:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_toplist'));
      case LocalJsonType.music_dj_toplist_hours:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_toplist_hours'));
      case LocalJsonType.music_dj_toplist_new_comer:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_toplist_new_comer'));
      case LocalJsonType.music_dj_toplist_popular:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_toplist_popular'));
      case LocalJsonType.music_dj_categories:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_categories'));
      case LocalJsonType.music_dj_category_recommend:
        return rootBundle
            .loadString(StringHelper.wrapJsonDj('music_dj_category_recommend'));
      
      
      case LocalJsonType.music_play_list_categorys:
        return rootBundle
            .loadString(StringHelper.wrapJsonPlaylist('music_play_list_categorys'));
      case LocalJsonType.music_top_play_list:
        return rootBundle
            .loadString(StringHelper.wrapJsonPlaylist('music_top_play_list'));
      case LocalJsonType.music_user_playlist:
        return rootBundle
            .loadString(StringHelper.wrapJsonPlaylist('music_user_playlist'));
      case LocalJsonType.music_play_list_detail:
        return rootBundle
            .loadString(StringHelper.wrapJsonPlaylist('music_play_list_detail'));
      
      case LocalJsonType.music_play_list_songs:
        return rootBundle
            .loadString(StringHelper.wrapJsonPlaylist('music_play_list_songs'));
      default:
        return '';
    }
  }
}
