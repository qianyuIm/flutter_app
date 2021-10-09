import 'package:json_annotation/json_annotation.dart';
import 'music_dj.dart';

part 'music_dj_radio.g.dart';

/// dj 电台
@JsonSerializable()
class MusicDjRadio {
  @JsonKey(defaultValue: 0)
  final int id;
  MusicDj? dj;
  String? name;
  String? rcmdText;
  String? lastProgramName;
  String? picUrl;
  String? desc;
  @JsonKey(defaultValue: 0)
  final int subCount;
  @JsonKey(defaultValue: 0)
  final int programCount;
  @JsonKey(defaultValue: 0)
  final int createTime;
  @JsonKey(defaultValue: 0)
  final int categoryId;
  String? category;

  @JsonKey(defaultValue: 0)
  final int radioFeeType;

  @JsonKey(defaultValue: 0)
  final int playCount;

  @JsonKey(defaultValue: 0)
  final int shareCount;

  @JsonKey(defaultValue: 0)
  final int likedCount;

  @JsonKey(defaultValue: 0)
  final int commentCount;

  MusicDjRadio(
      this.id,
      this.subCount,
      this.programCount,
      this.createTime,
      this.categoryId,
      this.radioFeeType,
      this.playCount,
      this.shareCount,
      this.likedCount,
      this.commentCount);

  factory MusicDjRadio.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjRadioFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjRadioToJson(this);
}
