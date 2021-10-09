// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_mlog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicMlogBase _$MusicMlogBaseFromJson(Map<String, dynamic> json) {
  return MusicMlogBase(
    json['coverHeight'] as int? ?? 1,
    json['coverWidth'] as int? ?? 1,
  )
    ..id = json['id'] as String?
    ..type = json['type'] as int?
    ..text = json['text'] as String?
    ..coverUrl = json['coverUrl'] as String?;
}

Map<String, dynamic> _$MusicMlogBaseToJson(MusicMlogBase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'text': instance.text,
      'coverUrl': instance.coverUrl,
      'coverHeight': instance.coverHeight,
      'coverWidth': instance.coverWidth,
    };

MusicMlogExt _$MusicMlogExtFromJson(Map<String, dynamic> json) {
  return MusicMlogExt()
    ..commentCount = json['commentCount'] as int?
    ..likedCount = json['likedCount'] as int?
    ..shareCount = json['shareCount'] as int?;
}

Map<String, dynamic> _$MusicMlogExtToJson(MusicMlogExt instance) =>
    <String, dynamic>{
      'commentCount': instance.commentCount,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
    };

MusicMlogDetail _$MusicMlogDetailFromJson(Map<String, dynamic> json) {
  return MusicMlogDetail()
    ..id = json['id'] as String?
    ..userId = json['userId'] as int?
    ..type = json['type'] as int?
    ..content = json['content'] == null
        ? null
        : MusicMlogContent.fromJson(json['content'] as Map<String, dynamic>)
    ..pubTime = json['pubTime'] as int?
    ..status = json['status'] as int?
    ..shareUrl = json['shareUrl'] as String?
    ..playCount = json['playCount'] as int?
    ..threadId = json['threadId'] as String?;
}

Map<String, dynamic> _$MusicMlogDetailToJson(MusicMlogDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'content': instance.content,
      'pubTime': instance.pubTime,
      'status': instance.status,
      'shareUrl': instance.shareUrl,
      'playCount': instance.playCount,
      'threadId': instance.threadId,
    };

MusicMlogContent _$MusicMlogContentFromJson(Map<String, dynamic> json) {
  return MusicMlogContent()
    ..text = json['text'] as String?
    ..interveneText = json['interveneText'] as String?
    ..coverColor = json['coverColor'] as int?
    ..video = json['video'] == null
        ? null
        : MusicMlogVideo.fromJson(json['video'] as Map<String, dynamic>)
    ..songs = (json['songs'] as List<dynamic>?)
        ?.map((e) => MusicSong.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicMlogContentToJson(MusicMlogContent instance) =>
    <String, dynamic>{
      'text': instance.text,
      'interveneText': instance.interveneText,
      'coverColor': instance.coverColor,
      'video': instance.video,
      'songs': instance.songs,
    };
