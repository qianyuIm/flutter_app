import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VerticalVideoViewModel extends ViewStateModel {
  final int categoryId;
  List<InternalVideo> videos = [];
  VerticalVideoViewModel(this.categoryId, this.videos){
    _offset = videos.length;
  }

  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  bool _hasMore = true;

  int _offset = 0;

  // initData() async {
  //   setBusy();
  //   await refresh(init: true);
  // }

  /*Future<List<InternalVideo>?> refresh({bool init = false}) async {
    try {
      _offset = 0;
      var data = await loadData(categoryId, _offset);
      if (data.length == 0) {
        refreshController.refreshCompleted(resetFooterState: true);
        videos.clear();
        setEmpty();
      } else {
        data = onCompleted(data);
        videos.clear();
        videos.addAll(data);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      _offset = videos.length;
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) {
        videos.clear();
      }
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }*/

  /// 上拉加载更多
  Future<List<InternalVideo>?> loadMore() async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(categoryId, _offset);
      if (data.length == 0) {
        refreshController.loadNoData();
      } else {
        data = onCompleted(data);
        videos.addAll(data);
        refreshController.loadComplete();
        _offset = videos.length;
        notifyListeners();
      }

      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<List<InternalVideo>> loadData(int categoryId, int offset) async {
    var map = await MusicApi.loadVideoGroupData(categoryId, offset)
        as Map<String, dynamic>;
    _hasMore = map['hasmore'];
    return map['datas']
        .map<InternalVideo>((video) => InternalVideo.fromJson(video))
        .toList();
  }

  List<InternalVideo> onCompleted(List<InternalVideo> interVideos) {
    return interVideos
        .where((element) => element.data?.coverUrl != null)
        .toList();
  }

  /// 获取对应的video Url
  Future<String> loadVideoUrlData(
      InternalVideo internalVideo, String videoId) async {
    var list = await MusicApi.loadVideoUrlData(videoId);
    if (list.first.url != null) {
      internalVideo.data?.urlInfo = list.first;
    }
    
    /// 只有设置一个占位链接才能触发播放器 exception
    return internalVideo.data?.urlInfo?.url ?? kFijkExceptionUrl;
  }
}
