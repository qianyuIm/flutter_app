import 'package:flutter_app/model/music/music_mlog.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/model/music/music_video.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' as convert;

part 'music_user_box_event.g.dart';

enum MusicUserEventType {
  @JsonValue(13)
  sharePlaylist1,

  @JsonValue(17)
  shareDj1,

  @JsonValue(18)
  shareSingle,

  @JsonValue(19)
  shareAlbum,

  @JsonValue(21)
  shareVideo1,

  @JsonValue(22)
  forward,

  @JsonValue(24)
  shareColumn,

  @JsonValue(28)
  shareDj2,

  @JsonValue(35)
  sharePlaylist2,

  @JsonValue(38)
  sharePerformance,

  @JsonValue(39)
  releasedVideo,

  @JsonValue(41)
  shareVideo2,

  @JsonValue(57)
  releasedMLog,
}

extension MusicUserEventTypeGetTitle on MusicUserEventType {
  String get title {
    if (this == MusicUserEventType.shareSingle) {
      return '分享单曲';
    } else if (this == MusicUserEventType.shareAlbum) {
      return '分享专辑';
    } else if (this == MusicUserEventType.shareDj1 ||
        this == MusicUserEventType.shareDj2) {
      return '分享电台节目';
    } else if (this == MusicUserEventType.forward) {
      return '转发';
    } else if (this == MusicUserEventType.releasedVideo) {
      return '发布视频';
    } else if (this == MusicUserEventType.sharePlaylist1 ||
        this == MusicUserEventType.sharePlaylist2) {
      return '分享歌单';
    } else if (this == MusicUserEventType.shareColumn) {
      return '分享专栏文章';
    } else if (this == MusicUserEventType.shareVideo1 ||
        this == MusicUserEventType.shareVideo2) {
      return '分享视频';
    } else if (this == MusicUserEventType.sharePerformance) {
      return '分享演出';
    }
    return '发布Mlog';
  }
}

/// 用户动态模型
@JsonSerializable()
class MusicUserBoxEvent {
  List<MusicUserEvent>? events;
  @JsonKey(defaultValue: 0)
  final int lasttime;
  @JsonKey(defaultValue: false)
  final bool more;
  @JsonKey(defaultValue: 0)
  final int size;
  MusicUserBoxEvent(this.lasttime, this.more, this.size);

  factory MusicUserBoxEvent.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserBoxEventFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserBoxEventToJson(this);
}

@JsonSerializable()
class MusicUserEvent {
  @JsonKey(defaultValue: 0)
  final int forwardCount;
  MusicUserEventTail? tailMark;

  @JsonKey(fromJson: _jsonFromJson, toJson: _jsonToJson)
  MusicUserEventJson? json;

  MusicUserProfile? user;
  int? showTime;
  int? id;
  MusicUserEventType? type;
  @JsonKey(defaultValue: false)
  final bool topEvent;
  int? insiteForwardCount;
  MusicUserEventInfo? info;
  List<MusicUserEventPic>? pics;

  MusicUserEvent(this.forwardCount, this.topEvent);

  factory MusicUserEvent.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventToJson(this);

  static MusicUserEventJson? _jsonFromJson(String json) {
    return MusicUserEventJson.fromJson(
        convert.jsonDecode(json) as Map<String, dynamic>);
  }

  static String? _jsonToJson(MusicUserEventJson? json) {
    return convert.jsonEncode(json);
  }
}

enum MusicUserEventSubType {
  none,
  /// video
  video,
  /// mv
  mv,
  /// mlog 中的视频
  mlogVideo,
  /// 静态图片
  mlog
}

@JsonSerializable()
class MusicUserEventJson {
  String? msg;
  MusicUserEventResource? resource;
  MusicVideo? video;
  MusicMV? mv;
  /// 自定义字段
  @JsonKey(name: 'qy_mvUrl')
  MusicMVUrl? mvUrl;

  MusicUserEventJson();
  MusicUserEventSubType get subType {
    if (this.video != null) {
      return MusicUserEventSubType.video;
    } else if (mv != null) {
      return MusicUserEventSubType.mv;
    } else if (this.resource?.mlogDetail?.content?.video != null) {
      return MusicUserEventSubType.mlogVideo;
    } else if (this.resource != null) {
      return MusicUserEventSubType.mlog;
    }
    return MusicUserEventSubType.none;
  }

  factory MusicUserEventJson.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventJsonFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventJsonToJson(this);
}

@JsonSerializable()
class MusicUserEventPic {
  String? originUrl;
  @JsonKey(defaultValue: 1)
  final int width;
  @JsonKey(defaultValue: 1)
  final int height;
  String? squareUrl;
  String? rectangleUrl;
  String? pcSquareUrl;
  String? pcRectangleUrl;
  String? format;

  MusicUserEventPic(this.width, this.height);

  factory MusicUserEventPic.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventPicFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventPicToJson(this);
}

@JsonSerializable()
class MusicUserEventResource {
  MusicUserProfile? userProfile;
  int? status;
  MusicMlogBase? mlogBaseData;
  MusicMlogExt? mlogExtVO;
  MusicMlogDetail? mlogDetail;

  MusicUserEventResource();

  factory MusicUserEventResource.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventResourceFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventResourceToJson(this);
}

@JsonSerializable()
class MusicUserEventTail {
  String? markTitle;
  String? markType;
  String? markResourceId;
  String? markOrpheusUrl;
  MusicUserEventTailCircle? circle;
  MusicUserEventTail();

  factory MusicUserEventTail.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventTailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventTailToJson(this);
}

@JsonSerializable()
class MusicUserEventTailCircle {
  String? imageUrl;
  String? postCount;
  String? member;
  MusicUserEventTailCircle();

  factory MusicUserEventTailCircle.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventTailCircleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventTailCircleToJson(this);
}

@JsonSerializable()
class MusicUserEventInfo {
  MusicUserEventInfoComment? commentThread;
  @JsonKey(defaultValue: false)
  final bool liked;
  int? resourceType;
  int? resourceId;
  @JsonKey(defaultValue: 0)
  final int likedCount;
  @JsonKey(defaultValue: 0)
  final int commentCount;
  @JsonKey(defaultValue: 0)
  final int shareCount;

  MusicUserEventInfo(
      this.liked, this.likedCount, this.commentCount, this.shareCount);

  factory MusicUserEventInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventInfoToJson(this);
}

@JsonSerializable()
class MusicUserEventInfoComment {
  String? resourceTitle;
  int? resourceOwnerId;
  int? resourceType;
  int? commentCount;
  int? likedCount;
  int? shareCount;
  int? hotCount;
  int? resourceId;

  MusicUserEventInfoComment();

  factory MusicUserEventInfoComment.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUserEventInfoCommentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicUserEventInfoCommentToJson(this);
}
