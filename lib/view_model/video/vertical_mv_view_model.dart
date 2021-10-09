import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/model/music/internal_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VerticalMVViewModel extends ViewStateModel {
  final int area;
  final int order;
  final int type;
  List<InternalMv> internalMVs;

  VerticalMVViewModel(this.internalMVs,
      {required this.area, required this.order, required this.type}) {
        _offset = internalMVs.length;
      }

  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  bool _hasMore = false;

  int _offset = 0;

  /// 上拉加载更多
  Future<List<InternalMv>?> loadMore() async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(area, type, order, _offset);
      if (data.length == 0) {
        refreshController.loadNoData();
      } else {
        internalMVs.addAll(data);
        refreshController.loadComplete();
        _offset = internalMVs.length;
        notifyListeners();
      }

      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  /// 加载数据
  Future<List<InternalMv>> loadData(int area, int type, int order, int offset) async {
    var map = await MusicApi.loadMvAllData(area, type, order, offset)
        as Map<String, dynamic>;
    _hasMore = map['hasMore'];
    return map['data']
        .map<InternalMv>((video) => InternalMv.fromJson(video))
        .toList();
  }

  /// 获取对应的 mv Url
  Future<String> loadMVUrlData(InternalMv internalMV, int mvId,
      {int r = 480}) async {
    var mvUrl = await MusicApi.loadMVUrlData(mvId, r: r);
    if (mvUrl.url != null) {
      internalMV.mvUrl = mvUrl;
    }

    /// 只有设置一个占位链接才能触发播放器 exception
    return internalMV.mvUrl?.url ?? kFijkExceptionUrl;
  }
}
