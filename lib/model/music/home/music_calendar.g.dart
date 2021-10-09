// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicCalendar _$MusicCalendarFromJson(Map<String, dynamic> json) {
  return MusicCalendar(
    json['onlineTime'] as int? ?? 0,
    json['offlineTime'] as int? ?? 0,
    json['canRemind'] as bool? ?? false,
    json['reminded'] as bool? ?? false,
  )
    ..id = json['id'] as String?
    ..eventType = json['eventType'] as String?
    ..tag = json['tag'] as String?
    ..title = json['title'] as String?
    ..imgUrl = json['imgUrl'] as String?
    ..remindText = json['remindText'] as String?
    ..remindedText = json['remindedText'] as String?
    ..targetUrl = json['targetUrl'] as String?
    ..resourceType = json['resourceType'] as String?;
}

Map<String, dynamic> _$MusicCalendarToJson(MusicCalendar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventType': instance.eventType,
      'onlineTime': instance.onlineTime,
      'offlineTime': instance.offlineTime,
      'tag': instance.tag,
      'title': instance.title,
      'imgUrl': instance.imgUrl,
      'canRemind': instance.canRemind,
      'reminded': instance.reminded,
      'remindText': instance.remindText,
      'remindedText': instance.remindedText,
      'targetUrl': instance.targetUrl,
      'resourceType': instance.resourceType,
    };
