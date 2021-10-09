import 'package:json_annotation/json_annotation.dart';

part 'music_search_suggest_match.g.dart';

/// 搜索建议匹配
@JsonSerializable()
class MusicSearchSuggestMatch {
  @JsonKey(defaultValue: '')
  final String keyword;
   int? type;
   String? alg;
   String? lastKeyword;
  
   String? feature;
  @JsonKey(name: 'qy_isEmpty',defaultValue: false)
  final bool isEmpty;

  MusicSearchSuggestMatch(
      this.keyword, this.isEmpty);

  factory MusicSearchSuggestMatch.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicSearchSuggestMatchFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicSearchSuggestMatchToJson(this);


}
