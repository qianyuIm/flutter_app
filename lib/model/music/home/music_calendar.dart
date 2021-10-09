import 'package:json_annotation/json_annotation.dart';

part 'music_calendar.g.dart';

@JsonSerializable()
class MusicCalendar {
  String? id;
  String? eventType;
  @JsonKey(defaultValue: 0)
  final int onlineTime;
  @JsonKey(defaultValue: 0)
  final int offlineTime;
  String? tag;
  String? title;
  String? imgUrl;
  @JsonKey(defaultValue: false)
  final bool canRemind;
  @JsonKey(defaultValue: false)
  final bool reminded;

  String? remindText;
  String? remindedText;
  String? targetUrl;
  String? resourceType;


  MusicCalendar(this.onlineTime, this.offlineTime, this.canRemind, this.reminded);

  factory MusicCalendar.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicCalendarFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicCalendarToJson(this);
}
