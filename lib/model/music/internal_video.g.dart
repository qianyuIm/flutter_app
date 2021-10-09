// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternalVideo _$InternalVideoFromJson(Map<String, dynamic> json) {
  return InternalVideo(
    json['type'] as int? ?? 0,
    json['displayed'] as bool? ?? false,
    json['alg'] as String? ?? '',
  )..data = json['data'] == null
      ? null
      : InternalVideoData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InternalVideoToJson(InternalVideo instance) =>
    <String, dynamic>{
      'type': instance.type,
      'displayed': instance.displayed,
      'alg': instance.alg,
      'data': instance.data,
    };

InternalVideoData _$InternalVideoDataFromJson(Map<String, dynamic> json) {
  return InternalVideoData(
    (json['height'] as num?)?.toDouble() ?? 0,
    (json['width'] as num?)?.toDouble() ?? 0,
    json['title'] as String?,
    json['description'] as String? ?? '',
    json['commentCount'] as int? ?? 0,
    json['shareCount'] as int? ?? 0,
  )
    ..alg = json['alg'] as String?
    ..scm = json['scm'] as String?
    ..threadId = json['threadId'] as String?
    ..coverUrl = json['coverUrl'] as String?
    ..resolutions = (json['resolutions'] as List<dynamic>?)
        ?.map((e) => VideoResolution.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..imgurl16v9 = json['imgurl16v9'] as String?
    ..creator = json['creator'] == null
        ? null
        : MusicArtistUser.fromJson(json['creator'] as Map<String, dynamic>)
    ..urlInfo = json['urlInfo'] == null
        ? null
        : InternalVideoUrlInfo.fromJson(json['urlInfo'] as Map<String, dynamic>)
    ..relateSong = (json['relateSong'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..name = json['name'] as String?
    ..vid = json['vid'] as String?
    ..durationms = json['durationms'] as int?
    ..playTime = json['playTime'] as int?
    ..praisedCount = json['praisedCount'] as int?;
}

Map<String, dynamic> _$InternalVideoDataToJson(InternalVideoData instance) =>
    <String, dynamic>{
      'alg': instance.alg,
      'scm': instance.scm,
      'threadId': instance.threadId,
      'coverUrl': instance.coverUrl,
      'height': instance.height,
      'width': instance.width,
      'title': instance.title,
      'description': instance.description,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'resolutions': instance.resolutions,
      'artists': instance.artists,
      'imgurl16v9': instance.imgurl16v9,
      'creator': instance.creator,
      'urlInfo': instance.urlInfo,
      'relateSong': instance.relateSong,
      'name': instance.name,
      'vid': instance.vid,
      'durationms': instance.durationms,
      'playTime': instance.playTime,
      'praisedCount': instance.praisedCount,
    };

VideoResolution _$VideoResolutionFromJson(Map<String, dynamic> json) {
  return VideoResolution(
    json['resolution'] as int? ?? 240,
    json['size'] as int? ?? 0,
  );
}

Map<String, dynamic> _$VideoResolutionToJson(VideoResolution instance) =>
    <String, dynamic>{
      'resolution': instance.resolution,
      'size': instance.size,
    };
