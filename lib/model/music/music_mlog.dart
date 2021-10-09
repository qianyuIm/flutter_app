
import 'package:flutter_app/model/music/music_mlog_video.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_mlog.g.dart';

@JsonSerializable()
class MusicMlogBase {
  String? id;
  int? type;
  String? text;
  String? coverUrl;
  @JsonKey(defaultValue: 1)
  final int coverHeight;
  @JsonKey(defaultValue: 1)
  final int coverWidth;
  MusicMlogBase(this.coverHeight, this.coverWidth);

  factory MusicMlogBase.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogBaseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogBaseToJson(this);
}

@JsonSerializable()
class MusicMlogExt {
  int? commentCount;
  int? likedCount;
  int? shareCount;

  MusicMlogExt();

  factory MusicMlogExt.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogExtFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogExtToJson(this);
}

@JsonSerializable()
class MusicMlogDetail {
  String? id;
  int? userId;
  int? type;
  MusicMlogContent? content;
  int? pubTime;
  int? status;
  String? shareUrl;
  
  int? playCount;
  String? threadId;

  MusicMlogDetail();

  factory MusicMlogDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogDetailToJson(this);
}

@JsonSerializable()
class MusicMlogContent {
  String? text;
  String? interveneText;
  int? coverColor;
  MusicMlogVideo? video;
  List<MusicSong>? songs;


  MusicMlogContent();

  factory MusicMlogContent.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMlogContentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMlogContentToJson(this);
}