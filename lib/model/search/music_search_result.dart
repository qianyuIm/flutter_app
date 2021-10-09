import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/model/music/music_video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_search_result.g.dart';

/// 搜索建议匹配
@JsonSerializable()
class MusicSearchResult {
  /// 单曲 or 歌词
  int? songCount;

  /// 单曲 or 歌词
  List<MusicSong>? songs;

  /// 专辑
  int? albumCount;

  /// 专辑
  List<MusicAlbum>? albums;

  /// 歌手
  int? artistCount;

  /// 歌手
  List<MusicArtist>? artists;

  /// 歌单
  int? playlistCount;

  /// 歌单
  List<MusicPlayList>? playlists;

  /// 用户
  int? userprofileCount;

  /// 用户
  List<MusicUserProfile>? userprofiles;

  /// MV
  int? mvCount;

  /// MV
  List<MusicMV>? mvs;

  /// 电台
  int? djRadiosCount;

  /// 电台
  List<MusicDjRadio>? djRadios;

  /// 视频
  int? videoCount;

  /// 视频
  List<MusicVideo>? videos;

  MusicSearchResult();

  factory MusicSearchResult.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicSearchResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicSearchResultToJson(this);
}
