// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_default_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDefaultSearch _$MusicDefaultSearchFromJson(Map<String, dynamic> json) {
  return MusicDefaultSearch()
    ..showKeyword = json['showKeyword'] as String?
    ..realkeyword = json['realkeyword'] as String?
    ..searchType = json['searchType'] as int?
    ..action = json['action'] as int?
    ..alg = json['alg'] as String?
    ..gap = json['gap'] as int?
    ..bizQueryInfo = json['bizQueryInfo'] as String?;
}

Map<String, dynamic> _$MusicDefaultSearchToJson(MusicDefaultSearch instance) =>
    <String, dynamic>{
      'showKeyword': instance.showKeyword,
      'realkeyword': instance.realkeyword,
      'searchType': instance.searchType,
      'action': instance.action,
      'alg': instance.alg,
      'gap': instance.gap,
      'bizQueryInfo': instance.bizQueryInfo,
    };
