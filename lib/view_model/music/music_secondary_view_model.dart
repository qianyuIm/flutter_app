import 'package:flustars/flustars.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_artist_detail.dart';
import 'package:flutter_app/model/music/music_ranking.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/provider/view_state_model.dart';

class MusicRankingViewModel extends ViewStateModel {
  late MusicRanking ranking;
  late List<String> sections;

  initData() async {
    setBusy();
    try {
      ranking = await MusicApi.loadToplistDetailData();
      // await Future.delayed(Duration(seconds: 3));
      LogUtil.v('这里需要处理下数据');
      sections = ranking.handleSections();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  /// 是否有 官方榜
  bool get hasOfficial => sections.contains('官方榜');

  /// 是否有 全球榜
  bool get hasGlobal => sections.contains('全球榜');

  /// 是否有 歌手榜
  bool get hasArtist => sections.contains('歌手榜');

  /// 是否有 赞赏榜
  bool get hasReward => sections.contains('赞赏榜');
}

class MusicArtistRankingListViewModel extends ViewStateModel {
  late List<MusicArtist> artists;
  final int type;

  MusicArtistRankingListViewModel(this.type);

  initData() async {
    setBusy();
    try {
      artists = await MusicApi.loadToplistArtistData(this.type);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 歌手详情
class MusicArtistViewModel extends ViewStateModel {
  late MusicArtistDetail artistDetail;
  final int artistId;
  MusicArtistViewModel(this.artistId);

  initData() async {
    setBusy();
    try {
      artistDetail = await MusicApi.loadArtistDetailData(this.artistId);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 相似歌手
class MusicSimiArtistViewModel extends ViewStateModel {
  late List<MusicArtist> artists;
  final int artistId;
  MusicSimiArtistViewModel(this.artistId);

  initData() async {
    setBusy();
    try {
      artists = await MusicApi.loadSimiArtistsData(this.artistId);
      // await Future.delayed(Duration(seconds: 3));
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}
/// 歌手 50首音乐
class MusicArtistTopSongViewModel extends ViewStateModel {
  late List<MusicSong> songs;
  final int artistId;
  MusicArtistTopSongViewModel(this.artistId);

  initData() async {
    setBusy();
    try {
      songs = await MusicApi.loadArtistTopSongData(this.artistId);
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}
