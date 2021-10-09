import 'package:flutter_app/model/music/music_artist_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_video.g.dart';
/// 用于一些其video地方
@JsonSerializable()
class MusicVideo {
  @JsonKey(defaultValue: '')
  final String vid;
  String? coverUrl;
  @JsonKey(defaultValue: 0)
  final int duration;
  @JsonKey(defaultValue: 0)
  final int playTime;
  @JsonKey(defaultValue: 1)
  final int height;
  @JsonKey(defaultValue: 1)
  final int width;
  
  List<MusicArtistUser>? creator;
  @JsonKey(defaultValue: 0)
  final int size;
  int? state;
  int? coverType;
  String? videoId;
  String? title;
  int? videoStatus;
  @JsonKey(defaultValue: 0)
  final int durationms;

  MusicVideo(this.vid, this.duration, this.playTime, this.height, this.width,
      this.size, this.durationms);

  factory MusicVideo.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicVideoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicVideoToJson(this);
}
