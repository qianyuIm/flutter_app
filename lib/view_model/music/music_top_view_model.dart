import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/network/music_api/music_api_song_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicTopSongViewModel extends ViewStateModel {
  /// 0: 全部
  /// 7: 华语
  /// 96: 欧美
  /// 8: 日本
  /// 16: 韩国
  final int type;

  MusicTopSongViewModel(this.type);
  List<MusicSong> songs = [];
  initData() async {
    setBusy();
    try {
      songs = await MusicApiSongImp.loadTopSongData(type: this.type);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 全部新碟
class MusicTopAlbumViewModel extends ViewStateModel {
  final String area;

  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<MusicAlbum> albums = [];

  bool _hasMore = false;
  int _offset = 0;
  int _limit = 40;

  MusicTopAlbumViewModel(this.area);
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<List<MusicAlbum>?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await loadData(area, _offset);
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        albums.clear();
        setEmpty();
      } else {
        albums.clear();
        albums.addAll(data);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      _offset = albums.length;
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) {
        albums.clear();
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
      var data = await loadData(area, _offset);
      if (data.isEmpty) {
        refreshController.loadNoData();
      } else {
        albums.addAll(data);
        refreshController.loadComplete();
        _offset = albums.length;
        notifyListeners();
      }
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<List<MusicAlbum>> loadData(String area, int offset) async {
    var response =
        await MusicApiSongImp.loadAlbumNewData(area, _limit, _offset);
    var total = response['total'] as int;
    if (total > _offset) {
      _hasMore = true;
    } else {
      _hasMore = false;
    }
    return response['albums']
        .map<MusicAlbum>((album) => MusicAlbum.fromJson(album))
        .toList();
  }
}
