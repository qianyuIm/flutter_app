// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicArtist _$MusicArtistFromJson(Map<String, dynamic> json) {
  return MusicArtist(
    json['id'] as int? ?? 0,
    json['score'] as int? ?? 0,
    json['lastRank'] as int? ?? 0,
    json['topicPerson'] as int? ?? 0,
    json['albumSize'] as int? ?? 0,
    json['musicSize'] as int? ?? 0,
    json['mvSize'] as int? ?? 0,
    json['followed'] as bool? ?? false,
  )
    ..name = json['name'] as String?
    ..picUrl = json['picUrl'] as String?
    ..img1v1Url = json['img1v1Url'] as String?
    ..first = json['first'] as String?
    ..second = json['second'] as String?
    ..third = json['third'] as int?
    ..alias =
        (json['alias'] as List<dynamic>?)?.map((e) => e as String).toList()
    ..briefDesc = json['briefDesc'] as String?
    ..rank = json['rank'] == null
        ? null
        : MusicRank.fromJson(json['rank'] as Map<String, dynamic>)
    ..identities =
        (json['identities'] as List<dynamic>?)?.map((e) => e as String).toList()
    ..identifyTag = (json['identifyTag'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..cover = json['cover'] as String?
    ..fansCount = json['fansCount'] as int?;
}

Map<String, dynamic> _$MusicArtistToJson(MusicArtist instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'picUrl': instance.picUrl,
      'img1v1Url': instance.img1v1Url,
      'first': instance.first,
      'second': instance.second,
      'third': instance.third,
      'alias': instance.alias,
      'score': instance.score,
      'lastRank': instance.lastRank,
      'topicPerson': instance.topicPerson,
      'briefDesc': instance.briefDesc,
      'rank': instance.rank,
      'identities': instance.identities,
      'identifyTag': instance.identifyTag,
      'albumSize': instance.albumSize,
      'musicSize': instance.musicSize,
      'mvSize': instance.mvSize,
      'cover': instance.cover,
      'followed': instance.followed,
      'fansCount': instance.fansCount,
    };

MusicRank _$MusicRankFromJson(Map<String, dynamic> json) {
  return MusicRank(
    json['rank'] as int? ?? 0,
    json['type'] as int? ?? 0,
  );
}

Map<String, dynamic> _$MusicRankToJson(MusicRank instance) => <String, dynamic>{
      'rank': instance.rank,
      'type': instance.type,
    };
