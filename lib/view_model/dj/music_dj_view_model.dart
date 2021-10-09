import 'package:flutter_app/model/music/dj/music_dj_banner.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie.dart';
import 'package:flutter_app/model/music/dj/music_dj_categorie_recommend.dart';
import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/model/music/dj/music_dj_rank.dart';
import 'package:flutter_app/network/music_api/music_api_dj_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';

/// 电台banner
class MusicDJBannerViewModel extends ViewStateModel {
  List<MusicDjBanner> banners = [];

  initData() async {
    setBusy();
    try {
      banners = await MusicApiDjImp.loadDJBannerData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 电台分类
class MusicDJCategorieViewModel extends ViewStateModel {
  List<MusicDjCategorie> categories = [];
  initData() async {
    setBusy();
    try {
      categories = await MusicApiDjImp.loadDJCatelistData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 电台个性化推荐
class MusicDJPersonalizeRecommendViewModel extends ViewStateModel {
  List<MusicDjRadio> djRadios = [];
  initData() async {
    setBusy();
    try {
      djRadios = await MusicApiDjImp.loadDJPersonalizeRecommendData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 电台分类推荐
class MusicDJCategoryRecommendViewModel extends ViewStateModel {
  List<MusicDJCategorieRecommend> categorieRecommends = [];
  initData() async {
    setBusy();
    try {
      categorieRecommends = await MusicApiDjImp.loadDjCategoryRecommendData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}
/// 主播榜
class MusicDJRankViewModel extends ViewStateModel {
  /// 0: 24小时
  /// 1： 热门
  /// 2： 新人榜
  final int djRankType;

  MusicDJRankViewModel(this.djRankType);
  List<MusicDjRank> djRanks = [];

  initData() async {
    setBusy();
    try {
      if (djRankType == 0) {
        djRanks = await MusicApiDjImp.loadDJToplistHoursData();
      } else if (djRankType == 1) {
        djRanks = await MusicApiDjImp.loadDJToplistPopularData();
      } else {
        djRanks = await MusicApiDjImp.loadDJToplistNewComerData();
      }

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 播客榜  节目榜
class MusicDJProgramRankViewModel extends ViewStateModel {
  /// 0: 24小时
  /// 1： 节目榜
  /// 2： 新晋电台
  /// 3： 热门电台
  final int djProgramType;

  MusicDJProgramRankViewModel(this.djProgramType);
  List<MusicDjRank> djRanks = [];

  initData() async {
    setBusy();
    try {
      if (djProgramType == 0) {
        djRanks = await MusicApiDjImp.loadDJProgramToplistHoursData();
      } else if (djProgramType == 1) {
        djRanks = await MusicApiDjImp.loadDJProgramToplistData();
      } else if (djProgramType == 2){
        djRanks = await MusicApiDjImp.loadDJToplistData('new');
      } else {
        djRanks = await MusicApiDjImp.loadDJToplistData('hot');
      }
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}
