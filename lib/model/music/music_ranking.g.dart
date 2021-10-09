// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_ranking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicRanking _$MusicRankingFromJson(Map<String, dynamic> json) {
  return MusicRanking()
    ..code = json['code'] as int?
    ..list = (json['list'] as List<dynamic>?)
        ?.map((e) => MusicRankingList.fromJson(e as Map<String, dynamic>))
        .toList()
    ..artistToplist = json['artistToplist'] == null
        ? null
        : MusicRankingArtistToplist.fromJson(
            json['artistToplist'] as Map<String, dynamic>)
    ..rewardToplist = json['rewardToplist'] == null
        ? null
        : MusicRankingRewardToplist.fromJson(
            json['rewardToplist'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicRankingToJson(MusicRanking instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
      'artistToplist': instance.artistToplist,
      'rewardToplist': instance.rewardToplist,
    };

MusicRankingList _$MusicRankingListFromJson(Map<String, dynamic> json) {
  return MusicRankingList(
    json['backgroundCoverId'] as int? ?? 0,
    json['trackNumberUpdateTime'] as int? ?? 0,
    json['subscribedCount'] as int? ?? 0,
    json['playCount'] as int? ?? 0,
  )
    ..tracks = (json['tracks'] as List<dynamic>?)
        ?.map((e) => MusicTrack.fromJson(e as Map<String, dynamic>))
        .toList()
    ..updateFrequency = json['updateFrequency'] as String?
    ..createTime = json['createTime'] as int?
    ..coverImgUrl = json['coverImgUrl'] as String?
    ..name = json['name'] as String?
    ..commentThreadId = json['commentThreadId'] as String?
    ..updateTime = json['updateTime'] as int?;
}

Map<String, dynamic> _$MusicRankingListToJson(MusicRankingList instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
      'updateFrequency': instance.updateFrequency,
      'backgroundCoverId': instance.backgroundCoverId,
      'trackNumberUpdateTime': instance.trackNumberUpdateTime,
      'subscribedCount': instance.subscribedCount,
      'createTime': instance.createTime,
      'coverImgUrl': instance.coverImgUrl,
      'playCount': instance.playCount,
      'name': instance.name,
      'commentThreadId': instance.commentThreadId,
      'updateTime': instance.updateTime,
    };

MusicRankingArtistToplist _$MusicRankingArtistToplistFromJson(
    Map<String, dynamic> json) {
  return MusicRankingArtistToplist()
    ..coverUrl = json['coverUrl'] as String?
    ..name = json['name'] as String?
    ..updateFrequency = json['updateFrequency'] as String?
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..position = json['position'] as int?;
}

Map<String, dynamic> _$MusicRankingArtistToplistToJson(
        MusicRankingArtistToplist instance) =>
    <String, dynamic>{
      'coverUrl': instance.coverUrl,
      'name': instance.name,
      'updateFrequency': instance.updateFrequency,
      'artists': instance.artists,
      'position': instance.position,
    };

MusicRankingRewardToplist _$MusicRankingRewardToplistFromJson(
    Map<String, dynamic> json) {
  return MusicRankingRewardToplist()
    ..coverUrl = json['coverUrl'] as String?
    ..name = json['name'] as String?
    ..position = json['position'] as int?
    ..songs = (json['songs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicRankingRewardToplistToJson(
        MusicRankingRewardToplist instance) =>
    <String, dynamic>{
      'coverUrl': instance.coverUrl,
      'name': instance.name,
      'position': instance.position,
      'songs': instance.songs,
    };

MusicTrack _$MusicTrackFromJson(Map<String, dynamic> json) {
  return MusicTrack()
    ..first = json['first'] as String?
    ..second = json['second'] as String?;
}

Map<String, dynamic> _$MusicTrackToJson(MusicTrack instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };
