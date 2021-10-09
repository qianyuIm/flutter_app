// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_per_new_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPerNewSong _$MusicPerNewSongFromJson(Map<String, dynamic> json) {
  return MusicPerNewSong(
    id: json['id'] as int?,
    canDislike: json['canDislike'] as bool?,
  )
    ..type = json['type'] as int?
    ..name = json['name'] as String?
    ..picUrl = json['picUrl'] as String?
    ..song = json['song'] == null
        ? null
        : MusicSong.fromJson(json['song'] as Map<String, dynamic>)
    ..alg = json['alg'] as String?;
}

Map<String, dynamic> _$MusicPerNewSongToJson(MusicPerNewSong instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'picUrl': instance.picUrl,
      'canDislike': instance.canDislike,
      'song': instance.song,
      'alg': instance.alg,
    };
