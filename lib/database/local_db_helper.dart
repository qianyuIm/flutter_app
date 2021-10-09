import 'package:flustars/flustars.dart';
import 'package:flutter_app/config/sp_config.dart';

final unknownSoleSource = MusicPlayingSource(kUndefinedValue);

enum MusicPlayingSourceType {
  /// 未知
  unknown,
  /// 首页推荐新音乐
  perNewSong,

  /// 歌单
  playlist,

  /// 相似歌曲
  similarSong
}

/// 播放来源
class MusicPlayingSource {
  /// 歌单id
  final int soleId;

  /// 歌单名称 可能为null 非歌单页面进入
  String? soleName;

  /// 来源枚举
  MusicPlayingSourceType soleType;

  MusicPlayingSource(this.soleId,
      {this.soleType = MusicPlayingSourceType.unknown, this.soleName});

  factory MusicPlayingSource.fromJson(Map<String, dynamic> json) {
    return MusicPlayingSource(json['soleId'] as int? ?? kUndefinedValue)
      ..soleName = json['soleName'] as String?
      ..soleType = MusicPlayingSourceType.values[json['soleType']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['soleId'] = this.soleId;
    json['soleName'] = this.soleName;
    json['soleType'] = this.soleType.index;
    return json;
  }

  bool operator ==(Object other) {
    return other is MusicPlayingSource &&
        this.soleId == other.soleId &&
        this.soleName == other.soleName &&
        this.soleType == other.soleType;
  }

  /// 判断是否显示
  bool get display => soleName != null;

  /// 是否定义
  bool get define => soleName != null && soleId != kUndefinedValue;

  @override
  int get hashCode => soleId.hashCode ^ soleName.hashCode ^ soleType.hashCode;
}

class LocalDBPlayingHelper {
  late MusicPlayingSource _currentSource;
  late MusicPlayingSource _previousSource;
  late MusicPlayingSource _historySource;

  /// 当前歌单播放位置
  late int _currentPlayingIndex;

  MusicPlayingSource get currentSource => _currentSource;
  MusicPlayingSource get previousSource => _previousSource;
  MusicPlayingSource get historySource => _historySource;

  int get currentPlayingIndex => _currentPlayingIndex;

  LocalDBPlayingHelper() {
    _currentSource = SpUtil.getObj<MusicPlayingSource>(
        SpConfig.playingCurrentSourceKey,
        (srcJson) =>
            MusicPlayingSource.fromJson(srcJson as Map<String, dynamic>),
        defValue: unknownSoleSource)!;

    _previousSource = SpUtil.getObj<MusicPlayingSource>(
        SpConfig.playingPreviousSourceKey,
        (srcJson) =>
            MusicPlayingSource.fromJson(srcJson as Map<String, dynamic>),
        defValue: unknownSoleSource)!;

    _historySource = SpUtil.getObj<MusicPlayingSource>(
        SpConfig.playingHistorySourceKey,
        (srcJson) =>
            MusicPlayingSource.fromJson(srcJson as Map<String, dynamic>),
        defValue: unknownSoleSource)!;

    _currentPlayingIndex = SpUtil.getInt(SpConfig.currentPlayingIndexKey,
        defValue: kUndefinedValue)!;
  }

  /// 更新来源
  void updateSource(MusicPlayingSource source) {
    _historySource = _previousSource;
    _previousSource = _currentSource;
    _currentSource = source;
    _put();
  }

  /// 重置来源
  void resetSource() {
    _currentSource = unknownSoleSource;
    if (_previousSource != unknownSoleSource) {
      _currentSource = _previousSource;
      _previousSource = unknownSoleSource;
    } else {
      if (_historySource != unknownSoleSource) {
        _currentSource = _historySource;
        _historySource = unknownSoleSource;
      }
    }
    updatePlayingIndex(0);
    _put();
  }

  /// 重置来源
  void resetPreviousSource() {
    _previousSource = unknownSoleSource;
    SpUtil.putObject(SpConfig.playingPreviousSourceKey, _previousSource);
  }

  /// 重置来源
  void resetHistorySource() {
    _historySource = unknownSoleSource;
    SpUtil.putObject(SpConfig.playingHistorySourceKey, _historySource);
  }

  void updatePlayingIndex(int index) {
    _currentPlayingIndex = index;
    SpUtil.putInt(SpConfig.currentPlayingIndexKey, index);
  }

  void _put() {
    SpUtil.putObject(SpConfig.playingCurrentSourceKey, _currentSource);
    SpUtil.putObject(SpConfig.playingPreviousSourceKey, _previousSource);
    SpUtil.putObject(SpConfig.playingHistorySourceKey, _historySource);
  }
}
