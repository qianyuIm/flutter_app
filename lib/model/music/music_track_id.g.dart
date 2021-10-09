// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_track_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicTrackId _$MusicTrackIdFromJson(Map<String, dynamic> json) {
  return MusicTrackId(
    id: json['id'] as int?,
  )
    ..v = json['v'] as int?
    ..t = json['t'] as int?
    ..at = json['at'] as int?
    ..rcmdReason = json['rcmdReason'] as String?;
}

Map<String, dynamic> _$MusicTrackIdToJson(MusicTrackId instance) =>
    <String, dynamic>{
      'id': instance.id,
      'v': instance.v,
      't': instance.t,
      'at': instance.at,
      'rcmdReason': instance.rcmdReason,
    };
