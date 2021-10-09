// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDj _$MusicDjFromJson(Map<String, dynamic> json) {
  return MusicDj(
    json['province'] as int? ?? 0,
    json['followed'] as bool? ?? false,
    json['accountStatus'] as int? ?? 0,
    json['gender'] as int? ?? 0,
    json['city'] as int? ?? 0,
    json['birthday'] as int? ?? 0,
    json['userId'] as int? ?? 0,
    json['djStatus'] as int? ?? 0,
    json['vipType'] as int? ?? 0,
  )
    ..avatarUrl = json['avatarUrl'] as String?
    ..nickname = json['nickname'] as String?
    ..signature = json['signature'] as String?
    ..backgroundUrl = json['backgroundUrl'] as String?;
}

Map<String, dynamic> _$MusicDjToJson(MusicDj instance) => <String, dynamic>{
      'province': instance.province,
      'followed': instance.followed,
      'avatarUrl': instance.avatarUrl,
      'accountStatus': instance.accountStatus,
      'gender': instance.gender,
      'city': instance.city,
      'birthday': instance.birthday,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'signature': instance.signature,
      'backgroundUrl': instance.backgroundUrl,
      'djStatus': instance.djStatus,
      'vipType': instance.vipType,
    };
