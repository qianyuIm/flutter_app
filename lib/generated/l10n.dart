// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `flutter app`
  String get appTitle {
    return Intl.message(
      'flutter app',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get tabHome {
    return Intl.message(
      'Home',
      name: 'tabHome',
      desc: '',
      args: [],
    );
  }

  /// `Novel`
  String get tabNovel {
    return Intl.message(
      'Novel',
      name: 'tabNovel',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get tabMusic {
    return Intl.message(
      'Music',
      name: 'tabMusic',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get tabVideo {
    return Intl.message(
      'Video',
      name: 'tabVideo',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get tabUser {
    return Intl.message(
      'User',
      name: 'tabUser',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get splashSkip {
    return Intl.message(
      'Skip',
      name: 'splashSkip',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get viewStateButtonLogin {
    return Intl.message(
      'Sign In',
      name: 'viewStateButtonLogin',
      desc: '',
      args: [],
    );
  }

  /// `Not sign in yet`
  String get viewStateMessageUnAuth {
    return Intl.message(
      'Not sign in yet',
      name: 'viewStateMessageUnAuth',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get viewStateButtonRetry {
    return Intl.message(
      'Retry',
      name: 'viewStateButtonRetry',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get viewStateMessageError {
    return Intl.message(
      'Load Failed',
      name: 'viewStateMessageError',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed,Check network `
  String get viewStateMessageNetworkError {
    return Intl.message(
      'Load Failed,Check network ',
      name: 'viewStateMessageNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get viewStateButtonRefresh {
    return Intl.message(
      'Refresh',
      name: 'viewStateButtonRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Nothing Found`
  String get viewStateMessageEmpty {
    return Intl.message(
      'Nothing Found',
      name: 'viewStateMessageEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Local\nDownload`
  String get user_local_download {
    return Intl.message(
      'Local\nDownload',
      name: 'user_local_download',
      desc: '',
      args: [],
    );
  }

  /// `CloudMusic`
  String get user_cloud_music {
    return Intl.message(
      'CloudMusic',
      name: 'user_cloud_music',
      desc: '',
      args: [],
    );
  }

  /// `AlreadyBuy`
  String get user_already_buy {
    return Intl.message(
      'AlreadyBuy',
      name: 'user_already_buy',
      desc: '',
      args: [],
    );
  }

  /// `RecentPlay`
  String get user_recent_play {
    return Intl.message(
      'RecentPlay',
      name: 'user_recent_play',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get user_friends {
    return Intl.message(
      'Friends',
      name: 'user_friends',
      desc: '',
      args: [],
    );
  }

  /// `CollectionLike`
  String get user_collection_like {
    return Intl.message(
      'CollectionLike',
      name: 'user_collection_like',
      desc: '',
      args: [],
    );
  }

  /// `Blog`
  String get user_my_blog {
    return Intl.message(
      'Blog',
      name: 'user_my_blog',
      desc: '',
      args: [],
    );
  }

  /// `Rock`
  String get user_rock_zone {
    return Intl.message(
      'Rock',
      name: 'user_rock_zone',
      desc: '',
      args: [],
    );
  }

  /// `DJ`
  String get user_dj_zone {
    return Intl.message(
      'DJ',
      name: 'user_dj_zone',
      desc: '',
      args: [],
    );
  }

  /// `Rap`
  String get user_rap_zone {
    return Intl.message(
      'Rap',
      name: 'user_rap_zone',
      desc: '',
      args: [],
    );
  }

  /// `Electronic`
  String get user_electronic_zone {
    return Intl.message(
      'Electronic',
      name: 'user_electronic_zone',
      desc: '',
      args: [],
    );
  }

  /// `Sleeping`
  String get user_sleeping_decompression {
    return Intl.message(
      'Sleeping',
      name: 'user_sleeping_decompression',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get user_chinese_features {
    return Intl.message(
      'Chinese',
      name: 'user_chinese_features',
      desc: '',
      args: [],
    );
  }

  /// `Radio`
  String get user_radio {
    return Intl.message(
      'Radio',
      name: 'user_radio',
      desc: '',
      args: [],
    );
  }

  /// `Selection`
  String get user_song_selection {
    return Intl.message(
      'Selection',
      name: 'user_song_selection',
      desc: '',
      args: [],
    );
  }

  /// `MostHiElectronic`
  String get user_most_hi_electronic_music {
    return Intl.message(
      'MostHiElectronic',
      name: 'user_most_hi_electronic_music',
      desc: '',
      args: [],
    );
  }

  /// `Classical`
  String get user_classical_zone {
    return Intl.message(
      'Classical',
      name: 'user_classical_zone',
      desc: '',
      args: [],
    );
  }

  /// `ACG`
  String get user_acg_zone {
    return Intl.message(
      'ACG',
      name: 'user_acg_zone',
      desc: '',
      args: [],
    );
  }

  /// `RunFM`
  String get user_run_fm {
    return Intl.message(
      'RunFM',
      name: 'user_run_fm',
      desc: '',
      args: [],
    );
  }

  /// `ParentChild`
  String get user_parent_child_channel {
    return Intl.message(
      'ParentChild',
      name: 'user_parent_child_channel',
      desc: '',
      args: [],
    );
  }

  /// `Jazz`
  String get user_jazz_radio {
    return Intl.message(
      'Jazz',
      name: 'user_jazz_radio',
      desc: '',
      args: [],
    );
  }

  /// `HotSong`
  String get user_hot_song {
    return Intl.message(
      'HotSong',
      name: 'user_hot_song',
      desc: '',
      args: [],
    );
  }

  /// `Dating`
  String get user_dating {
    return Intl.message(
      'Dating',
      name: 'user_dating',
      desc: '',
      args: [],
    );
  }

  /// `LittleIce`
  String get user_little_ice_station {
    return Intl.message(
      'LittleIce',
      name: 'user_little_ice_station',
      desc: '',
      args: [],
    );
  }

  /// `Hunter`
  String get user_song_hunter {
    return Intl.message(
      'Hunter',
      name: 'user_song_hunter',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get user_my_live {
    return Intl.message(
      'Live',
      name: 'user_my_live',
      desc: '',
      args: [],
    );
  }

  /// `Fire`
  String get user_fire {
    return Intl.message(
      'Fire',
      name: 'user_fire',
      desc: '',
      args: [],
    );
  }

  /// `Classic`
  String get user_classic_zone {
    return Intl.message(
      'Classic',
      name: 'user_classic_zone',
      desc: '',
      args: [],
    );
  }

  /// `SoundSource`
  String get user_sound_source {
    return Intl.message(
      'SoundSource',
      name: 'user_sound_source',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get user_music_application {
    return Intl.message(
      'Application',
      name: 'user_music_application',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Theme Setting`
  String get setting_theme {
    return Intl.message(
      'Theme Setting',
      name: 'setting_theme',
      desc: '',
      args: [],
    );
  }

  /// `Theme Mode`
  String get setting_theme_mode {
    return Intl.message(
      'Theme Mode',
      name: 'setting_theme_mode',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get setting_theme_mode_auto {
    return Intl.message(
      'Auto',
      name: 'setting_theme_mode_auto',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get setting_theme_mode_dark {
    return Intl.message(
      'Dark Mode',
      name: 'setting_theme_mode_dark',
      desc: '',
      args: [],
    );
  }

  /// `Normal Mode`
  String get setting_theme_mode_normal {
    return Intl.message(
      'Normal Mode',
      name: 'setting_theme_mode_normal',
      desc: '',
      args: [],
    );
  }

  /// `Font Setting`
  String get setting_font {
    return Intl.message(
      'Font Setting',
      name: 'setting_font',
      desc: '',
      args: [],
    );
  }

  /// `Language Setting`
  String get setting_language {
    return Intl.message(
      'Language Setting',
      name: 'setting_language',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get setting_language_auto {
    return Intl.message(
      'Auto',
      name: 'setting_language_auto',
      desc: '',
      args: [],
    );
  }

  /// `中文`
  String get setting_language_zh {
    return Intl.message(
      '中文',
      name: 'setting_language_zh',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get setting_language_en {
    return Intl.message(
      'English',
      name: 'setting_language_en',
      desc: '',
      args: [],
    );
  }

  /// `Song Quality Setting`
  String get setting_song_quality {
    return Intl.message(
      'Song Quality Setting',
      name: 'setting_song_quality',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `I Like Music`
  String get user_like_music {
    return Intl.message(
      'I Like Music',
      name: 'user_like_music',
      desc: '',
      args: [],
    );
  }

  /// `Heartbeat Model`
  String get user_heartbeat {
    return Intl.message(
      'Heartbeat Model',
      name: 'user_heartbeat',
      desc: '',
      args: [],
    );
  }

  /// `Create Playlist`
  String get user_tab_playlist_create {
    return Intl.message(
      'Create Playlist',
      name: 'user_tab_playlist_create',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe Playlist`
  String get user_tab_playlist_subscribe {
    return Intl.message(
      'Subscribe Playlist',
      name: 'user_tab_playlist_subscribe',
      desc: '',
      args: [],
    );
  }

  /// `Create a Playlist`
  String get user_tab_playlist_create_empty {
    return Intl.message(
      'Create a Playlist',
      name: 'user_tab_playlist_create_empty',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe is Empty`
  String get user_tab_playlist_subscribe_empty {
    return Intl.message(
      'Subscribe is Empty',
      name: 'user_tab_playlist_subscribe_empty',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get user_create_playlist_cancel {
    return Intl.message(
      'Cancel',
      name: 'user_create_playlist_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get user_create_playlist_complete {
    return Intl.message(
      'Done',
      name: 'user_create_playlist_complete',
      desc: '',
      args: [],
    );
  }

  /// `Music Playlist`
  String get user_create_playlist_title {
    return Intl.message(
      'Music Playlist',
      name: 'user_create_playlist_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new playlist title`
  String get user_create_playlist_hint {
    return Intl.message(
      'Enter a new playlist title',
      name: 'user_create_playlist_hint',
      desc: '',
      args: [],
    );
  }

  /// `Set to private playlist`
  String get user_create_playlist_privacy {
    return Intl.message(
      'Set to private playlist',
      name: 'user_create_playlist_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Playlist Manager`
  String get user_playlist_manager {
    return Intl.message(
      'Playlist Manager',
      name: 'user_playlist_manager',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Radio`
  String get recommended_dj {
    return Intl.message(
      'Recommended Radio',
      name: 'recommended_dj',
      desc: '',
      args: [],
    );
  }

  /// `Recommended MV`
  String get recommended_mv {
    return Intl.message(
      'Recommended MV',
      name: 'recommended_mv',
      desc: '',
      args: [],
    );
  }

  /// `Recommended New Song`
  String get recommended_new_song {
    return Intl.message(
      'Recommended New Song',
      name: 'recommended_new_song',
      desc: '',
      args: [],
    );
  }

  /// `Recommended Playlist`
  String get recommended_playlist {
    return Intl.message(
      'Recommended Playlist',
      name: 'recommended_playlist',
      desc: '',
      args: [],
    );
  }

  /// `Enter Private`
  String get enter_private {
    return Intl.message(
      'Enter Private',
      name: 'enter_private',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `New Album`
  String get top_new_album {
    return Intl.message(
      'New Album',
      name: 'top_new_album',
      desc: '',
      args: [],
    );
  }

  /// `New Song`
  String get top_new_song {
    return Intl.message(
      'New Song',
      name: 'top_new_song',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get recommend {
    return Intl.message(
      'Recommend',
      name: 'recommend',
      desc: '',
      args: [],
    );
  }

  /// `ZH`
  String get zh {
    return Intl.message(
      'ZH',
      name: 'zh',
      desc: '',
      args: [],
    );
  }

  /// `EA`
  String get ea {
    return Intl.message(
      'EA',
      name: 'ea',
      desc: '',
      args: [],
    );
  }

  /// `KR`
  String get kr {
    return Intl.message(
      'KR',
      name: 'kr',
      desc: '',
      args: [],
    );
  }

  /// `JP`
  String get jp {
    return Intl.message(
      'JP',
      name: 'jp',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Recommend\nDaily`
  String get recommend_daily {
    return Intl.message(
      'Recommend\nDaily',
      name: 'recommend_daily',
      desc: '',
      args: [],
    );
  }

  /// `Private FM`
  String get private_fm {
    return Intl.message(
      'Private FM',
      name: 'private_fm',
      desc: '',
      args: [],
    );
  }

  /// `Play List`
  String get play_list {
    return Intl.message(
      'Play List',
      name: 'play_list',
      desc: '',
      args: [],
    );
  }

  /// `Rank List`
  String get rank_list {
    return Intl.message(
      'Rank List',
      name: 'rank_list',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Expansion More`
  String get expansion_more {
    return Intl.message(
      'Expansion More',
      name: 'expansion_more',
      desc: '',
      args: [],
    );
  }

  /// `Playlist Square`
  String get playlist_square {
    return Intl.message(
      'Playlist Square',
      name: 'playlist_square',
      desc: '',
      args: [],
    );
  }

  /// `Go to the landing page`
  String get need_login_go {
    return Intl.message(
      'Go to the landing page',
      name: 'need_login_go',
      desc: '',
      args: [],
    );
  }

  /// `Login is required for the current page`
  String get need_login_title {
    return Intl.message(
      'Login is required for the current page',
      name: 'need_login_title',
      desc: '',
      args: [],
    );
  }

  /// `Region:`
  String get region {
    return Intl.message(
      'Region:',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get type {
    return Intl.message(
      'Type:',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Sort:`
  String get sort {
    return Intl.message(
      'Sort:',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Fastest Rising`
  String get fastest_rising {
    return Intl.message(
      'Fastest Rising',
      name: 'fastest_rising',
      desc: '',
      args: [],
    );
  }

  /// `Hottest`
  String get hottest {
    return Intl.message(
      'Hottest',
      name: 'hottest',
      desc: '',
      args: [],
    );
  }

  /// `Latest`
  String get latest {
    return Intl.message(
      'Latest',
      name: 'latest',
      desc: '',
      args: [],
    );
  }

  /// `Official`
  String get official {
    return Intl.message(
      'Official',
      name: 'official',
      desc: '',
      args: [],
    );
  }

  /// `Native`
  String get native {
    return Intl.message(
      'Native',
      name: 'native',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `Netease`
  String get netease {
    return Intl.message(
      'Netease',
      name: 'netease',
      desc: '',
      args: [],
    );
  }

  /// `Mainland`
  String get mainland {
    return Intl.message(
      'Mainland',
      name: 'mainland',
      desc: '',
      args: [],
    );
  }

  /// `HT`
  String get ht {
    return Intl.message(
      'HT',
      name: 'ht',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get artist_home {
    return Intl.message(
      'Home',
      name: 'artist_home',
      desc: '',
      args: [],
    );
  }

  /// `Song`
  String get artist_song {
    return Intl.message(
      'Song',
      name: 'artist_song',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get artist_album {
    return Intl.message(
      'Album',
      name: 'artist_album',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get artist_event {
    return Intl.message(
      'Event',
      name: 'artist_event',
      desc: '',
      args: [],
    );
  }

  /// `Blog`
  String get artist_blog {
    return Intl.message(
      'Blog',
      name: 'artist_blog',
      desc: '',
      args: [],
    );
  }

  /// `MV`
  String get artist_mv {
    return Intl.message(
      'MV',
      name: 'artist_mv',
      desc: '',
      args: [],
    );
  }

  /// `+ follow`
  String get artist_follow {
    return Intl.message(
      '+ follow',
      name: 'artist_follow',
      desc: '',
      args: [],
    );
  }

  /// `Classification Management`
  String get classification_management {
    return Intl.message(
      'Classification Management',
      name: 'classification_management',
      desc: '',
      args: [],
    );
  }

  /// `Editor`
  String get editor {
    return Intl.message(
      'Editor',
      name: 'editor',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
