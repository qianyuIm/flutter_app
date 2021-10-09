import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_album.g.dart';

/// 推荐歌单公用模型
@JsonSerializable()
class MusicAlbum {
  String? type;
  String? picUrl;
  @JsonKey(defaultValue: 0)
  final int companyId;
  String? name;
  int? publishTime;
  @JsonKey(defaultValue: 0)
  final int id;
  String? company;

  List<MusicSong>? songs;
  @JsonKey(defaultValue: false)
  final bool paid;
  @JsonKey(defaultValue: false)
  final bool onSale;
  String? blurPicUrl;
  int? copyrightId;
  List<MusicArtist>? artists;
  MusicArtist? artist;
  String? subType;
  @JsonKey(defaultValue: 0)
  final int size;



  MusicAlbum(this.id,this.companyId, this.paid, this.onSale, this.size);

  factory MusicAlbum.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicAlbumFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicAlbumToJson(this);
}
