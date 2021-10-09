import 'package:json_annotation/json_annotation.dart';

part 'music_track_id.g.dart';
@JsonSerializable()
class MusicTrackId {
  int id;
  int? v;
  int? t;
  int? at;
  String? rcmdReason;
  MusicTrackId({int? id}) : this.id = id ?? 0;

  factory MusicTrackId.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicTrackIdFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicTrackIdToJson(this);
}
