// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicSearchResult _$MusicSearchResultFromJson(Map<String, dynamic> json) {
  return MusicSearchResult()
    ..songCount = json['songCount'] as int?
    ..songs = (json['songs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..albumCount = json['albumCount'] as int?
    ..albums = (json['albums'] as List<dynamic>?)
        ?.map((e) => MusicAlbum.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artistCount = json['artistCount'] as int?
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..playlistCount = json['playlistCount'] as int?
    ..playlists = (json['playlists'] as List<dynamic>?)
        ?.map((e) => MusicPlayList.fromJson(e as Map<String, dynamic>))
        .toList()
    ..userprofileCount = json['userprofileCount'] as int?
    ..userprofiles = (json['userprofiles'] as List<dynamic>?)
        ?.map((e) => MusicUserProfile.fromJson(e as Map<String, dynamic>))
        .toList()
    ..mvCount = json['mvCount'] as int?
    ..mvs = (json['mvs'] as List<dynamic>?)
        ?.map((e) => MusicMV.fromJson(e as Map<String, dynamic>))
        .toList()
    ..djRadiosCount = json['djRadiosCount'] as int?
    ..djRadios = (json['djRadios'] as List<dynamic>?)
        ?.map((e) => MusicDjRadio.fromJson(e as Map<String, dynamic>))
        .toList()
    ..videoCount = json['videoCount'] as int?
    ..videos = (json['videos'] as List<dynamic>?)
        ?.map((e) => MusicVideo.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicSearchResultToJson(MusicSearchResult instance) =>
    <String, dynamic>{
      'songCount': instance.songCount,
      'songs': instance.songs,
      'albumCount': instance.albumCount,
      'albums': instance.albums,
      'artistCount': instance.artistCount,
      'artists': instance.artists,
      'playlistCount': instance.playlistCount,
      'playlists': instance.playlists,
      'userprofileCount': instance.userprofileCount,
      'userprofiles': instance.userprofiles,
      'mvCount': instance.mvCount,
      'mvs': instance.mvs,
      'djRadiosCount': instance.djRadiosCount,
      'djRadios': instance.djRadios,
      'videoCount': instance.videoCount,
      'videos': instance.videos,
    };
