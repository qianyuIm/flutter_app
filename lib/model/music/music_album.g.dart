// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicAlbum _$MusicAlbumFromJson(Map<String, dynamic> json) {
  return MusicAlbum(
    json['id'] as int? ?? 0,
    json['companyId'] as int? ?? 0,
    json['paid'] as bool? ?? false,
    json['onSale'] as bool? ?? false,
    json['size'] as int? ?? 0,
  )
    ..type = json['type'] as String?
    ..picUrl = json['picUrl'] as String?
    ..name = json['name'] as String?
    ..publishTime = json['publishTime'] as int?
    ..company = json['company'] as String?
    ..songs = (json['songs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList()
    ..blurPicUrl = json['blurPicUrl'] as String?
    ..copyrightId = json['copyrightId'] as int?
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artist = json['artist'] == null
        ? null
        : MusicArtist.fromJson(json['artist'] as Map<String, dynamic>)
    ..subType = json['subType'] as String?;
}

Map<String, dynamic> _$MusicAlbumToJson(MusicAlbum instance) =>
    <String, dynamic>{
      'type': instance.type,
      'picUrl': instance.picUrl,
      'companyId': instance.companyId,
      'name': instance.name,
      'publishTime': instance.publishTime,
      'id': instance.id,
      'company': instance.company,
      'songs': instance.songs,
      'paid': instance.paid,
      'onSale': instance.onSale,
      'blurPicUrl': instance.blurPicUrl,
      'copyrightId': instance.copyrightId,
      'artists': instance.artists,
      'artist': instance.artist,
      'subType': instance.subType,
      'size': instance.size,
    };
