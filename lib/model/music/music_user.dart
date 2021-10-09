import 'package:flutter/material.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_artist_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_user.g.dart';


enum MusicUserGender {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  male,
  @JsonValue(2)
  female
}
extension MusicUserGenderGetImage on MusicUserGender {
  Widget get image {
    if (this == MusicUserGender.male) {
      return Image.asset(
                      ImageHelper.wrapMusicPng('music_user_gender_male'),width: 12,);
    } else if (this == MusicUserGender.female) {
      return Image.asset(
                      ImageHelper.wrapMusicPng('music_user_gender_female'),width: 12,);
    }
    return SizedBox.shrink();
  }
}

@JsonSerializable()
class MusicUser {
  int  code;
  int? loginType;
  MusicUserAccount? account;
  String? token;
  MusicUserProfile? profile;
  List<MusicUserBinding>? bindings;
  String? cookie;
  String? message;

  MusicUser({int? code}) : this.code = code ?? 0;

  factory MusicUser.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserToJson(this);
}

@JsonSerializable()
class MusicUserDetail {
  @JsonKey(defaultValue: 0)
   final int  code;

  @JsonKey(defaultValue: 0)
  final int level;

@JsonKey(defaultValue: 0)
  final int listenSongs;
    MusicUserPoint? userPoint;
    @JsonKey(defaultValue: false)
    final bool mobileSign;
    @JsonKey(defaultValue: false)
    final bool pcSign;
    @JsonKey(defaultValue: false)
    final bool peopleCanSeeMyPlayRecord;
    
MusicUserProfile? profile;
List<MusicUserBinding>? bindings;

@JsonKey(defaultValue: 0)
final int createDays;
int? createTime;


  MusicUserDetail(this.level, this.listenSongs, this.mobileSign, this.pcSign, this.peopleCanSeeMyPlayRecord, this.createDays, this.code);

  factory MusicUserDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserDetailToJson(this);
}

@JsonSerializable()
class MusicUserPoint {
  int? userId;
  int? balance;
  int? updateTime;
  int? version;
  int? status;
  int? blockBalance;

  MusicUserPoint();

  factory MusicUserPoint.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserPointFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserPointToJson(this);
}


@JsonSerializable()
class MusicUserAccount {
  int id;
  String? userName;
  int? type;
  int? status;
  int? whitelistAuthority;
  int? createTime;
  String? salt;
  int? tokenVersion;
  int? ban;
  int? baoyueVersion;
  int? donateVersion;
  int? vipType;
  int? viptypeVersion;
  bool? anonimousUser;
  MusicUserAccount({int? id}) : this.id = id ?? 0;

  factory MusicUserAccount.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserAccountFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserAccountToJson(this);
}

@JsonSerializable()
class MusicUserProfile {
  @JsonKey(defaultValue: false)
  final bool followed;
  String? backgroundUrl;
  int? userId;
  String? nickname;
  String? description;
  @JsonKey(defaultValue: '')
  final String signature;
  /// 1 男 2 女  0 未知
  @JsonKey(defaultValue: MusicUserGender.unknown)
  final MusicUserGender gender;
  
  /// -2209017600000,
  int? birthday;
  int? city;
  String? avatarUrl;
  int? followeds;
  int? follows;
  int? playlistCount;
  int? playlistBeSubscribedCount;
  MusicArtistUserAvatar? avatarDetail;


  MusicUserProfile(this.followed, this.gender, this.signature);

  factory MusicUserProfile.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserProfileFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserProfileToJson(this);
}

@JsonSerializable()
class MusicUserBinding {
  int? refreshTime;
  String? url;
  int? userId;
  String? tokenJsonStr;
  int? bindingTime;
  int? expiresIn;
  bool? expired;
  int? id;
  int? type;
  MusicUserBinding();

  factory MusicUserBinding.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserBindingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserBindingToJson(this);
}
