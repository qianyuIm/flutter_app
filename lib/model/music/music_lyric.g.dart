// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_lyric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicLyric _$MusicLyricFromJson(Map<String, dynamic> json) {
  return MusicLyric(
    json['sgc'] as bool? ?? false,
    json['sfy'] as bool? ?? false,
    json['qfy'] as bool? ?? false,
  )
    ..songId = json['songId'] as int?
    ..lrc = json['lrc'] == null
        ? null
        : MusicLrc.fromJson(json['lrc'] as Map<String, dynamic>)
    ..klyric = json['klyric'] == null
        ? null
        : MusicKlyric.fromJson(json['klyric'] as Map<String, dynamic>)
    ..tlyric = json['tlyric'] == null
        ? null
        : MusicTlyric.fromJson(json['tlyric'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicLyricToJson(MusicLyric instance) =>
    <String, dynamic>{
      'songId': instance.songId,
      'sgc': instance.sgc,
      'sfy': instance.sfy,
      'qfy': instance.qfy,
      'lrc': instance.lrc,
      'klyric': instance.klyric,
      'tlyric': instance.tlyric,
    };

MusicLrc _$MusicLrcFromJson(Map<String, dynamic> json) {
  return MusicLrc(
    version: json['version'] as int?,
  )..lyric = json['lyric'] as String?;
}

Map<String, dynamic> _$MusicLrcToJson(MusicLrc instance) => <String, dynamic>{
      'version': instance.version,
      'lyric': instance.lyric,
    };

MusicKlyric _$MusicKlyricFromJson(Map<String, dynamic> json) {
  return MusicKlyric(
    version: json['version'] as int?,
  )..lyric = json['lyric'] as String?;
}

Map<String, dynamic> _$MusicKlyricToJson(MusicKlyric instance) =>
    <String, dynamic>{
      'version': instance.version,
      'lyric': instance.lyric,
    };

MusicTlyric _$MusicTlyricFromJson(Map<String, dynamic> json) {
  return MusicTlyric(
    version: json['version'] as int?,
  )..lyric = json['lyric'] as String?;
}

Map<String, dynamic> _$MusicTlyricToJson(MusicTlyric instance) =>
    <String, dynamic>{
      'version': instance.version,
      'lyric': instance.lyric,
    };
