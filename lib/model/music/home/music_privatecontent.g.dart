// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_privatecontent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPrivateContent _$MusicPrivateContentFromJson(Map<String, dynamic> json) {
  return MusicPrivateContent(
    json['id'] as int? ?? 0,
    json['copywriter'] as String? ?? '',
    json['name'] as String? ?? '',
    json['type'] as int? ?? 0,
  )
    ..url = json['url'] as String?
    ..picUrl = json['picUrl'] as String?
    ..sPicUrl = json['sPicUrl'] as String?
    ..alg = json['alg'] as String?;
}

Map<String, dynamic> _$MusicPrivateContentToJson(
        MusicPrivateContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'picUrl': instance.picUrl,
      'sPicUrl': instance.sPicUrl,
      'copywriter': instance.copywriter,
      'name': instance.name,
      'type': instance.type,
      'alg': instance.alg,
    };
