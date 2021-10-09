// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicBanner _$MusicBannerFromJson(Map<String, dynamic> json) {
  return MusicBanner()
    ..targetId = json['targetId'] as int?
    ..pic = json['pic'] as String?
    ..typeTitle = json['typeTitle'] as String?
    ..titleColor = json['titleColor'] as String?
    ..url = json['url'] as String?
    ..encodeId = json['encodeId'] as String?
    ..bannerId = json['bannerId'] as String?
    ..scm = json['scm'] as String?;
}

Map<String, dynamic> _$MusicBannerToJson(MusicBanner instance) =>
    <String, dynamic>{
      'targetId': instance.targetId,
      'pic': instance.pic,
      'typeTitle': instance.typeTitle,
      'titleColor': instance.titleColor,
      'url': instance.url,
      'encodeId': instance.encodeId,
      'bannerId': instance.bannerId,
      'scm': instance.scm,
    };
