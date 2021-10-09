import 'package:json_annotation/json_annotation.dart';
import 'music_dj_program.dart';
part 'music_dj_personalized.g.dart';

@JsonSerializable()
class MusicDjPersonalized {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 0)
  final int type;
  String? name;
  String? copywriter;
  String? picUrl;
  @JsonKey(defaultValue: false)
  final bool canDislike;
  MusicDjProgram? program;
  String? alg;

  MusicDjPersonalized(this.id, this.type, this.canDislike);

  factory MusicDjPersonalized.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjPersonalizedFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjPersonalizedToJson(this);
}
