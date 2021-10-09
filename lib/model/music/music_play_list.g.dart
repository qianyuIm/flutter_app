// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_play_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPlayList _$MusicPlayListFromJson(Map<String, dynamic> json) {
  return MusicPlayList(
    json['id'] as int? ?? 0,
    json['trackCount'] as int? ?? 0,
    json['highQuality'] as bool? ?? false,
    json['privacy'] as int? ?? 0,
  )
    ..name = json['name'] as String?
    ..coverImgUrl = json['coverImgUrl'] as String?
    ..description = json['description'] as String?
    ..playCount = json['playCount'] as int?
    ..createTime = json['createTime'] as int?
    ..userId = json['userId'] as int?
    ..subscribed = json['subscribed'] as bool?
    ..subscribedCount = json['subscribedCount'] as int?
    ..commentCount = json['commentCount'] as int?
    ..shareCount = json['shareCount'] as int?
    ..songs = (json['tracks'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..creator = json['creator'] == null
        ? null
        : MusicCreator.fromJson(json['creator'] as Map<String, dynamic>)
    ..trackIds = (json['trackIds'] as List<dynamic>?)
        ?.map((e) => MusicTrackId.fromJson(e as Map<String, dynamic>))
        .toList()
    ..trackSongs = (json['trackSongs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..subscribers = (json['subscribers'] as List<dynamic>?)
        ?.map((e) => MusicUserProfile.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicPlayListToJson(MusicPlayList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverImgUrl': instance.coverImgUrl,
      'description': instance.description,
      'playCount': instance.playCount,
      'trackCount': instance.trackCount,
      'createTime': instance.createTime,
      'userId': instance.userId,
      'subscribed': instance.subscribed,
      'subscribedCount': instance.subscribedCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'tracks': instance.songs,
      'creator': instance.creator,
      'trackIds': instance.trackIds,
      'trackSongs': instance.trackSongs,
      'subscribers': instance.subscribers,
      'highQuality': instance.highQuality,
      'privacy': instance.privacy,
    };
