import 'package:json_annotation/json_annotation.dart';

part 'music_playlist_categorie.g.dart';

@JsonSerializable()
class MusicPlaylistCategorieContainer {
  MusicPlaylistCategorie? all;
  List<MusicPlaylistCategorie>? sub;
  Map<String, dynamic>? categories;

  MusicPlaylistCategorieContainer();
  factory MusicPlaylistCategorieContainer.fromJson(
          Map<String, dynamic> srcJson) =>
      _$MusicPlaylistCategorieContainerFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$MusicPlaylistCategorieContainerToJson(this);
}

@JsonSerializable()
class MusicPlaylistCategorie {
  @JsonKey(defaultValue: '')
  final String name;
  int? resourceCount;
  @JsonKey(defaultValue: 0)
  final int type;
  @JsonKey(defaultValue: 0)
  final int category;
  @JsonKey(defaultValue: 0)
  final int resourceType;
  @JsonKey(defaultValue: false)
  final bool hot;

  @JsonKey(defaultValue: false)
  final bool activity;

  MusicPlaylistCategorie(this.name, this.type, this.category, this.resourceType,
      this.hot, this.activity);
  factory MusicPlaylistCategorie.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPlaylistCategorieFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPlaylistCategorieToJson(this);
}
