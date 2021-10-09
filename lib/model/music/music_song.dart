import 'dart:convert' as convert;

import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_album.dart';
import 'package:flutter_app/model/music/music_artist.dart';
import 'package:flutter_app/model/music/music_lyric.dart';
import 'package:flutter_app/model/music/music_metadata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'music_song.g.dart';

@JsonSerializable()
class MusicSong {
  int id;
  String? name;
  int? pst;
  // @JsonKey(name: 'al')
  // @JsonKey(name: 'album')
  MusicAlbum? album;
  // @JsonKey(name: 'ar')
  List<MusicArtist>? artists;
  int? publishTime;
  String? albumName;
  int? duration;

  /// 歌曲mv id,当其为0时,表示没有mv
  // @JsonKey(name: 'mv')
  // @JsonKey(name: 'mvid')
  int mvId;

  String? reason;
  String? mp3Url;

  /// 音质
  @JsonKey(name: 'h')
  MusicSongQuality? high;
  @JsonKey(name: 'm')
  MusicSongQuality? normal;
  @JsonKey(name: 'l')
  MusicSongQuality? low;

  /// 控制是否可播放使用
  MusicPrivilege? privilege;

  /// 手动设置  音乐url
  @JsonKey(name: 'qy_metadata')
  MusicMetadata? metadata;

  /// 手动设置歌词
  @JsonKey(name: 'qy_lyric')
  MusicLyric? lyric;

  /// search 时候取出歌词字段
  MusicSearchLyrics? lyrics;
  /// 当无版权的时候展示的标识  如  无音源 其他版本可播
  MusicNoCopyrightRcmd? noCopyrightRcmd; 

  /// 列表使用 title
  String get title => name ?? '';

  /// 列表使用 subtitle
  String get subTitle {
    if (ListOptionalHelper.hasValue(artists)) {
      var ars = artists!.map((e) => e.name).join('/');
      var al = album?.name;
      return "$ars - $al";
    }
    return album?.name ?? '';
  }

  /// 播放列表使用
  String get artistName {
    if (ListOptionalHelper.hasValue(artists)) {
      var ars = artists!.map((e) => e.name).join('/');
      return "$ars";
    }
    return '';
  }

  /// 是否存在mv
  bool get hasMV {
    return mvId != 0;
  }

  /// 是否可播放
  bool get isPlayable {
    return privilege?.isPlayable ?? false;
  }
  /// vip试听
  bool get isVipAudition {
    return privilege?.isVipAudition ?? false;
  }
  /// 是否有无损音质
  bool get hasNondestructiveQuality {
    return privilege?.hasNondestructiveQuality ?? false;
  }
  

  /// 数组判定相等时用到
  bool operator ==(Object other) {
    return other is MusicSong && this.id == other.id && this.name == other.name;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  MusicSong({int? id, int? mvId})
      : this.id = id ?? 0,
        this.mvId = mvId ?? 0;

  /// 需要自己写  因为涉及到不同的nane值 等待更新支持
  factory MusicSong.fromJson(Map<String, dynamic> json) {
    /// 自定义
    var mvId = json['mv'] ?? json['mvid'];

    var song = MusicSong(
      id: json['id'] as int?,
      mvId: mvId as int?,
    )
      ..name = json['name'] as String?
      ..pst = json['pst'] as int?
      ..mp3Url = json['mp3Url'] as String?;

    /// 搜索出来的歌词
    song.lyrics = json['lyrics'] == null
        ? null
        : MusicSearchLyrics.fromJson(json['lyrics'] as Map<String, dynamic>);

    /// 自定义
    var album = json['al'] ?? json['album'];
    song.album = album == null
        ? null
        : MusicAlbum.fromJson(album as Map<String, dynamic>);

    /// 自定义
    var artists = json['ar'] ?? json['artists'];
    song.artists = (artists as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList();
    song.publishTime = json['publishTime'] as int?;
    song.reason = json['reason'] as String?;
    song.privilege = json['privilege'] == null
        ? null
        : MusicPrivilege.fromJson(json['privilege'] as Map<String, dynamic>);
    song.metadata = json['qy_metadata'] == null
        ? null
        : MusicMetadata.fromJson(json['qy_metadata'] as Map<String, dynamic>);
    song.lyric = json['qy_lyric'] == null
        ? null
        : MusicLyric.fromJson(json['qy_lyric'] as Map<String, dynamic>);
    song.high = json['h'] == null
        ? null
        : MusicSongQuality.fromJson(json['h'] as Map<String, dynamic>);
    song.normal = json['m'] == null
        ? null
        : MusicSongQuality.fromJson(json['m'] as Map<String, dynamic>);
    song.low = json['l'] == null
        ? null
        : MusicSongQuality.fromJson(json['l'] as Map<String, dynamic>);
    song.noCopyrightRcmd = json['noCopyrightRcmd'] == null
        ? null
        : MusicNoCopyrightRcmd.fromJson(json['noCopyrightRcmd'] as Map<String, dynamic>);
    return song;
  }

  Map<String, dynamic> toJson() => _$MusicSongToJson(this);

  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song_id'] = this.id;
    data['mvId'] = this.mvId;
    data['name'] = this.name;
    data['pst'] = this.pst;
    data['album'] = convert.jsonEncode(this.album);
    data['artists'] =
        convert.jsonEncode(this.artists?.map((e) => e.toJson()).toList());
    data['privilege'] = convert.jsonEncode(this.privilege);
    data['metadata'] = convert.jsonEncode(this.metadata?.toJson());
    data['lyric'] = convert.jsonEncode(this.lyric?.toJson());
    data['high'] = convert.jsonEncode(this.high?.toJson());
    data['normal'] = convert.jsonEncode(this.normal?.toJson());
    data['low'] = convert.jsonEncode(this.low?.toJson());
    return data;
  }

  factory MusicSong.fromDBMap(Map json) {
    return MusicSong(
      id: json['song_id'] as int?,
      mvId: json['mvId'] as int?,
    )
      ..name = json['name'] as String?
      ..pst = json['pst'] as int?
      ..album = json['album'] == 'null'
          ? null
          : MusicAlbum.fromJson(
              convert.jsonDecode(json['album']) as Map<String, dynamic>)
      ..artists = json['artists'] == 'null'
          ? null
          : (convert.jsonDecode(json['artists']) as List<dynamic>?)
              ?.map((e) => MusicArtist.fromJson(e))
              .toList()
      ..publishTime = json['publishTime'] as int?
      ..privilege = json['privilege'] == 'null'
          ? null
          : MusicPrivilege.fromJson(
              convert.jsonDecode(json['privilege']) as Map<String, dynamic>)
      ..metadata = json['metadata'] == 'null'
          ? null
          : MusicMetadata.fromJson(
              convert.jsonDecode(json['metadata']) as Map<String, dynamic>)
      ..lyric = json['lyric'] == 'null'
          ? null
          : MusicLyric.fromJson(
              convert.jsonDecode(json['lyric']) as Map<String, dynamic>)
      ..high = json['high'] == 'null'
          ? null
          : MusicSongQuality.fromJson(
              convert.jsonDecode(json['high']) as Map<String, dynamic>)
      ..normal = json['normal'] == 'null'
          ? null
          : MusicSongQuality.fromJson(
              convert.jsonDecode(json['normal']) as Map<String, dynamic>)
      ..low = json['low'] == 'null'
          ? null
          : MusicSongQuality.fromJson(
              convert.jsonDecode(json['low']) as Map<String, dynamic>);
  }
}

/// 音质
@JsonSerializable()
class MusicSongQuality {
  @JsonKey(defaultValue: 0)
  final int br;
  @JsonKey(defaultValue: 0)
  final int size;

  /// vd会出现double类型  先不判断了
  //  int? vd;
  @JsonKey(defaultValue: 0)
  final int fid;
  MusicSongQuality(this.br, this.size, this.fid);

  factory MusicSongQuality.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicSongQualityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicSongQualityToJson(this);
}

/// 搜索得到的歌词
@JsonSerializable()
class MusicSearchLyrics {
  @JsonKey(defaultValue: '')
  final String txt;
  List<MusicSearchLyricRange>? range;
  MusicSearchLyrics(this.txt);

  factory MusicSearchLyrics.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicSearchLyricsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicSearchLyricsToJson(this);

  /// 数组
  List<String> get lyrics => txt.split('\n');
  // .where((element) => element.isNotEmpty).toList()

}

@JsonSerializable()
class MusicSearchLyricRange {
  @JsonKey(defaultValue: 0)
  final int first;
  @JsonKey(defaultValue: 0)
  final int second;

  MusicSearchLyricRange(this.first, this.second);

  factory MusicSearchLyricRange.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicSearchLyricRangeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicSearchLyricRangeToJson(this);
}

/// 其中字段st 控制音乐是否可以播放使用的
@JsonSerializable()
class MusicNoCopyrightRcmd {
  @JsonKey(defaultValue: 0)
  final int type;
   @JsonKey(defaultValue: '')
  final String typeDesc;
   String? songId;


  MusicNoCopyrightRcmd(this.type, this.typeDesc);
    
  factory MusicNoCopyrightRcmd.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicNoCopyrightRcmdFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicNoCopyrightRcmdToJson(this);
}

/// 其中字段st 控制音乐是否可以播放使用的
@JsonSerializable()
class MusicPrivilege {
  @JsonKey(defaultValue: 0)
  final int id;
  // privilege.st< 0无版权
  @JsonKey(defaultValue: 0)
  final int st;
  @JsonKey(defaultValue: 0)
  // privilege.fee
  // 8、0：免费
  // 4：所在专辑需单独付费
  // 1：VIP可听
  // 29561031
  final int fee;
  @JsonKey(defaultValue: 0)
  final int maxbr;
  @JsonKey(defaultValue: 0)
  final int playMaxbr;
  @JsonKey(defaultValue: 0)
  final int downloadMaxbr;


  

  MusicPrivilege(this.id, this.st, this.fee, this.maxbr, this.playMaxbr, this.downloadMaxbr);

  /// 是否可播放 小于0  不能播放 或者可以试听  不判断
  bool get isPlayable => (st >= 0);
  /// vip试听 不知道怎么判断
  bool get isVipAudition => false;
  /// 是否有无损音质
  bool get hasNondestructiveQuality => (maxbr == 999000);


  factory MusicPrivilege.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicPrivilegeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicPrivilegeToJson(this);
}
