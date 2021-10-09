import 'package:draggable_container/draggable_container.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/model/music/internal_video.dart';
import 'package:flutter_app/model/music/video_category.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert' as convert;

const kRecommendedCategoryId = -1;

class InternalVideoSelectedItem extends DraggableItem {
  final VideoCategory category;
  bool deletable;
  bool fixed;
  int location;

  InternalVideoSelectedItem({
    required this.category,
    this.deletable = true,
    this.fixed = false,
    this.location = 0,
  });

  factory InternalVideoSelectedItem.fromDBMap(Map<String, dynamic> json) {
    return InternalVideoSelectedItem(
      category: VideoCategory.fromJson(
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

class InternalVideoUnSelectedItem extends DraggableItem {
  final VideoCategory category;
  bool deletable;
  bool fixed;

  InternalVideoUnSelectedItem({
    required this.category,
    this.deletable = false,
    this.fixed = true,
  });
}

class InternalVideoGroupViewModel extends ViewStateModel {
  List<InternalVideoUnSelectedItem> unSelectedItem = [];
  List<InternalVideoSelectedItem> selectedItem = [];
  initData() async {
    setBusy();
    try {
      List<VideoCategory> loadCategorys =
          await MusicApi.loadVideoGroupListData();

      /// 从数据库查询
      selectedItem = await LocalDb.instance.internalVideoCategoryDb.queryAll();
      final categoryIdList = selectedItem.map((element) {
        return element.category.categoryId;
      }).toList();

      unSelectedItem = loadCategorys
          .where((element) => !categoryIdList.contains(element.categoryId))
          .map((category) => InternalVideoUnSelectedItem(category: category))
          .toList();

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class InternalVideoContainerCategoryViewModel extends ViewStateModel {
  List<InternalVideoSelectedItem> categorys = [];
  Future<void> initData() async {
    setBusy();
    try {
      /// 从数据库查询
      var local = await LocalDb.instance.internalVideoCategoryDb.queryAll();
      if (local.length == 0) {
        List<VideoCategory> loadCategorys =
            await MusicApi.loadVideoCategoryListData();
        /// 添加推荐
        VideoCategory recommendedCategory =
            VideoCategory(kRecommendedCategoryId, '推荐', '');
        loadCategorys.insert(0, recommendedCategory);
        categorys = loadCategorys.asMap().keys.map((e) {
          var ele = loadCategorys[e];
          return InternalVideoSelectedItem(
              category: ele,
              deletable: ele.categoryId != kRecommendedCategoryId,
              fixed: ele.categoryId == kRecommendedCategoryId,
              location: e);
        }).toList();

        /// 插入数据库
        await LocalDb.instance.internalVideoCategoryDb.insertAll(categorys);
      } else {
        categorys = local;
      }

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class InternalVideoViewModel extends ViewStateModel {
  /// 上拉加载/下拉刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;
  List<InternalVideo> videos = [];

  bool _hasMore = false;
  final int categoryId;
  int _offset = 0;

  InternalVideoViewModel(this.categoryId);
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<List<InternalVideo>?> refresh({bool init = false}) async {
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
  }

  /// 上拉加载更多
  Future loadMore() async {
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
    if (categoryId == kRecommendedCategoryId) {
      var map = await MusicApi.loadVideoTimelineRecommendData(offset)
          as Map<String, dynamic>;
      _hasMore = map['hasmore'];
      return map['datas'].map<InternalVideo>((video) {
        return InternalVideo.fromJson(video);
      }).toList();
    } else {
      var map = await MusicApi.loadVideoGroupData(categoryId, offset)
          as Map<String, dynamic>;
      _hasMore = map['hasmore'];
      return map['datas']
          .map<InternalVideo>((video) => InternalVideo.fromJson(video))
          .toList();
    }
  }

  List<InternalVideo> onCompleted(List<InternalVideo> interVideos) {
    return interVideos
        .where((element) => element.data?.coverUrl != null)
        .toList();
  }
}
