import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_daily_recommend.g.dart';

@JsonSerializable()
class MusicDailyRecommend {
  List<MusicSong>? dailySongs;
  List<MusicDailyRecommendReason>? recommendReasons;
  MusicDailyRecommend();

  factory MusicDailyRecommend.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDailyRecommendFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDailyRecommendToJson(this);
}


@JsonSerializable()
class MusicDailyRecommendReason {
  final int songId;
  final String reason;
  
  MusicDailyRecommendReason(this.songId, this.reason);

  factory MusicDailyRecommendReason.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDailyRecommendReasonFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDailyRecommendReasonToJson(this);
}
