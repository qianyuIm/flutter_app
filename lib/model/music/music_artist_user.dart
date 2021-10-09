import 'package:json_annotation/json_annotation.dart';

part 'music_artist_user.g.dart';

/// 歌手
@JsonSerializable()
class MusicArtistUser {
  String? backgroundUrl;
  int? birthday;
  String? detailDescription;
  @JsonKey(defaultValue: false)
  final bool authenticated;
  /// 1 男
  @JsonKey(defaultValue: 1)
  final int gender;
  int? city;
  String? description;
  int? province;
  String? nickname;
  int? djStatus;
  String? avatarUrl;
  String? userName;
  @JsonKey(defaultValue: false)
  final bool followed;
  int? userId;
  int? lastLoginTime;
  int? authenticationTypes;
  int? createTime;
  int? userType;
  MusicArtistUserAvatar? avatarDetail;

  MusicArtistUser(this.authenticated, this.gender, this.followed);

  factory MusicArtistUser.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicArtistUserFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicArtistUserToJson(this);
}

/// 歌手
@JsonSerializable()
class MusicArtistUserAvatar {
  int? userType;
  String? identityIconUrl;
  int? identityLevel;
  MusicArtistUserAvatar();

  factory MusicArtistUserAvatar.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicArtistUserAvatarFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicArtistUserAvatarToJson(this);
}