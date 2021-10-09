import 'package:json_annotation/json_annotation.dart';

part 'music_dj_banner.g.dart';

/// dj 电台 banner
@JsonSerializable()
class MusicDjBanner {
  @JsonKey(defaultValue: 0)
  final int targetId;
  @JsonKey(defaultValue: 0)
  final int targetType;
  @JsonKey(defaultValue: '')
  final String pic;
  @JsonKey(defaultValue: '')
  final String url;
  @JsonKey(defaultValue: '')
  final String typeTitle;
  @JsonKey(defaultValue: false)
  final bool exclusive;

  MusicDjBanner(this.targetId, this.targetType, this.pic, this.url, this.typeTitle, this.exclusive);

  factory MusicDjBanner.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjBannerFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjBannerToJson(this);
}
