import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/page/music/playList/music_play_list_category_page.dart';
import 'package:flutter_app/page/music/secondary/music_top_container_page.dart';
import 'package:flutter_app/page/setting/app_setting_page.dart';
import 'package:flutter_app/page/intro/intro_page.dart';
import 'package:flutter_app/page/music/artist/music_artist_page.dart';
import 'package:flutter_app/page/music/dj/music_dj_category_detail_page.dart';
import 'package:flutter_app/page/music/dj/music_dj_page.dart';
import 'package:flutter_app/page/music/dj/rank/music_dj_rank_container_page.dart';
import 'package:flutter_app/page/music/login/login_navigator.dart';
import 'package:flutter_app/page/music/playList/music_play_list_container_page.dart';
import 'package:flutter_app/page/music/playList/music_play_list_detail_page.dart';
import 'package:flutter_app/page/music/playList/music_playlist_subscriber_page.dart';
import 'package:flutter_app/page/music/playing/music_playing_page.dart';
import 'package:flutter_app/page/music/secondary/music_artist_ranking_list_page.dart';
import 'package:flutter_app/page/music/secondary/music_daily_recommend_page.dart';
import 'package:flutter_app/page/music/secondary/music_ranking_list_page.dart';
import 'package:flutter_app/page/music/user/music_user_home_page.dart';
import 'package:flutter_app/page/search/music_search_container.dart';
import 'package:flutter_app/page/search/music_search_result_container.dart';
import 'package:flutter_app/page/setting/app_font_setting.dart';
import 'package:flutter_app/page/setting/app_language_setting.dart';
import 'package:flutter_app/page/setting/app_music_quality_setting.dart';
import 'package:flutter_app/page/setting/app_theme_setting.dart';
import 'package:flutter_app/page/splash/splash_page.dart';
import 'package:flutter_app/page/tab/tab_navigator_page.dart';
import 'package:flutter_app/page/user/user_play_list_update_page.dart';
import 'package:flutter_app/page/user/user_preset_grid_group_page.dart';
import 'package:flutter_app/page/video/video/internal_video_category_page.dart';
import 'package:flutter_app/router/custom_cupertino_page_route.dart';
import 'package:flutter_app/router/router_utils.dart';
import 'package:flutter_app/widget/video/internal_mv/vertical_mv_page.dart';
import 'package:flutter_app/widget/video/internal_video/vertical_video_page.dart';

class MyRouterName {
  /// 闪屏页
  static const String splash = 'SplashPage';

  /// 新特性
  static const String intro = 'IntroPage';

  /// 首页
  static const String tab = '/';

  /// 登录
  static const String music_login = 'LoginNavigator';

  /// 歌单广场
  static const String play_list_container = 'MusicPlaylistContainerPage';
  
  /// 歌单整理
  static const String play_list_category = 'MusicPlaylistCategoryPage';


  /// 歌单详情
  static const String play_list_detail = 'MusicPlaylistDetailPage';

  /// 歌单收藏者
  static const String play_list_subscriber = 'MusicPlaylistSubscriberPage';

  /// 管理用户歌单
  static const String user_play_list_update = 'UserPlaylistUpdate';

  /// 歌单详情
  static const String playing = 'MusicPlayingPage';

  /// 每日推荐歌曲
  static const String music_daily_recommend = 'MusicDailyRecommendPage';
  /// 新歌&新碟上架
  static const String music_new_container = 'MusicNewContainerPage';
  /// 排行榜
  static const String music_ranking_list = 'MusicRankingListPage';

  static const String music_search = 'MusicSearchPage';
  static const String music_search_result = 'MusicSearchResultPage';

  /// 歌手排行榜
  static const String music_artist_ranking_list = 'MusicArtistRankingListPage';
  static const String test = 'MusicArtistEventPage';

  /// 歌手页面
  static const String music_artist = 'MusicArtistPage';

  static const String music_vertical_video = 'VerticalVideoPage';
  static const String music_vertical_mv = 'VerticalMVPage';

  

  ///
  ///
  static const String music_user_group = 'UserPresetGridGroupPage';
  /// 应用设置页面
  static const String app_setting = 'AppSettingPage';
  /// 主题色设置
  static const String app_theme_setting = 'AppThemeSettingPage';

  /// 字体设置
  static const String app_font_setting = 'AppFontSettingPage';
  /// 音质设置
  static const String app_song_quality_setting = 'AppSongQualitySetting';

  ///语言设置
  static const String app_language_setting = 'AppLanguageSettingPage';

  static const String internal_video_category = 'InternalVideoCategoryPage';

  /// dj
  static const String dj = 'MusicDjPage';

  /// dj 分类详情
  static const String dj_category_detail = 'MusicDJCategoryDetailPage';

  /// dj 排行榜
  static const String dj_rank = 'MusicDJRankPage';

  /// 用户页面
  static const String music_user_home = 'MusicUserHomePage';
}

class MyRouter {
  /// 用于参数传递使用
  static const String key = 'key';
  static const String value = 'value';

  /// 用于跨页面返回带参数使用 => 一个参数
  ///https://stackoverflow.com/questions/52075130/flutter-pass-data-back-with-popuntil
  static void popUntil(BuildContext context, String routerName,
      {String value = MyRouter.value}) {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == routerName) {
        (route.settings.arguments as Map)[MyRouter.key] = value;
        return true;
      } else {
        return false;
      }
    });
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MyRouterName.music_user_home:
        var userId = settings.arguments as int;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicUserHomePage(
              userId: userId,
            );
          },
        );
      case MyRouterName.dj:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicDjPage();
          },
        );
      case MyRouterName.dj_category_detail:
        var map = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicDJCategoryDetailPage(
              categoryId: map['categoryId']!,
              categoryName: map['categoryName']!,
            );
          },
        );
      case MyRouterName.dj_rank:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicDJRankContainerPage();
          },
        );
      case MyRouterName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case MyRouterName.intro:
        return NoAnimRouteBuilder(IntroPage());
      case MyRouterName.tab:
        return NoAnimRouteBuilder(TabNavigatorPage());
      case MyRouterName.music_login:
        return CupertinoPageRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (context) {
            return LoginNavigator();
          },
        );
      case MyRouterName.music_user_group:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return UserPresetGridGroupPage();
          },
        );
        case MyRouterName.app_setting:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AppSettingPage();
          },
        ); 
      case MyRouterName.app_theme_setting:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AppThemeSettingPage();
          },
        );
        case MyRouterName.app_font_setting:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AppFontSetting();
          },
        );

        case MyRouterName.app_language_setting:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AppLanguageSetting();
          },
        );
        
        case MyRouterName.app_song_quality_setting:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return AppMusicQualitySetting();
          },
        );
      case MyRouterName.play_list_container:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicPlaylistContainerPage();
          },
        );
        
        case MyRouterName.play_list_category:
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicPlaylistCategoryPage();
          },
        );
      case MyRouterName.play_list_detail:
        var playListId = settings.arguments as int;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicPlaylistDetailPage(playlistId: playListId);
          },
        );

      case MyRouterName.play_list_subscriber:
        var playlistId = settings.arguments as int;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return MusicPlaylistSubscriberPage(playlistId: playlistId);
          },
        );
      case MyRouterName.user_play_list_update:
        var map = settings.arguments as Map;
        return CupertinoPageRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (context) {
            return UserPlaylistUpdate(
              playlists: map['playlists'],
              enableNickName: map['enableNickName'],
            );
          },
        );
      case MyRouterName.music_search:
        return CustomCupertinoPageRoute(
          pushType: CustomCupertinoTransitionType.fade,
          popType: CustomCupertinoTransitionType.fade,
          gestureType: CustomCupertinoTransitionType.cupertino,
          settings: settings,
          builder: (context) {
            return MusicSearchContainer();
          },
        );
      case MyRouterName.music_search_result:
        var searchWord = settings.arguments as String;

        return CustomCupertinoPageRoute(
          pushType: CustomCupertinoTransitionType.cupertino,
          popType: CustomCupertinoTransitionType.fade,
          gestureType: CustomCupertinoTransitionType.cupertino,
          settings: settings,
          builder: (context) {
            return MusicSearchResultContainer(searchWord: searchWord);
          },
        );
      case MyRouterName.playing:
        return CustomCupertinoPageRoute(
          pushType: CustomCupertinoTransitionType.cupertinoFullscreenDialog,
          popType: CustomCupertinoTransitionType.cupertinoFullscreenDialog,
          gestureType: CustomCupertinoTransitionType.cupertinoFullscreenDialog,
          settings: settings,
          duration: const Duration(milliseconds: 500),
          builder: (context) {
            return MusicPlayingPage();
          },
        );
      case MyRouterName.music_vertical_video:
        var map = settings.arguments as Map<String, Object>;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return VerticalVideoPage(
              categoryId: map['categoryId'] as int,
              videos: map['videos'] as List<InternalVideo>,
              initialIndex: map['initialIndex'] as int,
            );
          },
        );
      case MyRouterName.music_vertical_mv:
        var map = settings.arguments as Map<String, Object>;
        return CupertinoPageRoute(
          settings: settings,
          builder: (context) {
            return VerticalMVPage(
              area: map['area'] as int,
              order: map['order'] as int,
              type: map['type'] as int,
              internalMVs: map['internalMVs'] as List<InternalMv>,
              initialIndex: map['initialIndex'] as int,
            );
          },
        );
      case MyRouterName.music_daily_recommend:
        return CupertinoPageRoute(
          settings: RouteSettings(
              name: MyRouterName.music_daily_recommend, arguments: Map()),
          builder: (context) {
            return MusicDailyRecommendPage();
          },
        );
        case MyRouterName.music_new_container:
        return CupertinoPageRoute(
          
          builder: (context) {
            return MusicTopContainerPage();
          },
        );
        
      case MyRouterName.music_ranking_list:
        return CupertinoPageRoute(
          settings: RouteSettings(
              name: MyRouterName.music_ranking_list, arguments: Map()),
          builder: (context) {
            return MusicRankingListPage();
          },
        );
      case MyRouterName.music_artist_ranking_list:
        return CupertinoPageRoute(
          settings: RouteSettings(
              name: MyRouterName.music_ranking_list, arguments: Map()),
          builder: (context) {
            return MusicArtistRankingListPage();
          },
        );
      case MyRouterName.test:
        return CupertinoPageRoute(
          settings: RouteSettings(name: MyRouterName.test, arguments: Map()),
          builder: (context) {
            return InternalVideoCategoryPage();
          },
        );
      case MyRouterName.music_artist:
        var artistId = settings.arguments as int;
        return CupertinoPageRoute(
          settings:
              RouteSettings(name: MyRouterName.music_artist, arguments: Map()),
          builder: (context) {
            return MusicArtistPage(
              artistId: artistId,
            );
          },
        );

      case MyRouterName.internal_video_category:
        return CupertinoPageRoute(
          builder: (context) {
            return InternalVideoCategoryPage();
          },
        );
      default:
        return CupertinoPageRoute(
          builder: (context) {
            return Scaffold(
              body:
                  Center(child: Text('No route defined for ${settings.name}')),
            );
          },
        );
    }
  }
}
