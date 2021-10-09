
import 'package:json_annotation/json_annotation.dart';

import 'music_dj.dart';
import '../music_song.dart';
import 'music_dj_radio.dart';

part 'music_dj_program.g.dart';

@JsonSerializable()
class MusicDjProgram {
  MusicSong? mainSong;
  MusicDj? dj;
  String? blurCoverUrl;
  MusicDjRadio? radio;
  @JsonKey(defaultValue: 0)
  final int subscribedCount;
  @JsonKey(defaultValue: false)
  final bool reward;

  @JsonKey(defaultValue: 0)
  final int mainTrackId;
  @JsonKey(defaultValue: 0)
  final int serialNum;
  @JsonKey(defaultValue: 0)
  final int listenerCount;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: 0)
  final int id;
  int? createTime;
  String? description;
  int? userId;
  String? coverUrl;
  String? commentThreadId;
  int? pubStatus;
  int? trackCount;
  int? bdAuditStatus;
  int? programFeeType;
  @JsonKey(defaultValue: false)
  final bool buyed;

  int? adjustedPlayCount;
  int? auditStatus;
  int? duration;
  int? shareCount;
  @JsonKey(defaultValue: false)
  final bool subscribed;
  @JsonKey(defaultValue: 0)
  final int likedCount;
  @JsonKey(defaultValue: false)
  final bool isPublish;
  @JsonKey(defaultValue: 0)
  final int commentCount;

  MusicDjProgram(
      this.subscribedCount,
      this.reward,
      this.mainTrackId,
      this.serialNum,
      this.listenerCount,
      this.name,
      this.id,
      this.buyed,
      this.subscribed,
      this.likedCount,
      this.isPublish,
      this.commentCount);

  factory MusicDjProgram.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjProgramFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjProgramToJson(this);
}
