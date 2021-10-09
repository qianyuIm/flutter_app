// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjRank _$MusicDjRankFromJson(Map<String, dynamic> json) {
  return MusicDjRank(
    json['rank'] as int? ?? 0,
    json['lastRank'] as int? ?? 0,
    json['score'] as int? ?? 0,
    json['programFeeType'] as int? ?? 0,
    json['id'] as int? ?? 0,
  )
    ..nickName = json['nickName'] as String?
    ..avatarUrl = json['avatarUrl'] as String?
    ..userType = json['userType'] as int?
    ..userFollowedCount = json['userFollowedCount'] as int?
    ..avatarDetail = json['avatarDetail'] == null
        ? null
        : MusicArtistUserAvatar.fromJson(
            json['avatarDetail'] as Map<String, dynamic>)
    ..program = json['program'] == null
        ? null
        : MusicDjProgram.fromJson(json['program'] as Map<String, dynamic>)
    ..picUrl = json['picUrl'] as String?
    ..creatorName = json['creatorName'] as String?
    ..name = json['name'] as String?
    ..playCount = json['playCount'] as int?;
}

Map<String, dynamic> _$MusicDjRankToJson(MusicDjRank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rank': instance.rank,
      'lastRank': instance.lastRank,
      'score': instance.score,
      'nickName': instance.nickName,
      'avatarUrl': instance.avatarUrl,
      'userType': instance.userType,
      'userFollowedCount': instance.userFollowedCount,
      'avatarDetail': instance.avatarDetail,
      'programFeeType': instance.programFeeType,
      'program': instance.program,
      'picUrl': instance.picUrl,
      'creatorName': instance.creatorName,
      'name': instance.name,
      'playCount': instance.playCount,
    };
