// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_artist_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicArtistUser _$MusicArtistUserFromJson(Map<String, dynamic> json) {
  return MusicArtistUser(
    json['authenticated'] as bool? ?? false,
    json['gender'] as int? ?? 1,
    json['followed'] as bool? ?? false,
  )
    ..backgroundUrl = json['backgroundUrl'] as String?
    ..birthday = json['birthday'] as int?
    ..detailDescription = json['detailDescription'] as String?
    ..city = json['city'] as int?
    ..description = json['description'] as String?
    ..province = json['province'] as int?
    ..nickname = json['nickname'] as String?
    ..djStatus = json['djStatus'] as int?
    ..avatarUrl = json['avatarUrl'] as String?
    ..userName = json['userName'] as String?
    ..userId = json['userId'] as int?
    ..lastLoginTime = json['lastLoginTime'] as int?
    ..authenticationTypes = json['authenticationTypes'] as int?
    ..createTime = json['createTime'] as int?
    ..userType = json['userType'] as int?
    ..avatarDetail = json['avatarDetail'] == null
        ? null
        : MusicArtistUserAvatar.fromJson(
            json['avatarDetail'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicArtistUserToJson(MusicArtistUser instance) =>
    <String, dynamic>{
      'backgroundUrl': instance.backgroundUrl,
      'birthday': instance.birthday,
      'detailDescription': instance.detailDescription,
      'authenticated': instance.authenticated,
      'gender': instance.gender,
      'city': instance.city,
      'description': instance.description,
      'province': instance.province,
      'nickname': instance.nickname,
      'djStatus': instance.djStatus,
      'avatarUrl': instance.avatarUrl,
      'userName': instance.userName,
      'followed': instance.followed,
      'userId': instance.userId,
      'lastLoginTime': instance.lastLoginTime,
      'authenticationTypes': instance.authenticationTypes,
      'createTime': instance.createTime,
      'userType': instance.userType,
      'avatarDetail': instance.avatarDetail,
    };

MusicArtistUserAvatar _$MusicArtistUserAvatarFromJson(
    Map<String, dynamic> json) {
  return MusicArtistUserAvatar()
    ..userType = json['userType'] as int?
    ..identityIconUrl = json['identityIconUrl'] as String?
    ..identityLevel = json['identityLevel'] as int?;
}

Map<String, dynamic> _$MusicArtistUserAvatarToJson(
        MusicArtistUserAvatar instance) =>
    <String, dynamic>{
      'userType': instance.userType,
      'identityIconUrl': instance.identityIconUrl,
      'identityLevel': instance.identityLevel,
    };
