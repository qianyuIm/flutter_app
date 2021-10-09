import 'package:flutter_app/model/comment/comment_container.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentViewModel extends ViewStateModel {
  

  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<Comment> comments = [];

  bool _hasMore = false;
  int get totalCount => _totalCount;
  int _totalCount = 0;

  int _pageNo = 1;
  String? _cursor;

  List<CommentSortType> sortTypeList = [];
  late int _sortType;
  Future initData(int sortType,String resourceId,int commentType) async {
    _sortType = sortType;
    setBusy();
    try {
      _pageNo = 1;
      var data = await loadData(resourceId, commentType, sortType);

      if (data.comments == null || data.comments?.length == 0) {
        refreshController.refreshCompleted(resetFooterState: true);
        comments.clear();
        setEmpty();
      } else {
        comments.clear();
        comments.addAll(data.comments!);
        refreshController.refreshCompleted();
        //防止上次上拉加载更多失败,需要重置状态
        refreshController.loadComplete();
        _pageNo += 1;
        setIdle();
      }

      return data;
    } catch (e, s) {
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示

      comments.clear();

      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  Future<CommentContainer?> refresh({bool init = false}) async {}

  /// 上拉加载更多
  Future<CommentContainer?> loadMore(String resourceId,int commentType) async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return null;
    }
    try {
      var data = await loadData(resourceId, commentType, _sortType);
      if (data.comments == null || data.comments?.length == 0) {
        refreshController.loadNoData();
      } else {
        comments.addAll(data.comments!);
        refreshController.loadComplete();
        _pageNo += 1;
        notifyListeners();
      }

      return data;
    } catch (e) {
      refreshController.loadFailed();
      return null;
    }
  }

  // /// 加载数据
  Future<CommentContainer> loadData(
      String resourceId, int commentType, int sortType) async {
    var commentContainer = await MusicApi.loadNewCommentData(
        resourceId, commentType,
        sortType: sortType, pageNo: _pageNo, cursor: _cursor);
    _cursor = commentContainer.cursor;
    _hasMore = commentContainer.hasMore && (commentContainer.comments?.length == 20);
    _totalCount = commentContainer.totalCount;
    sortTypeList = commentContainer.sortTypeList ?? [];
    return commentContainer;
  }
}
