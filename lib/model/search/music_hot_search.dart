import 'package:json_annotation/json_annotation.dart';

part 'music_hot_search.g.dart';

/// 视频评论容器
@JsonSerializable()
class MusicHotSearch {
  String? searchWord;
  int? score;
  String? content;
  int? source;
  int? iconType;
  String? iconUrl;
  String? url;
  String? alg;


  
  MusicHotSearch();

  factory MusicHotSearch.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicHotSearchFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicHotSearchToJson(this);


  String hotTag() {
    return iconUrl == null ? '' : iconUrl!;
  }
  String searchWordAdapter() {
    if ((searchWord?.length ?? 0) < 7) {
      return searchWord ?? '';
    }
    return searchWord!.substring(0,6) + '...';
  }
}