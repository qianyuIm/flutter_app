import 'package:flutter_app/model/music/internal_video_urlInfo.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_artist_user.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:json_annotation/json_annotation.dart';

part 'internal_video.g.dart';

@JsonSerializable()
class InternalVideo {
  @JsonKey(defaultValue: 0)
  final int type;
  @JsonKey(defaultValue: false)
  final bool displayed;
  @JsonKey(defaultValue: '')
  final String alg;
  InternalVideoData? data;

  InternalVideo(this.type, this.displayed, this.alg);

  factory InternalVideo.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalVideoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalVideoToJson(this);

  String get itemTitle {
    if (type == 1) {
      return data?.title ?? '';
    }
    return data?.name ?? '';
  }

  String get itemSubTitle {
    if (type == 1) {
      return 'by ${data?.creator?.nickname ?? ''}';
    }
    return data?.artists?.first.name ?? '';
  }

  String? get itemPicUrl {
    // return 'https://p2.music.126.net/ezKIGLy6QQFm1Wol04eTOA==/109951163779350188.jpg';
    if (type == 1) {
      return data?.coverUrl;
    }
    return data?.imgurl16v9;
  }

  /// 播放页面视频比例根据宽来
  double verticalAspectRatio(double maxWidth,double maxHeight) {
    return maxWidth / maxHeight;
  }

  double verticalItemImageHeight(double maxWidth) {
    if (type == 1) {
      var height = data?.height;
      var width = data?.width;
      if (height == 0 || height == null) {
        return maxWidth * 9 / 16;
      }
      if (width == 0 || width == null) {
        return maxWidth * 9 / 16;
      }
      // aspectRatio
      return maxWidth * height / width;
    }
    return maxWidth * 9 / 16;
  }

  /// 视频比例
  double aspectRatio(double maxWidth, double maxHeight) {
    var aspectRatio = maxWidth / maxHeight;
    if (type == 1) {
      var height = data?.height;
      var width = data?.width;
      // var height = 952;
      // var width = 540;
      if (height == 0 || height == null) {
        return maxWidth / maxHeight;
      }
      if (width == 0 || width == null) {
        return maxWidth / maxHeight;
      }
      // 如果高大于宽的话则高一定求宽
      if (height > width) {
        var aspectWidth = maxHeight * width / height;
        return aspectWidth / maxHeight;
      }
      // aspectRatio
      return maxWidth / maxHeight;
      
    }
    return aspectRatio;
  }

  /// 如果没有宽高则 默认宽高比 16 / 9
  double itemImageHeight(double maxWidth) {
    /// height 952
    /// width 540
    // return maxWidth * 540 / 952;
    if (type == 1) {
      var height = data?.height;
      var width = data?.width;
      if (height == 0 || height == null) {
        return maxWidth * 9 / 16;
      }
      if (width == 0 || width == null) {
        return maxWidth * 9 / 16;
      }
      // 如果高大于宽的话则高一定求宽
      if (height > width) {
        // LogUtil.v('高大于宽 => $height');
        return maxWidth * width / height;
      }
      // aspectRatio
      return maxWidth * height / width;
    }
    return maxWidth * 9 / 16;
  }
}

@JsonSerializable()
class InternalVideoData {
  String? alg;
  String? scm;
  String? threadId;
  String? coverUrl;
  @JsonKey(defaultValue: 0)
  final double height;
  @JsonKey(defaultValue: 0)
  final double width;
  String? title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: 0)
  final int commentCount;
  @JsonKey(defaultValue: 0)
  final int shareCount;
  List<VideoResolution>? resolutions;
  List<MusicArtist>? artists;
  String? imgurl16v9;
  MusicArtistUser? creator;
  InternalVideoUrlInfo? urlInfo;
  /// 相关音乐
  List<MusicSong>? relateSong;
  String? name;
  String? vid;
  int? durationms;
  int? playTime;
  int? praisedCount;

  InternalVideoData(this.height, this.width, this.title, this.description,
      this.commentCount, this.shareCount);

  factory InternalVideoData.fromJson(Map<String, dynamic> srcJson) =>
      _$InternalVideoDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InternalVideoDataToJson(this);
}

/// 分辨率
@JsonSerializable()
class VideoResolution {
  @JsonKey(defaultValue: 240)
  final int resolution;
  @JsonKey(defaultValue: 0)
  final int size;
  VideoResolution(this.resolution, this.size);

  factory VideoResolution.fromJson(Map<String, dynamic> srcJson) =>
      _$VideoResolutionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoResolutionToJson(this);
}
