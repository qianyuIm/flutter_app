import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/model/music/music_video.dart';
import 'package:flutter_app/model/search/music_search_result.dart';
import 'package:flutter_app/network/music_api/music_api_search_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum MusicSearchType {
  
  /// 单曲
  songs,

  /// 专辑
  albums,

  /// 歌手
  artists,

  /// 歌单
  playlists,

  /// 用户
  userprofiles,

  /// mv
  mvs,

  /// 歌词
  lyrics,

  /// 电台
  djRadios,

  /// 视频
  videos,
/// 综合
  comprehensive,
  
}

extension MusicSearchTypeGetValue on MusicSearchType {
  /// 获取对应的type 值
  int get value {
    if (this == MusicSearchType.songs) {
      return 1;
    } else if (this == MusicSearchType.albums) {
      return 10;
    } else if (this == MusicSearchType.artists) {
      return 100;
    } else if (this == MusicSearchType.playlists) {
      return 1000;
    } else if (this == MusicSearchType.userprofiles) {
      return 1002;
    } else if (this == MusicSearchType.mvs) {
      return 1004;
    } else if (this == MusicSearchType.lyrics) {
      return 1006;
    } else if (this == MusicSearchType.djRadios) {
      return 1009;
    } else if (this == MusicSearchType.videos) {
      return 1014;
    } else if (this == MusicSearchType.comprehensive) {
      return 1018;
    }
    return -1;
  }
}


class MusicSearchResultViewModel extends ViewStateModel {
  final MusicSearchType searchType;
  final String keyword;
  final int limit;
  MusicSearchResultViewModel(this.searchType, this.keyword, {this.limit = 30});

  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  bool _hasMore = false;

  int _offset = 0;

  /// 单曲
  List<MusicSong> songs = [];

  /// 专辑
  List<MusicAlbum> albums = [];

  /// 歌手
  List<MusicArtist> artists = [];

  /// 歌单

  List<MusicPlayList> playlists = [];

  /// 用户
  List<MusicUserProfile> userprofiles = [];

  /// mv
  List<MusicMV> mvs = [];

  /// 电台
  List<MusicDjRadio> djRadios = [];

  /// 视频
  List<MusicVideo> videos = [];

  initData() async {
    setBusy();
    await refresh(init: true);
  }
  
  Future<MusicSearchResult?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await _loadData(searchType, _offset, false);
      return data;
    } catch (e, s) {
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
      var data = await _loadData(searchType, _offset, true);
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<MusicSearchResult> _loadData(
      MusicSearchType searchType, int offset, bool isLoadMore) async {
    var result = await MusicApiSearchImp.loadCloudSearchData(keyword, limit, offset,type: searchType.value);
    _handleResultData(result, isLoadMore);
    return result;
  }

  void _handleResultData(MusicSearchResult result, bool isLoadMore) {
    switch (searchType) {
      case MusicSearchType.songs:
        _handleData<MusicSong>(
            songs, result.songCount, result.songs, isLoadMore);

        break;
      case MusicSearchType.albums:
        _handleData<MusicAlbum>(
            albums, result.albumCount, result.albums, isLoadMore);
        break;
      case MusicSearchType.artists:
        _handleData<MusicArtist>(
            artists, result.artistCount, result.artists, isLoadMore);
        break;
      case MusicSearchType.playlists:
        _handleData<MusicPlayList>(
            playlists, result.playlistCount, result.playlists, isLoadMore);
        break;  
      case MusicSearchType.userprofiles:
        _handleData<MusicUserProfile>(userprofiles, result.userprofileCount,
            result.userprofiles, isLoadMore);
        break; 
      case MusicSearchType.mvs:
        _handleData<MusicMV>(mvs, result.mvCount, result.mvs, isLoadMore);
        break; 
      case MusicSearchType.lyrics:
        _handleData<MusicSong>(
            songs, result.songCount, result.songs, isLoadMore);
        break;
      case MusicSearchType.djRadios:
        _handleData<MusicDjRadio>(
            djRadios, result.djRadiosCount, result.djRadios, isLoadMore);
        break;
      case MusicSearchType.videos:
        _handleData<MusicVideo>(
            videos, result.videoCount, result.videos, isLoadMore);
        break;
      // case MusicSearchType.comprehensive:
      //   break;
      default:
        break;
    }
  }

  void _handleData<T>(
      List<T> data, int? allCount, List<T>? resultData, bool isLoadMore) {
    _hasMore = (allCount ?? 0) > _offset + limit;
    if (resultData == null) {
      if (isLoadMore) {
        refreshController.loadNoData();
      } else {
        refreshController.refreshCompleted(resetFooterState: true);
        songs.clear();
        setEmpty();
      }
    } else {
      if (isLoadMore) {
        data.addAll(resultData);
        refreshController.loadComplete();
        notifyListeners();
      } else {
        data.clear();
        data.addAll(resultData);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
    }
    _offset = songs.length;
  }
}
