// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_mlog_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicMlogVideo _$MusicMlogVideoFromJson(Map<String, dynamic> json) {
  return MusicMlogVideo(
    json['duration'] as int? ?? 0,
    json['width'] as int? ?? 1,
    json['height'] as int? ?? 1,
  )
    ..videoKey = json['videoKey'] as String?
    ..coverUrl = json['coverUrl'] as String?
    ..frameUrl = json['frameUrl'] as String?
    ..urlInfo = json['urlInfo'] == null
        ? null
        : MusicMlogVideoUrlInfo.fromJson(
            json['urlInfo'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicMlogVideoToJson(MusicMlogVideo instance) =>
    <String, dynamic>{
      'videoKey': instance.videoKey,
      'duration': instance.duration,
      'coverUrl': instance.coverUrl,
      'frameUrl': instance.frameUrl,
      'width': instance.width,
      'height': instance.height,
      'urlInfo': instance.urlInfo,
    };

MusicMlogVideoUrlInfo _$MusicMlogVideoUrlInfoFromJson(
    Map<String, dynamic> json) {
  return MusicMlogVideoUrlInfo(
    json['size'] as int? ?? 0,
  )
    ..id = json['id'] as String?
    ..url = json['url'] as String?
    ..r = json['r'] as int?
    ..validityTime = json['validityTime'] as int?;
}

Map<String, dynamic> _$MusicMlogVideoUrlInfoToJson(
        MusicMlogVideoUrlInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'size': instance.size,
      'r': instance.r,
      'validityTime': instance.validityTime,
    };
