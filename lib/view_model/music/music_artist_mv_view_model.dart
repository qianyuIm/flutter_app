import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 相似歌手
class MusicArtistMvViewModel extends ViewStateModel {
  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<MusicMV> mvs = [];

  bool _hasMore = false;
  final int artistId;
  int _offset = 0;

  MusicArtistMvViewModel(this.artistId);
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<List<MusicMV>?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await loadData(artistId, _offset);
      if (data == null) {
        refreshController.refreshCompleted(resetFooterState: true);
        mvs.clear();
        setEmpty();
      } else {
        // onCompleted(data);
        mvs.clear();
        mvs.addAll(data);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      _offset = mvs.length;
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) {
        mvs.clear();
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
      
      var data = await loadData(artistId, _offset);
      
      if (data == null) {
        refreshController.loadNoData();
      } else {
        // onCompleted(data);
        mvs.addAll(data);
        refreshController.loadComplete();
         _offset = mvs.length;
        notifyListeners();
      }
     
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future loadData(int artistId, int offset) async {
    var map = await MusicApi.loadArtistMvData(artistId, offset)
        as Map<String, dynamic>;
    _hasMore = map['hasMore'];
    return map['mvs'].map<MusicMV>((mv) => MusicMV.fromJson(mv)).toList();
  }

  
}
