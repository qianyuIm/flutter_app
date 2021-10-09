import 'package:flutter_app/helper/time_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_metadata.g.dart';

@JsonSerializable()
/// 保存音乐URL信息
class MusicMetadata {
  @JsonKey(defaultValue: 0)
  final int id;
  String? url;
  int? size;
  String? type;
  /// 过期时间
  @JsonKey(defaultValue: 0)
  final int expi;
  /// 插入数据库时间
  
   int? insertDbTime;

MusicMetadata(this.id, this.expi);

  factory MusicMetadata.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicMetadataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicMetadataToJson(this);
  /// 是否过期
  bool get isExpi {
    if (insertDbTime == null) return true;
    if (TimeHelper.now() - insertDbTime! > (expi * 1000)) return true;
    return false;
  }
}