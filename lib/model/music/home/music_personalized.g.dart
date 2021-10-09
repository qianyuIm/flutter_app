// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_personalized.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicPersonalized _$MusicPersonalizedFromJson(Map<String, dynamic> json) {
  return MusicPersonalized(
    id: json['id'] as int?,
  )
    ..type = json['type'] as int?
    ..name = json['name'] as String?
    ..copywriter = json['copywriter'] as String?
    ..picUrl = json['picUrl'] as String?
    ..canDislike = json['canDislike'] as bool?
    ..alg = json['alg'] as String?
    ..userId = json['userId'] as int?
    ..playcount = json['playcount'] as int?
    ..createTime = json['createTime'] as int?
    ..creator = json['creator'] == null
        ? null
        : MusicCreator.fromJson(json['creator'] as Map<String, dynamic>)
    ..song = json['song'] == null
        ? null
        : MusicSong.fromJson(json['song'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicPersonalizedToJson(MusicPersonalized instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'copywriter': instance.copywriter,
      'picUrl': instance.picUrl,
      'canDislike': instance.canDislike,
      'alg': instance.alg,
      'userId': instance.userId,
      'playcount': instance.playcount,
      'createTime': instance.createTime,
      'creator': instance.creator,
      'song': instance.song,
    };
