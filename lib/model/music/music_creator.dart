import 'package:json_annotation/json_annotation.dart';

part 'music_creator.g.dart';

@JsonSerializable()
class MusicCreator {
  String? backgroundUrl;
  String? avatarImgIdStr;
  int? avatarImgId;
  int? backgroundImgId;
  String? backgroundImgIdStr;
  int? userId;
  int? province;
  String? avatarUrl;
  String? nickname;
  int? gender;
  int? birthday;
  int? city;
  MusicCreator();

  factory MusicCreator.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicCreatorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicCreatorToJson(this);
}
