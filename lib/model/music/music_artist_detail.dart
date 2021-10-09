import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_artist_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_artist_detail.g.dart';

/// 歌手详情
@JsonSerializable()
class MusicArtistDetail {
  @JsonKey(defaultValue: 0)
  final int videoCount;
  @JsonKey(defaultValue: false)
  final bool blacklist;
  @JsonKey(defaultValue: false)
  final bool showPriMsg;
  MusicArtist? artist;
  int? eventCount;
  MusicIdentify? identify;
  MusicArtistUser? user;

  MusicArtistDetail(this.videoCount, this.blacklist, this.showPriMsg);

  factory MusicArtistDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicArtistDetailFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicArtistDetailToJson(this);
}

@JsonSerializable()
class MusicIdentify {
  String? imageUrl;
  String? imageDesc;
  String? actionUrl;

  MusicIdentify();

  factory MusicIdentify.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicIdentifyFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicIdentifyToJson(this);
}