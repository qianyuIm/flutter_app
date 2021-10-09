// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_user_box_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicUserBoxEvent _$MusicUserBoxEventFromJson(Map<String, dynamic> json) {
  return MusicUserBoxEvent(
    json['lasttime'] as int? ?? 0,
    json['more'] as bool? ?? false,
    json['size'] as int? ?? 0,
  )..events = (json['events'] as List<dynamic>?)
      ?.map((e) => MusicUserEvent.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$MusicUserBoxEventToJson(MusicUserBoxEvent instance) =>
    <String, dynamic>{
      'events': instance.events,
      'lasttime': instance.lasttime,
      'more': instance.more,
      'size': instance.size,
    };

MusicUserEvent _$MusicUserEventFromJson(Map<String, dynamic> json) {
  return MusicUserEvent(
    json['forwardCount'] as int? ?? 0,
    json['topEvent'] as bool? ?? false,
  )
    ..tailMark = json['tailMark'] == null
        ? null
        : MusicUserEventTail.fromJson(json['tailMark'] as Map<String, dynamic>)
    ..json = MusicUserEvent._jsonFromJson(json['json'] as String)
    ..user = json['user'] == null
        ? null
        : MusicUserProfile.fromJson(json['user'] as Map<String, dynamic>)
    ..showTime = json['showTime'] as int?
    ..id = json['id'] as int?
    ..type = _$enumDecodeNullable(_$MusicUserEventTypeEnumMap, json['type'])
    ..insiteForwardCount = json['insiteForwardCount'] as int?
    ..info = json['info'] == null
        ? null
        : MusicUserEventInfo.fromJson(json['info'] as Map<String, dynamic>)
    ..pics = (json['pics'] as List<dynamic>?)
        ?.map((e) => MusicUserEventPic.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$MusicUserEventToJson(MusicUserEvent instance) =>
    <String, dynamic>{
      'forwardCount': instance.forwardCount,
      'tailMark': instance.tailMark,
      'json': MusicUserEvent._jsonToJson(instance.json),
      'user': instance.user,
      'showTime': instance.showTime,
      'id': instance.id,
      'type': _$MusicUserEventTypeEnumMap[instance.type],
      'topEvent': instance.topEvent,
      'insiteForwardCount': instance.insiteForwardCount,
      'info': instance.info,
      'pics': instance.pics,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MusicUserEventTypeEnumMap = {
  MusicUserEventType.sharePlaylist1: 13,
  MusicUserEventType.shareDj1: 17,
  MusicUserEventType.shareSingle: 18,
  MusicUserEventType.shareAlbum: 19,
  MusicUserEventType.shareVideo1: 21,
  MusicUserEventType.forward: 22,
  MusicUserEventType.shareColumn: 24,
  MusicUserEventType.shareDj2: 28,
  MusicUserEventType.sharePlaylist2: 35,
  MusicUserEventType.sharePerformance: 38,
  MusicUserEventType.releasedVideo: 39,
  MusicUserEventType.shareVideo2: 41,
  MusicUserEventType.releasedMLog: 57,
};

MusicUserEventJson _$MusicUserEventJsonFromJson(Map<String, dynamic> json) {
  return MusicUserEventJson()
    ..msg = json['msg'] as String?
    ..resource = json['resource'] == null
        ? null
        : MusicUserEventResource.fromJson(
            json['resource'] as Map<String, dynamic>)
    ..video = json['video'] == null
        ? null
        : MusicVideo.fromJson(json['video'] as Map<String, dynamic>)
    ..mv = json['mv'] == null
        ? null
        : MusicMV.fromJson(json['mv'] as Map<String, dynamic>)
    ..mvUrl = json['qy_mvUrl'] == null
        ? null
        : MusicMVUrl.fromJson(json['qy_mvUrl'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicUserEventJsonToJson(MusicUserEventJson instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'resource': instance.resource,
      'video': instance.video,
      'mv': instance.mv,
      'qy_mvUrl': instance.mvUrl,
    };

MusicUserEventPic _$MusicUserEventPicFromJson(Map<String, dynamic> json) {
  return MusicUserEventPic(
    json['width'] as int? ?? 1,
    json['height'] as int? ?? 1,
  )
    ..originUrl = json['originUrl'] as String?
    ..squareUrl = json['squareUrl'] as String?
    ..rectangleUrl = json['rectangleUrl'] as String?
    ..pcSquareUrl = json['pcSquareUrl'] as String?
    ..pcRectangleUrl = json['pcRectangleUrl'] as String?
    ..format = json['format'] as String?;
}

Map<String, dynamic> _$MusicUserEventPicToJson(MusicUserEventPic instance) =>
    <String, dynamic>{
      'originUrl': instance.originUrl,
      'width': instance.width,
      'height': instance.height,
      'squareUrl': instance.squareUrl,
      'rectangleUrl': instance.rectangleUrl,
      'pcSquareUrl': instance.pcSquareUrl,
      'pcRectangleUrl': instance.pcRectangleUrl,
      'format': instance.format,
    };

MusicUserEventResource _$MusicUserEventResourceFromJson(
    Map<String, dynamic> json) {
  return MusicUserEventResource()
    ..userProfile = json['userProfile'] == null
        ? null
        : MusicUserProfile.fromJson(json['userProfile'] as Map<String, dynamic>)
    ..status = json['status'] as int?
    ..mlogBaseData = json['mlogBaseData'] == null
        ? null
        : MusicMlogBase.fromJson(json['mlogBaseData'] as Map<String, dynamic>)
    ..mlogExtVO = json['mlogExtVO'] == null
        ? null
        : MusicMlogExt.fromJson(json['mlogExtVO'] as Map<String, dynamic>)
    ..mlogDetail = json['mlogDetail'] == null
        ? null
        : MusicMlogDetail.fromJson(json['mlogDetail'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicUserEventResourceToJson(
        MusicUserEventResource instance) =>
    <String, dynamic>{
      'userProfile': instance.userProfile,
      'status': instance.status,
      'mlogBaseData': instance.mlogBaseData,
      'mlogExtVO': instance.mlogExtVO,
      'mlogDetail': instance.mlogDetail,
    };

MusicUserEventTail _$MusicUserEventTailFromJson(Map<String, dynamic> json) {
  return MusicUserEventTail()
    ..markTitle = json['markTitle'] as String?
    ..markType = json['markType'] as String?
    ..markResourceId = json['markResourceId'] as String?
    ..markOrpheusUrl = json['markOrpheusUrl'] as String?
    ..circle = json['circle'] == null
        ? null
        : MusicUserEventTailCircle.fromJson(
            json['circle'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicUserEventTailToJson(MusicUserEventTail instance) =>
    <String, dynamic>{
      'markTitle': instance.markTitle,
      'markType': instance.markType,
      'markResourceId': instance.markResourceId,
      'markOrpheusUrl': instance.markOrpheusUrl,
      'circle': instance.circle,
    };

MusicUserEventTailCircle _$MusicUserEventTailCircleFromJson(
    Map<String, dynamic> json) {
  return MusicUserEventTailCircle()
    ..imageUrl = json['imageUrl'] as String?
    ..postCount = json['postCount'] as String?
    ..member = json['member'] as String?;
}

Map<String, dynamic> _$MusicUserEventTailCircleToJson(
        MusicUserEventTailCircle instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'postCount': instance.postCount,
      'member': instance.member,
    };

MusicUserEventInfo _$MusicUserEventInfoFromJson(Map<String, dynamic> json) {
  return MusicUserEventInfo(
    json['liked'] as bool? ?? false,
    json['likedCount'] as int? ?? 0,
    json['commentCount'] as int? ?? 0,
    json['shareCount'] as int? ?? 0,
  )
    ..commentThread = json['commentThread'] == null
        ? null
        : MusicUserEventInfoComment.fromJson(
            json['commentThread'] as Map<String, dynamic>)
    ..resourceType = json['resourceType'] as int?
    ..resourceId = json['resourceId'] as int?;
}

Map<String, dynamic> _$MusicUserEventInfoToJson(MusicUserEventInfo instance) =>
    <String, dynamic>{
      'commentThread': instance.commentThread,
      'liked': instance.liked,
      'resourceType': instance.resourceType,
      'resourceId': instance.resourceId,
      'likedCount': instance.likedCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
    };

MusicUserEventInfoComment _$MusicUserEventInfoCommentFromJson(
    Map<String, dynamic> json) {
  return MusicUserEventInfoComment()
    ..resourceTitle = json['resourceTitle'] as String?
    ..resourceOwnerId = json['resourceOwnerId'] as int?
    ..resourceType = json['resourceType'] as int?
    ..commentCount = json['commentCount'] as int?
    ..likedCount = json['likedCount'] as int?
    ..shareCount = json['shareCount'] as int?
    ..hotCount = json['hotCount'] as int?
    ..resourceId = json['resourceId'] as int?;
}

Map<String, dynamic> _$MusicUserEventInfoCommentToJson(
        MusicUserEventInfoComment instance) =>
    <String, dynamic>{
      'resourceTitle': instance.resourceTitle,
      'resourceOwnerId': instance.resourceOwnerId,
      'resourceType': instance.resourceType,
      'commentCount': instance.commentCount,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
      'hotCount': instance.hotCount,
      'resourceId': instance.resourceId,
    };
