// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoCategory _$VideoCategoryFromJson(Map<String, dynamic> json) {
  return VideoCategory(
    json['id'] as int? ?? 0,
    json['name'] as String? ?? '',
    json['url'] as String? ?? '',
  );
}

Map<String, dynamic> _$VideoCategoryToJson(VideoCategory instance) =>
    <String, dynamic>{
      'id': instance.categoryId,
      'name': instance.name,
      'url': instance.url,
    };
