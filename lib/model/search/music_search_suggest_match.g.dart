// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_search_suggest_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicSearchSuggestMatch _$MusicSearchSuggestMatchFromJson(
    Map<String, dynamic> json) {
  return MusicSearchSuggestMatch(
    json['keyword'] as String? ?? '',
    json['qy_isEmpty'] as bool? ?? false,
  )
    ..type = json['type'] as int?
    ..alg = json['alg'] as String?
    ..lastKeyword = json['lastKeyword'] as String?
    ..feature = json['feature'] as String?;
}

Map<String, dynamic> _$MusicSearchSuggestMatchToJson(
        MusicSearchSuggestMatch instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'type': instance.type,
      'alg': instance.alg,
      'lastKeyword': instance.lastKeyword,
      'feature': instance.feature,
      'qy_isEmpty': instance.isEmpty,
    };
