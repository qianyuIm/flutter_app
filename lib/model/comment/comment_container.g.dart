// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentContainer _$CommentContainerFromJson(Map<String, dynamic> json) {
  return CommentContainer(
    json['totalCount'] as int? ?? 0,
    json['hasMore'] as bool? ?? false,
    json['cursor'] as String? ?? '',
    json['sortType'] as int? ?? 0,
  )
    ..comments = (json['comments'] as List<dynamic>?)
        ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList()
    ..sortTypeList = (json['sortTypeList'] as List<dynamic>?)
        ?.map((e) => CommentSortType.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$CommentContainerToJson(CommentContainer instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'totalCount': instance.totalCount,
      'hasMore': instance.hasMore,
      'cursor': instance.cursor,
      'sortType': instance.sortType,
      'sortTypeList': instance.sortTypeList,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    json['status'] as int? ?? 0,
    json['commentId'] as int? ?? 0,
    json['content'] as String? ?? '',
    json['likedCount'] as int? ?? 0,
    json['parentCommentId'] as int? ?? 0,
    json['liked'] as bool? ?? false,
  )
    ..user = json['user'] == null
        ? null
        : MusicUserProfile.fromJson(json['user'] as Map<String, dynamic>)
    ..beReplied = (json['beReplied'] as List<dynamic>?)
        ?.map((e) => CommentReplied.fromJson(e as Map<String, dynamic>))
        .toList()
    ..time = json['time'] as int?
    ..showFloorComment = json['showFloorComment'] == null
        ? null
        : CommentFloor.fromJson(
            json['showFloorComment'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'user': instance.user,
      'status': instance.status,
      'beReplied': instance.beReplied,
      'commentId': instance.commentId,
      'content': instance.content,
      'time': instance.time,
      'likedCount': instance.likedCount,
      'parentCommentId': instance.parentCommentId,
      'liked': instance.liked,
      'showFloorComment': instance.showFloorComment,
    };

CommentFloor _$CommentFloorFromJson(Map<String, dynamic> json) {
  return CommentFloor(
    json['replyCount'] as int? ?? 0,
  );
}

Map<String, dynamic> _$CommentFloorToJson(CommentFloor instance) =>
    <String, dynamic>{
      'replyCount': instance.replyCount,
    };

CommentReplied _$CommentRepliedFromJson(Map<String, dynamic> json) {
  return CommentReplied(
    json['beRepliedCommentId'] as int? ?? 0,
    json['content'] as String? ?? '',
    json['status'] as int? ?? 0,
  )..user = json['user'] == null
      ? null
      : MusicUserProfile.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CommentRepliedToJson(CommentReplied instance) =>
    <String, dynamic>{
      'user': instance.user,
      'beRepliedCommentId': instance.beRepliedCommentId,
      'content': instance.content,
      'status': instance.status,
    };

CommentSortType _$CommentSortTypeFromJson(Map<String, dynamic> json) {
  return CommentSortType(
    json['sortType'] as int? ?? 0,
    json['sortTypeName'] as String? ?? '',
    json['target'] as String? ?? '',
  );
}

Map<String, dynamic> _$CommentSortTypeToJson(CommentSortType instance) =>
    <String, dynamic>{
      'sortType': instance.sortType,
      'sortTypeName': instance.sortTypeName,
      'target': instance.target,
    };
