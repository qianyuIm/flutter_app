// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_hot_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicHotSearch _$MusicHotSearchFromJson(Map<String, dynamic> json) {
  return MusicHotSearch()
    ..searchWord = json['searchWord'] as String?
    ..score = json['score'] as int?
    ..content = json['content'] as String?
    ..source = json['source'] as int?
    ..iconType = json['iconType'] as int?
    ..iconUrl = json['iconUrl'] as String?
    ..url = json['url'] as String?
    ..alg = json['alg'] as String?;
}

Map<String, dynamic> _$MusicHotSearchToJson(MusicHotSearch instance) =>
    <String, dynamic>{
      'searchWord': instance.searchWord,
      'score': instance.score,
      'content': instance.content,
      'source': instance.source,
      'iconType': instance.iconType,
      'iconUrl': instance.iconUrl,
      'url': instance.url,
      'alg': instance.alg,
    };
