import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_per_new_song.g.dart';
/// 首页 -> 推荐新音乐
@JsonSerializable()
class MusicPerNewSong {
  int id;
  int? type;
  String? name;
  String? picUrl;
  bool canDislike;
  MusicSong? song;
  String? alg;

  MusicPerNewSong({int? id, bool? canDislike}) : this.id = id ?? 0, this.canDislike = canDislike ?? false;

  factory MusicPerNewSong.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPerNewSongFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPerNewSongToJson(this);

  // static MusicSong1? _songFromJson(Object json) {
  //   if (json is Map<String,dynamic>) {
  //     return MusicSong1.fromJson(json);
  //   }
  //   return null;
  // }
  // static MusicSong1? _songToJson(MusicSong1? song) {
  //   return song;
  // }
}
