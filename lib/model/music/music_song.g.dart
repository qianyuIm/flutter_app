// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicSong _$MusicSongFromJson(Map<String, dynamic> json) {
  return MusicSong(
    id: json['id'] as int?,
    mvId: json['mvId'] as int?,
  )
    ..name = json['name'] as String?
    ..pst = json['pst'] as int?
    ..album = json['album'] == null
        ? null
        : MusicAlbum.fromJson(json['album'] as Map<String, dynamic>)
    ..artists = (json['artists'] as List<dynamic>?)
        ?.map((e) => MusicArtist.fromJson(e as Map<String, dynamic>))
        .toList()
    ..publishTime = json['publishTime'] as int?
    ..albumName = json['albumName'] as String?
    ..duration = json['duration'] as int?
    ..reason = json['reason'] as String?
    ..mp3Url = json['mp3Url'] as String?
    ..high = json['h'] == null
        ? null
        : MusicSongQuality.fromJson(json['h'] as Map<String, dynamic>)
    ..normal = json['m'] == null
        ? null
        : MusicSongQuality.fromJson(json['m'] as Map<String, dynamic>)
    ..low = json['l'] == null
        ? null
        : MusicSongQuality.fromJson(json['l'] as Map<String, dynamic>)
    ..privilege = json['privilege'] == null
        ? null
        : MusicPrivilege.fromJson(json['privilege'] as Map<String, dynamic>)
    ..metadata = json['qy_metadata'] == null
        ? null
        : MusicMetadata.fromJson(json['qy_metadata'] as Map<String, dynamic>)
    ..lyric = json['qy_lyric'] == null
        ? null
        : MusicLyric.fromJson(json['qy_lyric'] as Map<String, dynamic>)
    ..lyrics = json['lyrics'] == null
        ? null
        : MusicSearchLyrics.fromJson(json['lyrics'] as Map<String, dynamic>)
    ..noCopyrightRcmd = json['noCopyrightRcmd'] == null
        ? null
        : MusicNoCopyrightRcmd.fromJson(
            json['noCopyrightRcmd'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MusicSongToJson(MusicSong instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pst': instance.pst,
      'album': instance.album,
      'artists': instance.artists,
      'publishTime': instance.publishTime,
      'albumName': instance.albumName,
      'duration': instance.duration,
      'mvId': instance.mvId,
      'reason': instance.reason,
      'mp3Url': instance.mp3Url,
      'h': instance.high,
      'm': instance.normal,
      'l': instance.low,
      'privilege': instance.privilege,
      'qy_metadata': instance.metadata,
      'qy_lyric': instance.lyric,
      'lyrics': instance.lyrics,
      'noCopyrightRcmd': instance.noCopyrightRcmd,
    };

MusicSongQuality _$MusicSongQualityFromJson(Map<String, dynamic> json) {
  return MusicSongQuality(
    json['br'] as int? ?? 0,
    json['size'] as int? ?? 0,
    json['fid'] as int? ?? 0,
  );
}

Map<String, dynamic> _$MusicSongQualityToJson(MusicSongQuality instance) =>
    <String, dynamic>{
      'br': instance.br,
      'size': instance.size,
      'fid': instance.fid,
    };

MusicSearchLyrics _$MusicSearchLyricsFromJson(Map<String, dynamic> json) {
  return MusicSearchLyrics(
    json['txt'] as String? ?? '',
  )..range = (json['range'] as List<dynamic>?)
      ?.map((e) => MusicSearchLyricRange.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$MusicSearchLyricsToJson(MusicSearchLyrics instance) =>
    <String, dynamic>{
      'txt': instance.txt,
      'range': instance.range,
    };

MusicSearchLyricRange _$MusicSearchLyricRangeFromJson(
    Map<String, dynamic> json) {
  return MusicSearchLyricRange(
    json['first'] as int? ?? 0,
    json['second'] as int? ?? 0,
  );
}

Map<String, dynamic> _$MusicSearchLyricRangeToJson(
        MusicSearchLyricRange instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
    };

MusicNoCopyrightRcmd _$MusicNoCopyrightRcmdFromJson(Map<String, dynamic> json) {
  return MusicNoCopyrightRcmd(
    json['type'] as int? ?? 0,
    json['typeDesc'] as String? ?? '',
  )..songId = json['songId'] as String?;
}

Map<String, dynamic> _$MusicNoCopyrightRcmdToJson(
        MusicNoCopyrightRcmd instance) =>
    <String, dynamic>{
      'type': instance.type,
      'typeDesc': instance.typeDesc,
      'songId': instance.songId,
    };

MusicPrivilege _$MusicPrivilegeFromJson(Map<String, dynamic> json) {
  return MusicPrivilege(
    json['id'] as int? ?? 0,
    json['st'] as int? ?? 0,
    json['fee'] as int? ?? 0,
    json['maxbr'] as int? ?? 0,
    json['playMaxbr'] as int? ?? 0,
    json['downloadMaxbr'] as int? ?? 0,
  );
}

Map<String, dynamic> _$MusicPrivilegeToJson(MusicPrivilege instance) =>
    <String, dynamic>{
      'id': instance.id,
      'st': instance.st,
      'fee': instance.fee,
      'maxbr': instance.maxbr,
      'playMaxbr': instance.playMaxbr,
      'downloadMaxbr': instance.downloadMaxbr,
    };
