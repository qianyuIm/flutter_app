// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicUser _$MusicUserFromJson(Map<String, dynamic> json) {
  return MusicUser(
    code: json['code'] as int?,
  )
    ..loginType = json['loginType'] as int?
    ..account = json['account'] == null
        ? null
        : MusicUserAccount.fromJson(json['account'] as Map<String, dynamic>)
    ..token = json['token'] as String?
    ..profile = json['profile'] == null
        ? null
        : MusicUserProfile.fromJson(json['profile'] as Map<String, dynamic>)
    ..bindings = (json['bindings'] as List<dynamic>?)
        ?.map((e) => MusicUserBinding.fromJson(e as Map<String, dynamic>))
        .toList()
    ..cookie = json['cookie'] as String?
    ..message = json['message'] as String?;
}

Map<String, dynamic> _$MusicUserToJson(MusicUser instance) => <String, dynamic>{
      'code': instance.code,
      'loginType': instance.loginType,
      'account': instance.account,
      'token': instance.token,
      'profile': instance.profile,
      'bindings': instance.bindings,
      'cookie': instance.cookie,
      'message': instance.message,
    };

MusicUserDetail _$MusicUserDetailFromJson(Map<String, dynamic> json) {
  return MusicUserDetail(
    json['level'] as int? ?? 0,
    json['listenSongs'] as int? ?? 0,
    json['mobileSign'] as bool? ?? false,
    json['pcSign'] as bool? ?? false,
    json['peopleCanSeeMyPlayRecord'] as bool? ?? false,
    json['createDays'] as int? ?? 0,
    json['code'] as int? ?? 0,
  )
    ..userPoint = json['userPoint'] == null
        ? null
        : MusicUserPoint.fromJson(json['userPoint'] as Map<String, dynamic>)
    ..profile = json['profile'] == null
        ? null
        : MusicUserProfile.fromJson(json['profile'] as Map<String, dynamic>)
    ..bindings = (json['bindings'] as List<dynamic>?)
        ?.map((e) => MusicUserBinding.fromJson(e as Map<String, dynamic>))
        .toList()
    ..createTime = json['createTime'] as int?;
}

Map<String, dynamic> _$MusicUserDetailToJson(MusicUserDetail instance) =>
    <String, dynamic>{
      'code': instance.code,
      'level': instance.level,
      'listenSongs': instance.listenSongs,
      'userPoint': instance.userPoint,
      'mobileSign': instance.mobileSign,
      'pcSign': instance.pcSign,
      'peopleCanSeeMyPlayRecord': instance.peopleCanSeeMyPlayRecord,
      'profile': instance.profile,
      'bindings': instance.bindings,
      'createDays': instance.createDays,
      'createTime': instance.createTime,
    };

MusicUserPoint _$MusicUserPointFromJson(Map<String, dynamic> json) {
  return MusicUserPoint()
    ..userId = json['userId'] as int?
    ..balance = json['balance'] as int?
    ..updateTime = json['updateTime'] as int?
    ..version = json['version'] as int?
    ..status = json['status'] as int?
    ..blockBalance = json['blockBalance'] as int?;
}

Map<String, dynamic> _$MusicUserPointToJson(MusicUserPoint instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'balance': instance.balance,
      'updateTime': instance.updateTime,
      'version': instance.version,
      'status': instance.status,
      'blockBalance': instance.blockBalance,
    };

MusicUserAccount _$MusicUserAccountFromJson(Map<String, dynamic> json) {
  return MusicUserAccount(
    id: json['id'] as int?,
  )
    ..userName = json['userName'] as String?
    ..type = json['type'] as int?
    ..status = json['status'] as int?
    ..whitelistAuthority = json['whitelistAuthority'] as int?
    ..createTime = json['createTime'] as int?
    ..salt = json['salt'] as String?
    ..tokenVersion = json['tokenVersion'] as int?
    ..ban = json['ban'] as int?
    ..baoyueVersion = json['baoyueVersion'] as int?
    ..donateVersion = json['donateVersion'] as int?
    ..vipType = json['vipType'] as int?
    ..viptypeVersion = json['viptypeVersion'] as int?
    ..anonimousUser = json['anonimousUser'] as bool?;
}

Map<String, dynamic> _$MusicUserAccountToJson(MusicUserAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'type': instance.type,
      'status': instance.status,
      'whitelistAuthority': instance.whitelistAuthority,
      'createTime': instance.createTime,
      'salt': instance.salt,
      'tokenVersion': instance.tokenVersion,
      'ban': instance.ban,
      'baoyueVersion': instance.baoyueVersion,
      'donateVersion': instance.donateVersion,
      'vipType': instance.vipType,
      'viptypeVersion': instance.viptypeVersion,
      'anonimousUser': instance.anonimousUser,
    };

MusicUserProfile _$MusicUserProfileFromJson(Map<String, dynamic> json) {
  return MusicUserProfile(
    json['followed'] as bool? ?? false,
    _$enumDecodeNullable(_$MusicUserGenderEnumMap, json['gender']) ??
        MusicUserGender.unknown,
    json['signature'] as String? ?? '',
  )
    ..backgroundUrl = json['backgroundUrl'] as String?
    ..userId = json['userId'] as int?
    ..nickname = json['nickname'] as String?
    ..description = json['description'] as String?
    ..birthday = json['birthday'] as int?
    ..city = json['city'] as int?
    ..avatarUrl = json['avatarUrl'] as String?
    ..followeds = json['followeds'] as int?
    ..follows = json['follows'] as int?
    ..playlistCount = json['playlistCount'] as int?
    ..playlistBeSubscribedCount = json['playlistBeSubscribedCount'] as int?
    ..avatarDetail = json['avatarDetail'] == null
        ? null
        : MusicArtistUserAvatar.fromJson(
            json['avatarDetail'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicUserProfileToJson(MusicUserProfile instance) =>
    <String, dynamic>{
      'followed': instance.followed,
      'backgroundUrl': instance.backgroundUrl,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'description': instance.description,
      'signature': instance.signature,
      'gender': _$MusicUserGenderEnumMap[instance.gender],
      'birthday': instance.birthday,
      'city': instance.city,
      'avatarUrl': instance.avatarUrl,
      'followeds': instance.followeds,
      'follows': instance.follows,
      'playlistCount': instance.playlistCount,
      'playlistBeSubscribedCount': instance.playlistBeSubscribedCount,
      'avatarDetail': instance.avatarDetail,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MusicUserGenderEnumMap = {
  MusicUserGender.unknown: 0,
  MusicUserGender.male: 1,
  MusicUserGender.female: 2,
};

MusicUserBinding _$MusicUserBindingFromJson(Map<String, dynamic> json) {
  return MusicUserBinding()
    ..refreshTime = json['refreshTime'] as int?
    ..url = json['url'] as String?
    ..userId = json['userId'] as int?
    ..tokenJsonStr = json['tokenJsonStr'] as String?
    ..bindingTime = json['bindingTime'] as int?
    ..expiresIn = json['expiresIn'] as int?
    ..expired = json['expired'] as bool?
    ..id = json['id'] as int?
    ..type = json['type'] as int?;
}

Map<String, dynamic> _$MusicUserBindingToJson(MusicUserBinding instance) =>
    <String, dynamic>{
      'refreshTime': instance.refreshTime,
      'url': instance.url,
      'userId': instance.userId,
      'tokenJsonStr': instance.tokenJsonStr,
      'bindingTime': instance.bindingTime,
      'expiresIn': instance.expiresIn,
      'expired': instance.expired,
      'id': instance.id,
      'type': instance.type,
    };
