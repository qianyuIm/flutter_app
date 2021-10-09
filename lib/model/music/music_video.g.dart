// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicVideo _$MusicVideoFromJson(Map<String, dynamic> json) {
  return MusicVideo(
    json['vid'] as String? ?? '',
    json['duration'] as int? ?? 0,
    json['playTime'] as int? ?? 0,
    json['height'] as int? ?? 1,
    json['width'] as int? ?? 1,
    json['size'] as int? ?? 0,
    json['durationms'] as int? ?? 0,
  )
    ..coverUrl = json['coverUrl'] as String?
    ..creator = (json['creator'] as List<dynamic>?)
        ?.map((e) => MusicArtistUser.fromJson(e as Map<String, dynamic>))
        .toList()
    ..state = json['state'] as int?
    ..coverType = json['coverType'] as int?
    ..videoId = json['videoId'] as String?
    ..title = json['title'] as String?
    ..videoStatus = json['videoStatus'] as int?;
}

Map<String, dynamic> _$MusicVideoToJson(MusicVideo instance) =>
    <String, dynamic>{
      'vid': instance.vid,
      'coverUrl': instance.coverUrl,
      'duration': instance.duration,
      'playTime': instance.playTime,
      'height': instance.height,
      'width': instance.width,
      'creator': instance.creator,
      'size': instance.size,
      'state': instance.state,
      'coverType': instance.coverType,
      'videoId': instance.videoId,
      'title': instance.title,
      'videoStatus': instance.videoStatus,
      'durationms': instance.durationms,
    };
