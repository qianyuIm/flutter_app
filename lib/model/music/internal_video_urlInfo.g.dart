// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_video_urlInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternalVideoUrlInfo _$InternalVideoUrlInfoFromJson(Map<String, dynamic> json) {
  return InternalVideoUrlInfo(
    json['size'] as int? ?? 0,
    json['needPay'] as bool? ?? false,
  )
    ..id = json['id'] as String?
    ..url = json['url'] as String?
    ..r = json['r'] as int?
    ..validityTime = json['validityTime'] as int?;
}

Map<String, dynamic> _$InternalVideoUrlInfoToJson(
        InternalVideoUrlInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'size': instance.size,
      'r': instance.r,
      'validityTime': instance.validityTime,
      'needPay': instance.needPay,
    };
