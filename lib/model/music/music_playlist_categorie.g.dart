// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_playlist_categorie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPlaylistCategorieContainer _$MusicPlaylistCategorieContainerFromJson(
    Map<String, dynamic> json) {
  return MusicPlaylistCategorieContainer()
    ..all = json['all'] == null
        ? null
        : MusicPlaylistCategorie.fromJson(json['all'] as Map<String, dynamic>)
    ..sub = (json['sub'] as List<dynamic>?)
        ?.map((e) => MusicPlaylistCategorie.fromJson(e as Map<String, dynamic>))
        .toList()
    ..categories = json['categories'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$MusicPlaylistCategorieContainerToJson(
        MusicPlaylistCategorieContainer instance) =>
    <String, dynamic>{
      'all': instance.all,
      'sub': instance.sub,
      'categories': instance.categories,
    };

MusicPlaylistCategorie _$MusicPlaylistCategorieFromJson(
    Map<String, dynamic> json) {
  return MusicPlaylistCategorie(
    json['name'] as String? ?? '',
    json['type'] as int? ?? 0,
    json['category'] as int? ?? 0,
    json['resourceType'] as int? ?? 0,
    json['hot'] as bool? ?? false,
    json['activity'] as bool? ?? false,
  )..resourceCount = json['resourceCount'] as int?;
}

Map<String, dynamic> _$MusicPlaylistCategorieToJson(
        MusicPlaylistCategorie instance) =>
    <String, dynamic>{
      'name': instance.name,
      'resourceCount': instance.resourceCount,
      'type': instance.type,
      'category': instance.category,
      'resourceType': instance.resourceType,
      'hot': instance.hot,
      'activity': instance.activity,
    };
