import 'dart:convert';

import 'package:flutter_app/helper/time_helper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' as convert;

part 'music_lyric.g.dart';

@JsonSerializable()
class MusicLyric {
  int? songId;
  @JsonKey(defaultValue: false)
  final bool sgc;
  @JsonKey(defaultValue: false)
  final bool sfy;
  @JsonKey(defaultValue: false)
  final bool qfy;
  MusicLrc? lrc;
  MusicKlyric? klyric;
  MusicTlyric? tlyric;

  MusicLyric(this.sgc, this.sfy, this.qfy);

  factory MusicLyric.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicLyricFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicLyricToJson(this);

  Map<String, dynamic> toDBMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song_id'] = this.songId;
    data['sgc'] = this.sgc == true ? 1 : 0;
    data['sfy'] = this.sfy == true ? 1 : 0;
    data['qfy'] = this.qfy == true ? 1 : 0;
    data['lrc'] = convert.jsonEncode(this.lrc);
    data['klyric'] = convert.jsonEncode(this.klyric);
    data['tlyric'] = convert.jsonEncode(this.tlyric);

    return data;
  }

  factory MusicLyric.fromDBMap(Map<String, dynamic> json) {
    return MusicLyric(
      json['sgc'] == 1,
      json['sfy'] == 1,
      json['qfy'] == 1,
    )
      ..songId = json['song_id'] as int?
      ..lrc = json['lrc'] == 'null'
          ? null
          : MusicLrc.fromJson(
              convert.jsonDecode(json['lrc']) as Map<String, dynamic>)
      ..klyric = json['klyric'] == 'null'
          ? null
          : MusicKlyric.fromJson(
              convert.jsonDecode(json['klyric']) as Map<String, dynamic>)
      ..tlyric = json['tlyric'] == 'null'
          ? null
          : MusicTlyric.fromJson(
              convert.jsonDecode(json['tlyric']) as Map<String, dynamic>);
  }
}

@JsonSerializable()
class MusicLrc {
  int version;
  String? lyric;
  MusicLrc({int? version}) : this.version = version ?? 0;
  factory MusicLrc.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicLrcFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicLrcToJson(this);
}

@JsonSerializable()
class MusicKlyric {
  int version;
  String? lyric;
  MusicKlyric({int? version}) : this.version = version ?? 0;
  factory MusicKlyric.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicKlyricFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicKlyricToJson(this);
}

@JsonSerializable()
class MusicTlyric {
  int version;
  String? lyric;
  MusicTlyric({int? version}) : this.version = version ?? 0;
  factory MusicTlyric.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicTlyricFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MusicTlyricToJson(this);
}

/// 出自：https://github.com/boyan01/flutter-netease-music
/// 歌词处理结果
class MusicLyricContent {
  ///splitter lyric content to line
  static const LineSplitter _SPLITTER = const LineSplitter();
  //默认歌词持续时间
  static const int _default_line_duration = 5 * 1000;

  MusicLyricContent.from(String lyric) {
    List<String> lines = _SPLITTER.convert(lyric);
    Map<int, String> map = {};
    lines.forEach((l) => LyricEntry.inflate(l, map));
    List<int> keys = map.keys.toList()..sort();
    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      _durations.add(key);
      int duration = _default_line_duration;
      if (i + 1 < keys.length) {
        duration = keys[i + 1] - key;
      }
      _lyricEntries.add(LyricEntry(map[key]!, key, duration));
    }
  }

  List<int> _durations = [];
  List<LyricEntry> _lyricEntries = [];

  int get size => _durations.length;

  LyricEntry operator [](int index) {
    return _lyricEntries[index];
  }

  int _getTimeStamp(int index) {
    return _durations[index];
  }

  LyricEntry? getLineByTimeStamp(final int timeStamp, final int anchorLine) {
    if (size <= 0) {
      return null;
    }
    final line = findLineByTimeStamp(timeStamp, anchorLine);
    return this[line];
  }

  ///
  ///根据时间戳来寻找匹配当前时刻的歌词
  ///
  ///@param timeStamp  歌词的时间戳(毫秒)
  ///@param anchorLine the start line to search
  ///@return index to getLyricEntry
  ///
  int findLineByTimeStamp(final int timeStamp, final int anchorLine) {
    int position = anchorLine;
    if (position < 0 || position > size - 1) {
      position = 0;
    }
    if (_getTimeStamp(position) > timeStamp) {
      //look forward
      while (_getTimeStamp(position) > timeStamp) {
        position--;
        if (position <= 0) {
          position = 0;
          break;
        }
      }
    } else {
      while (_getTimeStamp(position) < timeStamp) {
        position++;
        if (position <= size - 1 && _getTimeStamp(position) > timeStamp) {
          position--;
          break;
        }
        if (position >= size - 1) {
          position = size - 1;
          break;
        }
      }
    }
    return position;
  }

  @override
  String toString() {
    return 'Lyric{_lyricEntries: $_lyricEntries}';
  }
}

class LyricEntry {
  static RegExp pattern = RegExp(r"\[\d{2}:\d{2}.\d{2,3}]");

  static int _stamp2int(final String stamp) {
    final int indexOfColon = stamp.indexOf(":");
    final int indexOfPoint = stamp.indexOf(".");

    final int minute = int.parse(stamp.substring(1, indexOfColon));
    final int second =
        int.parse(stamp.substring(indexOfColon + 1, indexOfPoint));
    int millisecond;
    if (stamp.length - indexOfPoint == 2) {
      millisecond =
          int.parse(stamp.substring(indexOfPoint + 1, stamp.length)) * 10;
    } else {
      millisecond =
          int.parse(stamp.substring(indexOfPoint + 1, stamp.length - 1));
    }
    return ((((minute * 60) + second) * 1000) + millisecond);
  }

  ///build from a .lrc file line .such as: [11:44.100] what makes your beautiful
  static void inflate(String line, Map<int, String> map) {
    if (line.startsWith("[ti:")) {
    } else if (line.startsWith("[ar:")) {
    } else if (line.startsWith("[al:")) {
    } else if (line.startsWith("[au:")) {
    } else if (line.startsWith("[by:")) {
    } else {
      var stamps = pattern.allMatches(line);
      var content = line.split(pattern).last;
      stamps.forEach((stamp) {
        int timeStamp = _stamp2int(stamp.group(0) ?? '');
        map[timeStamp] = content;
      });
    }
  }

  LyricEntry(this.line, this.position, this.duration)
      : this.timeStamp = TimeHelper.getTimeStamp(position);

  final String timeStamp;
  final String line;

  final int position;

  ///the duration of this line
  final int duration;

  @override
  String toString() {
    return 'LyricEntry{line: $line, timeStamp: $timeStamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricEntry &&
          runtimeType == other.runtimeType &&
          line == other.line &&
          timeStamp == other.timeStamp;

  @override
  int get hashCode => line.hashCode ^ timeStamp.hashCode;
}
