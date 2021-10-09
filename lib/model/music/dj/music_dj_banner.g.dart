// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDjBanner _$MusicDjBannerFromJson(Map<String, dynamic> json) {
  return MusicDjBanner(
    json['targetId'] as int? ?? 0,
    json['targetType'] as int? ?? 0,
    json['pic'] as String? ?? '',
    json['url'] as String? ?? '',
    json['typeTitle'] as String? ?? '',
    json['exclusive'] as bool? ?? false,
  );
}

Map<String, dynamic> _$MusicDjBannerToJson(MusicDjBanner instance) =>
    <String, dynamic>{
      'targetId': instance.targetId,
      'targetType': instance.targetType,
      'pic': instance.pic,
      'url': instance.url,
      'typeTitle': instance.typeTitle,
      'exclusive': instance.exclusive,
    };
