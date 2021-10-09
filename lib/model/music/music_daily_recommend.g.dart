// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_daily_recommend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDailyRecommend _$MusicDailyRecommendFromJson(Map<String, dynamic> json) {
  return MusicDailyRecommend()
    ..dailySongs = (json['dailySongs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..recommendReasons = (json['recommendReasons'] as List<dynamic>?)
        ?.map((e) =>
            MusicDailyRecommendReason.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicDailyRecommendToJson(
        MusicDailyRecommend instance) =>
    <String, dynamic>{
      'dailySongs': instance.dailySongs,
      'recommendReasons': instance.recommendReasons,
    };

MusicDailyRecommendReason _$MusicDailyRecommendReasonFromJson(
    Map<String, dynamic> json) {
  return MusicDailyRecommendReason(
    json['songId'] as int,
    json['reason'] as String,
  );
}

Map<String, dynamic> _$MusicDailyRecommendReasonToJson(
        MusicDailyRecommendReason instance) =>
    <String, dynamic>{
      'songId': instance.songId,
      'reason': instance.reason,
    };
