import 'package:flutter_app/model/music/dj/music_dj_program.dart';
import 'package:flutter_app/model/music/music_artist_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_dj_rank.g.dart';

/// dj 电台 banner
@JsonSerializable()
class MusicDjRank {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 0)
  final int rank;
  @JsonKey(defaultValue: 0)
  final int lastRank;
  @JsonKey(defaultValue: 0)
  final int score;
  String? nickName;
  String? avatarUrl;
  
  int? userType;
  int? userFollowedCount;
  MusicArtistUserAvatar? avatarDetail;
  @JsonKey(defaultValue: 0)
  final int programFeeType;
  MusicDjProgram? program;

  /// 用于新晋\最热电台榜
  String? picUrl;
  String? creatorName;
    String? name;
    int? playCount;
    



  

  MusicDjRank(this.rank, this.lastRank, this.score, this.programFeeType, this.id);

  factory MusicDjRank.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjRankFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjRankToJson(this);
}
