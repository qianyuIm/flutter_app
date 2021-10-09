// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_play_list_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPlaylistContainer _$MusicPlaylistContainerFromJson(
    Map<String, dynamic> json) {
  return MusicPlaylistContainer(
    json['total'] as int? ?? 0,
    json['more'] as bool? ?? false,
  )
    ..playlists = (json['playlists'] as List<dynamic>?)
        ?.map((e) => MusicPlayList.fromJson(e as Map<String, dynamic>))
        .toList()
    ..cat = json['cat'] as String?;
}

Map<String, dynamic> _$MusicPlaylistContainerToJson(
        MusicPlaylistContainer instance) =>
    <String, dynamic>{
      'playlists': instance.playlists,
      'total': instance.total,
      'more': instance.more,
      'cat': instance.cat,
    };
