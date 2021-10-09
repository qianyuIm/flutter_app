import 'package:json_annotation/json_annotation.dart';

part 'music_banner.g.dart';

@JsonSerializable()
class MusicBanner {
  int? targetId;
  String? pic;
  String? typeTitle;
  String? titleColor;
  String? url;
  String? encodeId;
  String? bannerId;
  String? scm;
  MusicBanner();

  factory MusicBanner.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicBannerFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicBannerToJson(this);
}
