import 'package:json_annotation/json_annotation.dart';

part 'music_dj_categorie.g.dart';

/// dj 电台 分类
@JsonSerializable()
class MusicDjCategorie {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: 0)
  final int id;
  String? pic96x96Url;
  /// 手动字段 是否为排行榜
  @JsonKey(defaultValue: false)
  final bool isRank;
  /// 手动字段 是否为我的广播
  @JsonKey(defaultValue: false)
  final bool isMyDj;
  

  MusicDjCategorie(this.name, this.id, this.isRank, this.isMyDj);

  factory MusicDjCategorie.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDjCategorieFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDjCategorieToJson(this);
}
