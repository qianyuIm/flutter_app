// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_categorie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjCategorie _$MusicDjCategorieFromJson(Map<String, dynamic> json) {
  return MusicDjCategorie(
    json['name'] as String? ?? '',
    json['id'] as int? ?? 0,
    json['isRank'] as bool? ?? false,
    json['isMyDj'] as bool? ?? false,
  )..pic96x96Url = json['pic96x96Url'] as String?;
}

Map<String, dynamic> _$MusicDjCategorieToJson(MusicDjCategorie instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'pic96x96Url': instance.pic96x96Url,
      'isRank': instance.isRank,
      'isMyDj': instance.isMyDj,
    };
