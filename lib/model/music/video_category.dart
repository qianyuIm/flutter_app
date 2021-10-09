import 'package:json_annotation/json_annotation.dart';

part 'video_category.g.dart';

@JsonSerializable()
class VideoCategory {
  @JsonKey(name: 'id',defaultValue: 0)
  final int categoryId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String url;
  

VideoCategory(this.categoryId, this.name, this.url);

  factory VideoCategory.fromJson(Map<String, dynamic> srcJson) =>
      _$VideoCategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoCategoryToJson(this);
}