// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_personalized.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjPersonalized _$MusicDjPersonalizedFromJson(Map<String, dynamic> json) {
  return MusicDjPersonalized(
    json['id'] as int? ?? 0,
    json['type'] as int? ?? 0,
    json['canDislike'] as bool? ?? false,
  )
    ..name = json['name'] as String?
    ..copywriter = json['copywriter'] as String?
    ..picUrl = json['picUrl'] as String?
    ..program = json['program'] == null
        ? null
        : MusicDjProgram.fromJson(json['program'] as Map<String, dynamic>)
    ..alg = json['alg'] as String?;
}

Map<String, dynamic> _$MusicDjPersonalizedToJson(
        MusicDjPersonalized instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'copywriter': instance.copywriter,
      'picUrl': instance.picUrl,
      'canDislike': instance.canDislike,
      'program': instance.program,
      'alg': instance.alg,
    };
