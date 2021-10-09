import 'package:flutter_app/model/music/music_user_box_event.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicUserEventViewModel extends ViewStateModel {
  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final int uid;
  MusicUserEventViewModel(this.uid);

  RefreshController get refreshController => _refreshController;
  List<MusicUserEvent> events = [];
  int? _lasttime;
  bool _more = false;

  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<MusicUserBoxEvent?> refresh({bool init = false}) async {
    try {
      var data = await loadData(_lasttime);
      _lasttime = data.lasttime;
      _more = data.more;
      if (data.events == null) {
        refreshController.refreshCompleted(resetFooterState: true);
        events.clear();
        setEmpty();
      } else {
        onCompleted(data);
        events.clear();
        events.addAll(data.events!);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        setIdle();
      }
      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) events.clear();
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future<MusicUserBoxEvent?> loadMore() async {
    if (!_more) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(_lasttime);
      _lasttime = data.lasttime;
      _more = data.more;
      if (data.events == null) {
        refreshController.loadNoData();
      } else {
        onCompleted(data);
        events.addAll(data.events!);
        refreshController.loadComplete();
        notifyListeners();
      }
      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<MusicUserBoxEvent> loadData(int? lasttime) async {
    return await MusicApi.loadUserEventData(this.uid, lasttime);
  }

  /// 数据请求完成
  onCompleted(MusicUserBoxEvent data) {}
}
