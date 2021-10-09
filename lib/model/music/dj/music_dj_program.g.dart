// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjProgram _$MusicDjProgramFromJson(Map<String, dynamic> json) {
  return MusicDjProgram(
    json['subscribedCount'] as int? ?? 0,
    json['reward'] as bool? ?? false,
    json['mainTrackId'] as int? ?? 0,
    json['serialNum'] as int? ?? 0,
    json['listenerCount'] as int? ?? 0,
    json['name'] as String? ?? '',
    json['id'] as int? ?? 0,
    json['buyed'] as bool? ?? false,
    json['subscribed'] as bool? ?? false,
    json['likedCount'] as int? ?? 0,
    json['isPublish'] as bool? ?? false,
    json['commentCount'] as int? ?? 0,
  )
    ..mainSong = json['mainSong'] == null
        ? null
        : MusicSong.fromJson(json['mainSong'] as Map<String, dynamic>)
    ..dj = json['dj'] == null
        ? null
        : MusicDj.fromJson(json['dj'] as Map<String, dynamic>)
    ..blurCoverUrl = json['blurCoverUrl'] as String?
    ..radio = json['radio'] == null
        ? null
        : MusicDjRadio.fromJson(json['radio'] as Map<String, dynamic>)
    ..createTime = json['createTime'] as int?
    ..description = json['description'] as String?
    ..userId = json['userId'] as int?
    ..coverUrl = json['coverUrl'] as String?
    ..commentThreadId = json['commentThreadId'] as String?
    ..pubStatus = json['pubStatus'] as int?
    ..trackCount = json['trackCount'] as int?
    ..bdAuditStatus = json['bdAuditStatus'] as int?
    ..programFeeType = json['programFeeType'] as int?
    ..adjustedPlayCount = json['adjustedPlayCount'] as int?
    ..auditStatus = json['auditStatus'] as int?
    ..duration = json['duration'] as int?
    ..shareCount = json['shareCount'] as int?;
}

Map<String, dynamic> _$MusicDjProgramToJson(MusicDjProgram instance) =>
    <String, dynamic>{
      'mainSong': instance.mainSong,
      'dj': instance.dj,
      'blurCoverUrl': instance.blurCoverUrl,
      'radio': instance.radio,
      'subscribedCount': instance.subscribedCount,
      'reward': instance.reward,
      'mainTrackId': instance.mainTrackId,
      'serialNum': instance.serialNum,
      'listenerCount': instance.listenerCount,
      'name': instance.name,
      'id': instance.id,
      'createTime': instance.createTime,
      'description': instance.description,
      'userId': instance.userId,
      'coverUrl': instance.coverUrl,
      'commentThreadId': instance.commentThreadId,
      'pubStatus': instance.pubStatus,
      'trackCount': instance.trackCount,
      'bdAuditStatus': instance.bdAuditStatus,
      'programFeeType': instance.programFeeType,
      'buyed': instance.buyed,
      'adjustedPlayCount': instance.adjustedPlayCount,
      'auditStatus': instance.auditStatus,
      'duration': instance.duration,
      'shareCount': instance.shareCount,
      'subscribed': instance.subscribed,
      'likedCount': instance.likedCount,
      'isPublish': instance.isPublish,
      'commentCount': instance.commentCount,
    };
