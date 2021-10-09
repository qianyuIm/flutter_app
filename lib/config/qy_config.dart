import 'package:flutter_app/config/category_item.dart';
import 'package:flutter_app/router/router_manger.dart';

const String kFijkExceptionUrl = 'https://';

class QYConfig {
  /// 是否本地数据
  static bool isLocalJson = false;
  // static bool isLocalJson = true;

  /// 本地数据请求延时
  static Duration localJsonDelayed = Duration(milliseconds: 1000);

  static bool isDebug = true;

  /// 主题支持列表
  static final appThemeIndexSupport = <int, String>{
    0: "网易红",
    1: "滴滴橙",
    2: "微信绿",
    3: "闲鱼黄",
    4: "夸克紫",
  };

  /// 字体列表
  static final appFontFamilySupport = [
    'system',
    'KuaiLe',
  ];

  /// 音质支持
  /// 0 自动选择
  /// 128000 标准
  /// 192000 较高
  /// 320000 极高
  /// 999000 无损音质
  static final appMusicQualitySupport = <int, String>{
    0: "自动选择",
    128000: "标准",
    192000: "较高",
    320000: "极高",
    999000: "无损音质",
  };

  /// 语言支持
  static final appLocaleSupport = ['auto', 'zh-CN', 'en'];

  /// 深色模式支持
  static final darkModeSupport = ['auto', 'normal', 'dark'];

  /// 音乐页面分类列表
  static final musicCategorySupport = [
    CategoryItem(
        imageName: 'music_daily_recommend',
        titleValue: 'Recommend Daily',
        routeName: MyRouterName.music_daily_recommend,
        titleKey: 'recommend_daily'),
    CategoryItem(
        imageName: 'music_private_fm',
        titleValue: 'Private FM',
        routeName: '',
        titleKey: 'private_fm'),
    CategoryItem(
        imageName: 'music_play_list',
        titleValue: 'Playlist',
        routeName: MyRouterName.play_list_container,
        titleKey: 'play_list'),
    CategoryItem(
        imageName: 'music_ranking_list',
        titleValue: 'Rank List',
        routeName: MyRouterName.music_ranking_list,
        titleKey: 'rank_list'),

    // MusicCategoryItem('music_live', '直播', ''),
    // MusicCategoryItem('music_digital_album', '数字专辑', ''),
    // MusicCategoryItem('music_focus_meditation', '专注冥想', ''),
    // MusicCategoryItem('music_karaoke_room', '歌房', ''),
    // MusicCategoryItem('music_game_zone', '游戏专区', ''),
  ];
}
