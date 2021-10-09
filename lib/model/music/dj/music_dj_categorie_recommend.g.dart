// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_dj_categorie_recommend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicDJCategorieRecommend _$MusicDJCategorieRecommendFromJson(
    Map<String, dynamic> json) {
  return MusicDJCategorieRecommend(
    json['categoryName'] as String? ?? '',
    json['categoryId'] as int? ?? 0,
  )..radios = (json['radios'] as List<dynamic>?)
      ?.map((e) => MusicDjRadio.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$MusicDJCategorieRecommendToJson(
        MusicDJCategorieRecommend instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'categoryId': instance.categoryId,
      'radios': instance.radios,
    };
