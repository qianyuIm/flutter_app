import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'internal_mv.g.dart';

/// mv列表
@JsonSerializable()
class InternalMv {
  @JsonKey(defaultValue: 0)
  final int id;
  String? cover;
  String? name;
  @JsonKey(defaultValue: 0)
  final int playCount;
  @JsonKey(defaultValue: '')
  final String artistName;
  int? artistId;
  int? duration;
  List<MusicArtist>? artists;

  /// 手动字段
  MusicMVUrl? mvUrl;

  /// 手动字段
  InternalMvDetail? detail;

  InternalMv(this.id, this.playCount, this.artistName);

  factory InternalMv.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalMvFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalMvToJson(this);
}

/// mv详情
@JsonSerializable()
class InternalMvDetail {
  @JsonKey(defaultValue: false)
  final bool subed;

  /// 是否收藏
  /// 手动字段
  InternalMvDetailInfo? info;
  InternalMvDetailData? data;

  InternalMvDetail(this.subed);

  factory InternalMvDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalMvDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalMvDetailToJson(this);
}

/// mv详情
@JsonSerializable()
class InternalMvDetailData {
  @JsonKey(defaultValue: 0)
  final int id;
  String? name;
  @JsonKey(defaultValue: 0)
  final int artistId;
  String? artistName;
  String? desc;

  String? cover;
  @JsonKey(defaultValue: 0)
  final int playCount;
  @JsonKey(defaultValue: 0)
  final int subCount;

  @JsonKey(defaultValue: 0)
  final int shareCount;

  @JsonKey(defaultValue: 0)
  final int commentCount;

  String? publishTime;

  List<MusicSongQuality>? brs;
  List<MusicArtist>? artists;

  InternalMvDetailData(this.id, this.artistId, this.playCount, this.subCount,
      this.shareCount, this.commentCount);

  factory InternalMvDetailData.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalMvDetailDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalMvDetailDataToJson(this);
}

/// mv详情
@JsonSerializable()
class InternalMvDetailInfo {
  @JsonKey(defaultValue: false)
  final bool liked;

  /// 是否喜欢
  @JsonKey(defaultValue: 0)
  final int likedCount;
  @JsonKey(defaultValue: 0)
  final int shareCount;
  @JsonKey(defaultValue: 0)
  final int commentCount;

  InternalMvDetailInfo(
      this.liked, this.likedCount, this.shareCount, this.commentCount);

  factory InternalMvDetailInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalMvDetailInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalMvDetailInfoToJson(this);
}
