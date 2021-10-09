
import 'package:json_annotation/json_annotation.dart';

part 'music_privatecontent.g.dart';

/// 独家放送
@JsonSerializable()
class MusicPrivateContent {
  @JsonKey(defaultValue: 0)
  final int id;
  String? url;
  String? picUrl;
  String? sPicUrl;
  @JsonKey(defaultValue: '')
  final String? copywriter;
  @JsonKey(defaultValue: '')
  final String? name;
  @JsonKey(defaultValue: 0)
  final int type;
  String? alg;


  MusicPrivateContent(this.id, this.copywriter, this.name, this.type);

  factory MusicPrivateContent.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPrivateContentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPrivateContentToJson(this);
}