// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_mv.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternalMv _$InternalMvFromJson(Map<String, dynamic> json) {
  return InternalMv(
    json['id'] as int? ?? 0,
    json['playCount'] as int? ?? 0,
    json['artistName'] as String? ?? '',
  )
    ..cover = json['cover'] as String?
    ..name = json['name'] as String?
    ..artistId = json['artistId'] as int?
    ..duration = json['duration'] as int?
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..mvUrl = json['mvUrl'] == null
        ? null
        : MusicMVUrl.fromJson(json['mvUrl'] as Map<String, dynamic>)
    ..detail = json['detail'] == null
        ? null
        : InternalMvDetail.fromJson(json['detail'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InternalMvToJson(InternalMv instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cover': instance.cover,
      'name': instance.name,
      'playCount': instance.playCount,
      'artistName': instance.artistName,
      'artistId': instance.artistId,
      'duration': instance.duration,
      'artists': instance.artists,
      'mvUrl': instance.mvUrl,
      'detail': instance.detail,
    };

InternalMvDetail _$InternalMvDetailFromJson(Map<String, dynamic> json) {
  return InternalMvDetail(
    json['subed'] as bool? ?? false,
  )
    ..info = json['info'] == null
        ? null
        : InternalMvDetailInfo.fromJson(json['info'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : InternalMvDetailData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InternalMvDetailToJson(InternalMvDetail instance) =>
    <String, dynamic>{
      'subed': instance.subed,
      'info': instance.info,
      'data': instance.data,
    };

InternalMvDetailData _$InternalMvDetailDataFromJson(Map<String, dynamic> json) {
  return InternalMvDetailData(
    json['id'] as int? ?? 0,
    json['artistId'] as int? ?? 0,
    json['playCount'] as int? ?? 0,
    json['subCount'] as int? ?? 0,
    json['shareCount'] as int? ?? 0,
    json['commentCount'] as int? ?? 0,
  )
    ..name = json['name'] as String?
    ..artistName = json['artistName'] as String?
    ..desc = json['desc'] as String?
    ..cover = json['cover'] as String?
    ..publishTime = json['publishTime'] as String?
    ..brs = (json['brs'] as List<dynamic>?)
        ?.map((e) => MusicSongQuality.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$InternalMvDetailDataToJson(
        InternalMvDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'desc': instance.desc,
      'cover': instance.cover,
      'playCount': instance.playCount,
      'subCount': instance.subCount,
      'shareCount': instance.shareCount,
      'commentCount': instance.commentCount,
      'publishTime': instance.publishTime,
      'brs': instance.brs,
      'artists': instance.artists,
    };

InternalMvDetailInfo _$InternalMvDetailInfoFromJson(Map<String, dynamic> json) {
  return InternalMvDetailInfo(
    json['liked'] as bool? ?? false,
    json['likedCount'] as int? ?? 0,
    json['shareCount'] as int? ?? 0,
    json['commentCount'] as int? ?? 0,
  );
}

Map<String, dynamic> _$InternalMvDetailInfoToJson(
        InternalMvDetailInfo instance) =>
    <String, dynamic>{
      'liked': instance.liked,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
      'commentCount': instance.commentCount,
    };
