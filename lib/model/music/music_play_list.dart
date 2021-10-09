import 'package:flutter_app/model/music/music_creator.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_track_id.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' as convert;

part 'music_play_list.g.dart';

/// 歌单列表
/// -> 'playlist'
@JsonSerializable()
class MusicPlayList {
  @JsonKey(defaultValue: 0)
  final int id;
  String? name;
  String? coverImgUrl;
  String? description;
  int? playCount;
  @JsonKey(defaultValue: 0)
  final int trackCount;
  int? createTime;
  int? userId;
  bool? subscribed;
  int? subscribedCount;
  int? commentCount;
  int? shareCount;
  @JsonKey(name: 'tracks')
  List<MusicSong>? songs;

  MusicCreator? creator;

  List<MusicTrackId>? trackIds;

  /// 手动赋值
  List<MusicSong>? trackSongs;
  /// 收藏歌单的人
  List<MusicUserProfile>? subscribers;

  /// 是否为精品歌单
  @JsonKey(defaultValue: false)
  final bool highQuality;

  /// 是否为隐私歌单 10 为 0 不为
  @JsonKey(defaultValue: 0)
  final int privacy;

  MusicPlayList(this.id, this.trackCount, this.highQuality, this.privacy);

  /// 是否为隐私歌单
  bool get isPrivacy => privacy == 10;

  factory MusicPlayList.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPlayListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPlayListToJson(this);

  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playlist_id'] = this.id;
    data['trackCount'] = this.trackCount;

    data['highQuality'] = this.highQuality ? 1 : 0;
    data['privacy'] = this.privacy;
    data['name'] = this.name;
    data['coverImgUrl'] = this.coverImgUrl;
    data['creator'] = convert.jsonEncode(this.creator);
    return data;
  }

  factory MusicPlayList.fromDBMap(Map json) {
    return MusicPlayList(json['playlist_id'], json['trackCount'],
        json['highQuality'] == 1, json['privacy'])
      ..name = json['name'] as String?
      ..coverImgUrl = json['coverImgUrl'] as String?
      ..creator = json['creator'] == 'null'
          ? null
          : MusicCreator.fromJson(
              convert.jsonDecode(json['creator']) as Map<String, dynamic>);
  }
}
