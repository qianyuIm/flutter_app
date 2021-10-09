import 'package:json_annotation/json_annotation.dart';

part 'internal_video_urlInfo.g.dart';

/// 播放信息
@JsonSerializable()
class InternalVideoUrlInfo {
  String? id;
  String? url;
  @JsonKey(defaultValue: 0)
  final int size;
  int? r;
  int? validityTime;
  @JsonKey(defaultValue: false)
  final bool needPay;

  InternalVideoUrlInfo(this.size, this.needPay);

  factory InternalVideoUrlInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalVideoUrlInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalVideoUrlInfoToJson(this);
}
