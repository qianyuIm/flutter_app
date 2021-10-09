// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_artist_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicArtistDetail _$MusicArtistDetailFromJson(Map<String, dynamic> json) {
  return MusicArtistDetail(
    json['videoCount'] as int? ?? 0,
    json['blacklist'] as bool? ?? false,
    json['showPriMsg'] as bool? ?? false,
  )
    ..artist = json['artist'] == null
        ? null
        : MusicArtist.fromJson(json['artist'] as Map<String, dynamic>)
    ..eventCount = json['eventCount'] as int?
    ..identify = json['identify'] == null
        ? null
        : MusicIdentify.fromJson(json['identify'] as Map<String, dynamic>)
    ..user = json['user'] == null
        ? null
        : MusicArtistUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicArtistDetailToJson(MusicArtistDetail instance) =>
    <String, dynamic>{
      'videoCount': instance.videoCount,
      'blacklist': instance.blacklist,
      'showPriMsg': instance.showPriMsg,
      'artist': instance.artist,
      'eventCount': instance.eventCount,
      'identify': instance.identify,
      'user': instance.user,
    };

MusicIdentify _$MusicIdentifyFromJson(Map<String, dynamic> json) {
  return MusicIdentify()
    ..imageUrl = json['imageUrl'] as String?
    ..imageDesc = json['imageDesc'] as String?
    ..actionUrl = json['actionUrl'] as String?;
}

Map<String, dynamic> _$MusicIdentifyToJson(MusicIdentify instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'imageDesc': instance.imageDesc,
      'actionUrl': instance.actionUrl,
    };
