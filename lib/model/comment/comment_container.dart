import 'package:flutter_app/model/music/music_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_container.g.dart';

/// 视频评论容器
@JsonSerializable()
class CommentContainer {
  List<Comment>? comments;
  @JsonKey(defaultValue: 0)
  final int totalCount;
  @JsonKey(defaultValue: false)
  final bool hasMore;
  @JsonKey(defaultValue: '')
  final String cursor;
  @JsonKey(defaultValue: 0)
  final int sortType;

  List<CommentSortType>? sortTypeList;

  CommentContainer(this.totalCount, this.hasMore, this.cursor, this.sortType);

  factory CommentContainer.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentContainerFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentContainerToJson(this);
}

@JsonSerializable()
class Comment {
  MusicUserProfile? user;
  @JsonKey(defaultValue: 0)
  final int status;
  List<CommentReplied>? beReplied;
  @JsonKey(defaultValue: 0)
  final int commentId;
  @JsonKey(defaultValue: '')
  final String content;
  int? time;
  @JsonKey(defaultValue: 0)
  final int likedCount;
  @JsonKey(defaultValue: 0)
  final int parentCommentId;
  @JsonKey(defaultValue: false)
  final bool liked;

  CommentFloor? showFloorComment;

  Comment(this.status, this.commentId, this.content, this.likedCount,
      this.parentCommentId, this.liked);

  factory Comment.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class CommentFloor {
  @JsonKey(defaultValue: 0)
  final int replyCount;

  CommentFloor(this.replyCount);

  factory CommentFloor.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentFloorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentFloorToJson(this);
}

@JsonSerializable()
class CommentReplied {
  MusicUserProfile? user;
  @JsonKey(defaultValue: 0)
  final int beRepliedCommentId;
  @JsonKey(defaultValue: '')
  final String content;

  @JsonKey(defaultValue: 0)
  final int status;

  CommentReplied(this.beRepliedCommentId, this.content, this.status);

  factory CommentReplied.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentRepliedFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentRepliedToJson(this);
}

@JsonSerializable()
class CommentSortType {
  @JsonKey(defaultValue: 0)
  final int sortType;
  @JsonKey(defaultValue: '')
  final String sortTypeName;

  @JsonKey(defaultValue: '')
  final String target;

  CommentSortType(this.sortType, this.sortTypeName, this.target);

  factory CommentSortType.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentSortTypeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentSortTypeToJson(this);
}
