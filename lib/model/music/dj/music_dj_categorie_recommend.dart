import 'package:flutter_app/model/music/dj/music_dj_radio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_dj_categorie_recommend.g.dart';

/// dj 电台 推荐类型
@JsonSerializable()
class MusicDJCategorieRecommend {
  @JsonKey(defaultValue: '')
  final String categoryName;
  @JsonKey(defaultValue: 0)
  final int categoryId;
  List<MusicDjRadio>? radios;

  MusicDJCategorieRecommend(this.categoryName, this.categoryId);

  factory MusicDJCategorieRecommend.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDJCategorieRecommendFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDJCategorieRecommendToJson(this);
}
