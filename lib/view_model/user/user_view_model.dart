import 'package:draggable_container/draggable_container.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_app/config/category_item.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/network/music_api/music_api_play_list_imp.dart';
import 'package:flutter_app/network/music_api/music_api_user_imp.dart';
import 'dart:convert' as convert;

import 'package:flutter_app/provider/view_state_model.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';

/// 初始状态
final _kInitialUserPresetGridSelectedItems = [
  UserPresetGridSelectedItem(
    categoryItem: CategoryItem(
        imageName: 'icon_user_local_download',
        titleValue: 'Local\nDownload',
        routeName: '',
        titleKey: 'user_local_download'),
    deletable: false,
  ),
  UserPresetGridSelectedItem(
      categoryItem: CategoryItem(
          imageName: 'icon_user_cloud_music',
          titleValue: 'CloudMusic',
          routeName: '',
          titleKey: 'user_cloud_music'),
      deletable: false),
  UserPresetGridSelectedItem(
    categoryItem: CategoryItem(
        imageName: 'icon_user_already_buy',
        titleValue: 'AlreadyBuy',
        routeName: '',
        titleKey: 'user_already_buy'),
    deletable: false,
  ),
  UserPresetGridSelectedItem(
    categoryItem: CategoryItem(
        imageName: 'icon_user_recent_play',
        titleValue: 'RecentPlay',
        routeName: '',
        titleKey: 'user_recent_play'),
    deletable: false,
  ),
  UserPresetGridSelectedItem(
      categoryItem: CategoryItem(
          imageName: 'icon_user_friends',
          titleValue: 'Friends',
          routeName: '',
          titleKey: 'user_friends')),
  UserPresetGridSelectedItem(
    categoryItem: CategoryItem(
        imageName: 'icon_user_collection_like',
        titleValue: 'CollectionLike',
        routeName: '',
        titleKey: 'user_collection_like'),
    deletable: false,
  ),
  UserPresetGridSelectedItem(
    categoryItem: CategoryItem(
        imageName: 'icon_user_my_blog',
        titleValue: 'Blog',
        routeName: '',
        titleKey: 'user_my_blog'),
  )
];

/// 我的分类列表
final _kAllUserPresetGridItems = [
  CategoryItem(
      imageName: 'icon_user_local_download',
      titleValue: 'Local\nDownload',
      routeName: '',
      titleKey: 'user_local_download'),
  CategoryItem(
      imageName: 'icon_user_cloud_music',
      titleValue: 'CloudMusic',
      routeName: '',
      titleKey: 'user_cloud_music'),
  CategoryItem(
      imageName: 'icon_user_already_buy',
      titleValue: 'AlreadyBuy',
      routeName: '',
      titleKey: 'user_already_buy'),
  CategoryItem(
      imageName: 'icon_user_recent_play',
      titleValue: 'RecentPlay',
      routeName: '',
      titleKey: 'user_recent_play'),
  CategoryItem(
      imageName: 'icon_user_friends',
      titleValue: 'Friends',
      routeName: '',
      titleKey: 'user_friends'),
  CategoryItem(
      imageName: 'icon_user_collection_like',
      titleValue: 'CollectionLike',
      routeName: '',
      titleKey: 'user_collection_like'),
  CategoryItem(
      imageName: 'icon_user_my_blog',
      titleValue: 'Blog',
      routeName: '',
      titleKey: 'user_my_blog'),
  CategoryItem(
      imageName: 'icon_user_rock_zone',
      titleValue: 'Rock',
      routeName: '',
      titleKey: 'user_rock_zone'),
  CategoryItem(
      imageName: 'icon_user_dj_zone',
      titleValue: 'DJ',
      routeName: '',
      titleKey: 'user_dj_zone'),
  CategoryItem(
      imageName: 'icon_user_rap_zone',
      titleValue: 'Rap',
      routeName: '',
      titleKey: 'user_rap_zone'),
  CategoryItem(
      imageName: 'icon_user_electronic_zone',
      titleValue: 'Electronic',
      routeName: '',
      titleKey: 'user_electronic_zone'),
  CategoryItem(
      imageName: 'icon_user_sleeping_decompression',
      titleValue: 'Sleeping',
      routeName: '',
      titleKey: 'user_sleeping_decompression'),
  CategoryItem(
      imageName: 'icon_user_chinese_features',
      titleValue: 'Chinese',
      routeName: '',
      titleKey: 'user_chinese_features'),
  CategoryItem(
      imageName: 'icon_user_radio',
      titleValue: 'Radio',
      routeName: '',
      titleKey: 'user_radio'),
  CategoryItem(
      imageName: 'icon_user_song_selection',
      titleValue: 'Selection',
      routeName: '',
      titleKey: 'user_song_selection'),
  CategoryItem(
      imageName: 'icon_user_most_hi_electronic_music',
      titleValue: 'MostHiElectronic',
      routeName: '',
      titleKey: 'user_most_hi_electronic_music'),
  CategoryItem(
      imageName: 'icon_user_classical_zone',
      titleValue: 'Classical',
      routeName: '',
      titleKey: 'user_classical_zone'),
  CategoryItem(
      imageName: 'icon_user_acg_zone',
      titleValue: 'ACG',
      routeName: '',
      titleKey: 'user_acg_zone'),
  CategoryItem(
      imageName: 'icon_user_run_fm',
      titleValue: 'RunFM',
      routeName: '',
      titleKey: 'user_run_fm'),
  CategoryItem(
      imageName: 'icon_user_parent_child_channel',
      titleValue: 'ParentChild',
      routeName: '',
      titleKey: 'user_parent_child_channel'),
  CategoryItem(
      imageName: 'icon_user_jazz_radio',
      titleValue: 'Jazz',
      routeName: '',
      titleKey: 'user_jazz_radio'),
  CategoryItem(
      imageName: 'icon_user_hot_song',
      titleValue: 'HotSong',
      routeName: '',
      titleKey: 'user_hot_song'),
  CategoryItem(
      imageName: 'icon_user_dating',
      titleValue: 'Dating',
      routeName: '',
      titleKey: 'user_dating'),
  CategoryItem(
      imageName: 'icon_user_little_ice_station',
      titleValue: 'LittleIce',
      routeName: '',
      titleKey: 'user_little_ice_station'),
  CategoryItem(
      imageName: 'icon_user_song_hunter',
      titleValue: 'Hunter',
      routeName: '',
      titleKey: 'user_song_hunter'),
  CategoryItem(
      imageName: 'icon_user_my_live',
      titleValue: 'Live',
      routeName: '',
      titleKey: 'user_my_live'),
  CategoryItem(
      imageName: 'icon_user_fire',
      titleValue: 'Fire',
      routeName: '',
      titleKey: 'user_fire'),
  CategoryItem(
      imageName: 'icon_user_classic_zone',
      titleValue: 'Classic',
      routeName: '',
      titleKey: 'user_classic_zone'),
  CategoryItem(
      imageName: 'icon_user_sound_source',
      titleValue: 'SoundSource',
      routeName: '',
      titleKey: 'user_sound_source')
];

class UserPresetGridSelectedItem extends DraggableItem {
  final CategoryItem categoryItem;
  bool deletable;
  bool fixed;
  int location;

  UserPresetGridSelectedItem({
    required this.categoryItem,
    this.deletable = true,
    this.fixed = false,
    this.location = 0,
  });

  factory UserPresetGridSelectedItem.fromDBMap(Map<String, dynamic> json) {
    return UserPresetGridSelectedItem(
      categoryItem:
          CategoryItem.fromJson(convert.jsonDecode(json['categoryItem'])),
    )
      ..deletable = json['deletable'] == 1
      ..fixed = json['fixed'] == 1
      ..location = json['location'];
  }
  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['categoryItem'] = convert.jsonEncode(this.categoryItem);
    map['deletable'] = this.deletable == true ? 1 : 0;
    map['fixed'] = this.fixed == true ? 1 : 0;
    map['location'] = this.location;
    return map;
  }
}

class UserPresetGridUnSelectedItem extends DraggableItem {
  final CategoryItem categoryItem;
  bool deletable;
  bool fixed;

  UserPresetGridUnSelectedItem({
    required this.categoryItem,
    this.deletable = false,
    this.fixed = true,
  });
}

class UserPresetGridViewModel extends ViewStateModel {
  List<UserPresetGridSelectedItem> categoryItems = [];
  Future<void> initData() async {
    setBusy();
    try {
      /// 从数据库查询
      var local = await LocalDb.instance.userPresetGridDb.queryAll();
      if (local.length == 0) {
        /// 预设
        categoryItems = _kInitialUserPresetGridSelectedItems;

        /// 插入数据库
        await LocalDb.instance.userPresetGridDb.insertAll(categoryItems);
      } else {
        categoryItems = local;
      }

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class UserPresetGridGroupViewModel extends ViewStateModel {
  List<UserPresetGridUnSelectedItem> unSelectedItem = [];
  List<UserPresetGridSelectedItem> selectedItem = [];
  initData() async {
    setBusy();
    try {
      var allCategoryItems = _kAllUserPresetGridItems;

      /// 从数据库查询
      selectedItem = await LocalDb.instance.userPresetGridDb.queryAll();
      final selectedCategoryList = selectedItem.map((element) {
        return element.categoryItem.imageName;
      }).toList();

      unSelectedItem = allCategoryItems
          .where((element) => !selectedCategoryList.contains(element.imageName))
          .map((category) =>
              UserPresetGridUnSelectedItem(categoryItem: category))
          .toList();

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class UserPlaylistViewModel extends ViewStateModel {
  final MusicUserManager userManager;

  /// 创建的歌单
  List<MusicPlayList> createdPlayList = [];

  /// 收藏的歌单
  List<MusicPlayList> subscribedPlayList = [];

  /// 我喜欢的音乐
  MusicPlayList? favoritePlaylist;

  UserPlaylistViewModel(this.userManager);

  Future initData() async {
    var uid = userManager.userDetail?.profile?.userId;
    if (uid == null) {
      createdPlayList = [];
      subscribedPlayList = [];
      favoritePlaylist = null;
      setIdle();
      return;
    }

    try {
      /// 从数据库中查找
      var allDbPlaylist = await LocalDb.instance.userPlaylistDb.queryAll();
      createdPlayList = allDbPlaylist
          .where((element) => element.creator?.userId == uid)
          .toList();
      if (createdPlayList.isNotEmpty) {
        favoritePlaylist = createdPlayList.first;
      }

      subscribedPlayList = allDbPlaylist
          .where((element) => element.creator?.userId != uid)
          .toList();
      setBusy();

      /// 从网络请求
      var allPlaylist = await MusicApiUserImp.loadUserPlaylistData(uid);
      createdPlayList = allPlaylist
          .where((element) => element.creator?.userId == uid)
          .toList();
      favoritePlaylist = createdPlayList.first;
      subscribedPlayList = allPlaylist
          .where((element) => element.creator?.userId != uid)
          .toList();

      /// 存入数据
      LocalDb.instance.userPlaylistDb.insertAll(allPlaylist);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  /// 对自己的歌单进行增加或删除
  /// op: add 增加， del 删除
  /// targetId: 目标歌单 id
  /// tracks: 歌曲 id,可多个,用逗号隔开
  Future<bool> handlePlaylistTracks(
      {String op = 'add',
      required int targetId,
      required List<int> tracks}) async {
    var response = await MusicApiPlaylistImp.loadPlaylistTracksData(
        op: op, targetId: targetId, tracks: tracks);
    LogUtil.v('response => $response');
    return response['body']['code'] == 200;
  }
}
