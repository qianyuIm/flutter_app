import 'package:flutter_app/helper/optional_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_artist.g.dart';

/// 推荐歌单公用模型
@JsonSerializable()
class MusicArtist {
  String? name;
  @JsonKey(defaultValue: 0)
  final int id;
  String? picUrl;
  String? img1v1Url;
  String? first;
  String? second;
  int? third;
  /// 别名
  List<String>? alias;
  @JsonKey(defaultValue: 0)
  final int score;
  @JsonKey(defaultValue: 0)
  final int lastRank;
  @JsonKey(defaultValue: 0)
  final int topicPerson;
  String? briefDesc;
  MusicRank? rank;
  List<String>? identities;
  List<String>? identifyTag;
  @JsonKey(defaultValue: 0)
  final int albumSize;
  @JsonKey(defaultValue: 0)
  final int musicSize;
  @JsonKey(defaultValue: 0)
  final int mvSize;
  String? cover;
  @JsonKey(defaultValue: false)
  final bool followed;
  int? fansCount;

  String fullName() {
    if (ListOptionalHelper.hasValue(alias)) {
      return '$name (${alias!.first})';
    }
    return name ?? '';
  }

  MusicArtist(this.id, this.score, this.lastRank, this.topicPerson, this.albumSize, this.musicSize, this.mvSize, this.followed);
  factory MusicArtist.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicArtistFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicArtistToJson(this);
}

@JsonSerializable()
class MusicRank {
  @JsonKey(defaultValue: 0)
  final int rank;
  @JsonKey(defaultValue: 0)
  final int type;

  MusicRank(this.rank, this.type);
  factory MusicRank.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicRankFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicRankToJson(this);
}
