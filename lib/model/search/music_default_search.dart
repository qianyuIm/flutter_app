import 'package:json_annotation/json_annotation.dart';

part 'music_default_search.g.dart';

/// 视频评论容器
@JsonSerializable()
class MusicDefaultSearch {
  String? showKeyword;
  String? realkeyword;
  int? searchType;
  int? action;
  String? alg;
  int? gap;
  String? bizQueryInfo;


  
  MusicDefaultSearch();

  factory MusicDefaultSearch.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicDefaultSearchFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicDefaultSearchToJson(this);
}