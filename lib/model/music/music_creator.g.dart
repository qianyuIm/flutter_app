// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicCreator _$MusicCreatorFromJson(Map<String, dynamic> json) {
  return MusicCreator()
    ..backgroundUrl = json['backgroundUrl'] as String?
    ..avatarImgIdStr = json['avatarImgIdStr'] as String?
    ..avatarImgId = json['avatarImgId'] as int?
    ..backgroundImgId = json['backgroundImgId'] as int?
    ..backgroundImgIdStr = json['backgroundImgIdStr'] as String?
    ..userId = json['userId'] as int?
    ..province = json['province'] as int?
    ..avatarUrl = json['avatarUrl'] as String?
    ..nickname = json['nickname'] as String?
    ..gender = json['gender'] as int?
    ..birthday = json['birthday'] as int?
    ..city = json['city'] as int?;
}

Map<String, dynamic> _$MusicCreatorToJson(MusicCreator instance) =>
    <String, dynamic>{
      'backgroundUrl': instance.backgroundUrl,
      'avatarImgIdStr': instance.avatarImgIdStr,
      'avatarImgId': instance.avatarImgId,
      'backgroundImgId': instance.backgroundImgId,
      'backgroundImgIdStr': instance.backgroundImgIdStr,
      'userId': instance.userId,
      'province': instance.province,
      'avatarUrl': instance.avatarUrl,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'city': instance.city,
    };
