import 'package:json_annotation/json_annotation.dart';

part 'music_mlog_video.g.dart';

@JsonSerializable()
class MusicMlogVideo {
  String? videoKey;
  @JsonKey(defaultValue: 0)
  final int duration;
  String? coverUrl;
  String? frameUrl;
  @JsonKey(defaultValue: 1)
  final int width;
  @JsonKey(defaultValue: 1)
  final int height;
  MusicMlogVideoUrlInfo? urlInfo;

  MusicMlogVideo(this.duration, this.width, this.height);

  factory MusicMlogVideo.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogVideoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogVideoToJson(this);
}

@JsonSerializable()
class MusicMlogVideoUrlInfo {
  String? id;
  String? url;
  @JsonKey(defaultValue: 0)
  final int size;
  int? r;
  int? validityTime;

  MusicMlogVideoUrlInfo(this.size);

  factory MusicMlogVideoUrlInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogVideoUrlInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogVideoUrlInfoToJson(this);
}
