
// import 'package:flutter_app/model/music/music_song1.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_mv.g.dart';
/// 首页 -> 推荐MV
@JsonSerializable()
class MusicMV {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 0)
  final int type;
  String? name;
  String? copywriter;
  String? picUrl;
  String? cover;
  @JsonKey(defaultValue: false)
  final bool canDislike;
  @JsonKey(defaultValue: 0)
  final int duration;
  @JsonKey(defaultValue: 0)
  final int playCount;
  List<MusicArtist>? artists;
  String? artistName;
  int? artistId;
  String? alg;
  String? imgurl;
  String? imgurl16v9;
  @JsonKey(defaultValue: 1)
  final int height;
  @JsonKey(defaultValue: 1)
  final int width;

  
  MusicMV(this.id, this.type, this.canDislike, this.playCount, this.height, this.width, this.duration);

  factory MusicMV.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMVFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMVToJson(this);
}

/// mv播放地址
@JsonSerializable()
class MusicMVUrl {
  @JsonKey(defaultValue: 0)
  final int id;
  
  String? url;
  /// 分辨率
  int? r;
  int? size;
  /// 过期时间  秒数
  int? expi;
  
  MusicMVUrl(this.id);

  factory MusicMVUrl.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMVUrlFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMVUrlToJson(this);
}
