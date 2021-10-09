import 'package:flutter_app/model/music/music_creator.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_personalized.g.dart';

/// 推荐歌单公用模型
@JsonSerializable()
class MusicPersonalized {
  int id;
  int? type;
  String? name;
  String? copywriter;
  String? picUrl;
  bool? canDislike;
  String? alg;
  int? userId;
  int? playcount;
  int? createTime;
  MusicCreator? creator;
  MusicSong? song;
  
  MusicPersonalized({
    int? id
  }):this.id = id ?? 0;

  factory MusicPersonalized.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPersonalizedFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPersonalizedToJson(this);
}
