import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_play_list_container.g.dart';
/// 分类歌单
@JsonSerializable()
class MusicPlaylistContainer {
  List<MusicPlayList>? playlists;
  @JsonKey(defaultValue: 0)
  final int total;
  @JsonKey(defaultValue: false)
  final bool more;
  String? cat;
  
  

  MusicPlaylistContainer(this.total, this.more);
  factory MusicPlaylistContainer.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MusicPlaylistContainerFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$MusicPlaylistContainerToJson(this);
}
