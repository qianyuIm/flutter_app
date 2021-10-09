// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicMetadata _$MusicMetadataFromJson(Map<String, dynamic> json) {
  return MusicMetadata(
    json['id'] as int? ?? 0,
    json['expi'] as int? ?? 0,
  )
    ..url = json['url'] as String?
    ..size = json['size'] as int?
    ..type = json['type'] as String?
    ..insertDbTime = json['insertDbTime'] as int?;
}

Map<String, dynamic> _$MusicMetadataToJson(MusicMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'size': instance.size,
      'type': instance.type,
      'expi': instance.expi,
      'insertDbTime': instance.insertDbTime,
    };
