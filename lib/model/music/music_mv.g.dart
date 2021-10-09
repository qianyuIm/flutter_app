// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_mv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicMV _$MusicMVFromJson(Map<String, dynamic> json) {
  return MusicMV(
    json['id'] as int? ?? 0,
    json['type'] as int? ?? 0,
    json['canDislike'] as bool? ?? false,
    json['playCount'] as int? ?? 0,
    json['height'] as int? ?? 1,
    json['width'] as int? ?? 1,
    json['duration'] as int? ?? 0,
  )
    ..name = json['name'] as String?
    ..copywriter = json['copywriter'] as String?
    ..picUrl = json['picUrl'] as String?
    ..cover = json['cover'] as String?
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artistName = json['artistName'] as String?
    ..artistId = json['artistId'] as int?
    ..alg = json['alg'] as String?
    ..imgurl = json['imgurl'] as String?
    ..imgurl16v9 = json['imgurl16v9'] as String?;
}

Map<String, dynamic> _$MusicMVToJson(MusicMV instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'copywriter': instance.copywriter,
      'picUrl': instance.picUrl,
      'cover': instance.cover,
      'canDislike': instance.canDislike,
      'duration': instance.duration,
      'playCount': instance.playCount,
      'artists': instance.artists,
      'artistName': instance.artistName,
      'artistId': instance.artistId,
      'alg': instance.alg,
      'imgurl': instance.imgurl,
      'imgurl16v9': instance.imgurl16v9,
      'height': instance.height,
      'width': instance.width,
    };

MusicMVUrl _$MusicMVUrlFromJson(Map<String, dynamic> json) {
  return MusicMVUrl(
    json['id'] as int? ?? 0,
  )
    ..url = json['url'] as String?
    ..r = json['r'] as int?
    ..size = json['size'] as int?
    ..expi = json['expi'] as int?;
}

Map<String, dynamic> _$MusicMVUrlToJson(MusicMVUrl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'r': instance.r,
      'size': instance.size,
      'expi': instance.expi,
    };
