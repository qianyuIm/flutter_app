import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_ranking.g.dart';

@JsonSerializable()
class MusicRanking {
  int? code;
  List<MusicRankingList>? list;
  MusicRankingArtistToplist? artistToplist;
  MusicRankingRewardToplist? rewardToplist;
  MusicRanking();

  List<String> handleSections() {
    /// 官方榜
    var hasOfficial = ListOptionalHelper.hasValue(
        list?.where((element) => element.tracks?.isNotEmpty == true ).toList());

    /// 全球榜
    var hasGlobal = ListOptionalHelper.hasValue(
        list?.where((element) => element.tracks?.isEmpty == true).toList());

    /// 歌手榜
    var hasArtist = ListOptionalHelper.hasValue(artistToplist?.artists);

    /// 赞赏榜
    var hasReward = ListOptionalHelper.hasValue(rewardToplist?.songs);

    return [
      hasOfficial ? '官方榜' : '',
      hasGlobal ? '全球榜' : '',
      hasArtist ? '歌手榜' : '',
      hasReward ? '赞赏榜' : ''
    ].where((element) => element.isNotEmpty).toList();
  }

  factory MusicRanking.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicRankingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicRankingToJson(this);
}

/// 排行榜
/// -> 'playlist'
@JsonSerializable()
class MusicRankingList {
  List<MusicTrack>? tracks;
  String? updateFrequency;
  @JsonKey(defaultValue: 0)
  final int backgroundCoverId;
  @JsonKey(defaultValue: 0)
  final int trackNumberUpdateTime;
  @JsonKey(defaultValue: 0)
  final int subscribedCount;
  int? createTime;
  String? coverImgUrl;
  @JsonKey(defaultValue: 0)
  final int playCount;
  String? name;
  String? commentThreadId;
  int? updateTime;

  MusicRankingList(this.backgroundCoverId, this.trackNumberUpdateTime,
      this.subscribedCount, this.playCount);

  factory MusicRankingList.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicRankingListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicRankingListToJson(this);
}

@JsonSerializable()
class MusicRankingArtistToplist {
  String? coverUrl;
  String? name;
  String? updateFrequency;
  List<MusicArtist>? artists;
  int? position;

  MusicRankingArtistToplist();

  factory MusicRankingArtistToplist.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicRankingArtistToplistFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicRankingArtistToplistToJson(this);
}

// 云音乐赞赏榜
@JsonSerializable()
class MusicRankingRewardToplist {
  String? coverUrl;
  String? name;

  int? position;
  List<MusicSong>? songs;

  MusicRankingRewardToplist();

  factory MusicRankingRewardToplist.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicRankingRewardToplistFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicRankingRewardToplistToJson(this);
}

@JsonSerializable()
class MusicTrack {
  String? first;
  String? second;
  MusicTrack();

  factory MusicTrack.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicTrackFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicTrackToJson(this);
}
