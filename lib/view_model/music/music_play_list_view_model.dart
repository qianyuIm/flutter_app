import 'package:draggable_container/draggable_container.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_play_list_container.dart';
import 'package:flutter_app/model/music/music_playlist_categorie.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/network/music_api/music_api_play_list_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'dart:convert' as convert;

import 'package:pull_to_refresh/pull_to_refresh.dart';

const kRecommendedCategoryId = -1;

class MusicPlaylistSelectedItem extends DraggableItem {
  final MusicPlaylistCategorie category;
  bool deletable;
  bool fixed;
  int location;

  MusicPlaylistSelectedItem({
    required this.category,
    this.deletable = true,
    this.fixed = false,
    this.location = 0,
  });

  factory MusicPlaylistSelectedItem.fromDBMap(Map<String, dynamic> json) {
    return MusicPlaylistSelectedItem(
      category: MusicPlaylistCategorie.fromJson(
          convert.jsonDecode(json['category']) as Map<String, dynamic>),
    )
      ..deletable = json['deletable'] == 1
      ..fixed = json['fixed'] == 1
      ..location = json['location'];
  }
  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = convert.jsonEncode(this.category);
    data['deletable'] = this.deletable == true ? 1 : 0;
    data['fixed'] = this.fixed == true ? 1 : 0;
    data['location'] = this.location;
    return data;
  }
}

class MusicPlaylistUnSelectedItem extends DraggableItem {
  final MusicPlaylistCategorie category;
  bool deletable;
  bool fixed;

  MusicPlaylistUnSelectedItem({
    required this.category,
    this.deletable = false,
    this.fixed = true,
  });
}

class MusicPlaylistViewModel extends ViewStateModel {
  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<MusicPlayList> playLists = [];

  bool _hasMore = false;
  final String categoryName;
  int _offset = 0;

  MusicPlaylistViewModel(this.categoryName);
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<List<MusicPlayList>?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await loadData(categoryName, _offset);
      if (data.playlists == null) {
        refreshController.refreshCompleted(resetFooterState: true);
        playLists.clear();
        setEmpty();
      } else {
        playLists.clear();
        playLists.addAll(data.playlists!);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      _offset = playLists.length;
      return data.playlists;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) {
        playLists.clear();
      }
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future loadMore() async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(categoryName, _offset);
      if (data.playlists == null) {
        refreshController.loadNoData();
      } else {
        playLists.addAll(data.playlists!);
        refreshController.loadComplete();
        _offset = playLists.length;
        notifyListeners();
      }
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<MusicPlaylistContainer> loadData(
      String categoryName, int offset) async {
    var container = await MusicApiPlaylistImp.loadTopPlaylistData(
        cat: categoryName, limit: 30, offset: offset);
    _hasMore = container.more;
    return container;
  }
}


class MusicPlaylistContainerViewModel extends ViewStateModel {
  List<MusicPlaylistSelectedItem> categorys = [];
  Future<void> initData() async {
    setBusy();
    try {
      /// 从数据库查询
      var local = await LocalDb.instance.playlistCategoryDb.queryAll();
      if (local.length == 0) {
        List<MusicPlaylistCategorie> loadCategorys =
            await MusicApiPlaylistImp.loadPlaylistHotData();

        /// 添加全部
        MusicPlaylistCategorie recommendedCategory =
            MusicPlaylistCategorie('全部', 0, 0, 0, false, false);
        MusicPlaylistCategorie highqualityCategory =
            MusicPlaylistCategorie('精品', 0, 0, 0, false, false);
        loadCategorys.insertAll(0, [recommendedCategory, highqualityCategory]);

        categorys = loadCategorys.asMap().keys.map((e) {
          var ele = loadCategorys[e];
          var deletable = (e != 0 && e != 1);
          var fixed = (e == 0 || e == 1);
          return MusicPlaylistSelectedItem(
              category: ele, deletable: deletable, fixed: fixed, location: e);
        }).toList();

        /// 插入数据库
        await LocalDb.instance.playlistCategoryDb.insertAll(categorys);
      } else {
        categorys = local;
      }

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class MusicPlaylistCategoryViewModel extends ViewStateModel {
  List<MusicPlaylistUnSelectedItem> unSelectedItem = [];
  List<MusicPlaylistSelectedItem> selectedItem = [];
  initData() async {
    setBusy();
    try {
      var container =
           await MusicApiPlaylistImp.loadPlaylistCatlistData();
      var all = container.sub!;
      /// 从数据库查询
      selectedItem = await LocalDb.instance.playlistCategoryDb.queryAll();
      final categoryNameList = selectedItem.map((element) {
        return element.category.name;
      }).toList();

      unSelectedItem = 
          all.where((element) => !categoryNameList.contains(element.name))
          .map((category) => MusicPlaylistUnSelectedItem(category: category))
          .toList();

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 详情页
class MusicPlayListDetailViewModel extends ViewStateModel {
  final int id;
  final int s;
  late MusicPlayList playlist;
  MusicPlayListDetailViewModel(this.id, {this.s = 5});

  initData() async {
    setBusy();
    try {
      playlist = await MusicApiPlaylistImp.loadPlayListData(id, s);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 详情页 播放列表
class MusicPlayListItemViewModel extends ViewStateModel {
  final MusicPlayList playList;
  final List<int> ids;
  List<MusicSong> songs = [];
  MusicPlayListItemViewModel(this.ids, this.playList);

  initData() async {
    setBusy();
    try {
      if (ids.isEmpty) {
        songs = [];
        playList.trackSongs = songs;
        setEmpty();
      } else {
        songs = await MusicApiPlaylistImp.loadPlayListSongsData(ids);
        playList.trackSongs = songs;

        await Future.delayed(Duration(seconds: 3));
        setIdle();
      }
    } catch (e, s) {
      setError(e, s);
    }
  }
}


class MusicPlaylistSubscriberViewModel extends ViewStateModel {
  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<MusicUserProfile> subscribers = [];

  bool _hasMore = false;
  int _offset = 0;
  final int playlistId;
  

  MusicPlaylistSubscriberViewModel(this.playlistId);
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<List<MusicUserProfile>?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await loadData(playlistId, _offset);
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        subscribers.clear();
        setEmpty();
      } else {
        subscribers.clear();
        subscribers.addAll(data);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      _offset = subscribers.length;
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) {
        subscribers.clear();
      }
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future loadMore() async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(playlistId, _offset);
      if (data.isEmpty) {
        refreshController.loadNoData();
      } else {
        subscribers.addAll(data);
        refreshController.loadComplete();
        _offset = subscribers.length;
        notifyListeners();
      }
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<List<MusicUserProfile>> loadData(
      int playlistId, int offset) async {
    var container = await MusicApiPlaylistImp.loadPlaylistSubscribersData(playlistId, offset);
    _hasMore = container['more'];
    return container['subscribers']
        .map<MusicUserProfile>(
            (profile) => MusicUserProfile.fromJson(profile))
        .toList();
  }
}