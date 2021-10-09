import 'package:json_annotation/json_annotation.dart';

part 'music_dj.g.dart';

/// dj 电台
@JsonSerializable()
class MusicDj {
  @JsonKey(defaultValue: 0)
  final int province;
  @JsonKey(defaultValue: false)
  final bool followed;

  String? avatarUrl;
  @JsonKey(defaultValue: 0)
  final int accountStatus;

  @JsonKey(defaultValue: 0)
  final int gender;
  @JsonKey(defaultValue: 0)
  final int city;
  @JsonKey(defaultValue: 0)
  final int birthday;
  @JsonKey(defaultValue: 0)
  final int userId;
  String? nickname;
  String? signature;
  String? backgroundUrl;
  @JsonKey(defaultValue: 0)
  final int djStatus;
  @JsonKey(defaultValue: 0)
  final int vipType;

  MusicDj(this.province, this.followed, this.accountStatus, this.gender,
      this.city, this.birthday, this.userId, this.djStatus, this.vipType);

  factory MusicDj.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjToJson(this);
}
