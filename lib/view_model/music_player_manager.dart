import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/model/music/music_lyric.dart';
import 'package:flutter_app/model/music/music_metadata.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/model/music/music_song.dart';

enum MusicPlayMode {
  /// 顺序
  sequence,

  /// 单首
  single,

  /// 随机
  shuffle,
}
enum MusicPlayingListType {
  /// 当前播放
  current,

  /// 上次播放
  previous,

  /// 历史播放
  history
}

extension MusicPlayModeGetNext on MusicPlayMode {
  MusicPlayMode get next {
    if (this == MusicPlayMode.sequence) {
      return MusicPlayMode.single;
    } else if (this == MusicPlayMode.single) {
      return MusicPlayMode.shuffle;
    }
    return MusicPlayMode.sequence;
  }
}

extension MusicPlayingListTypeGetTitle on MusicPlayingListType {
  String get title {
    if (this == MusicPlayingListType.current) {
      return '当前播放';
    } else if (this == MusicPlayingListType.previous) {
      return '上次播放';
    }
    return '历史播放';
  }
}

/// 每个播放的Item数据
class MusicPlayerItem {
  final int index;
  final MusicPlayingSource source;
  final MusicSong song;

  MusicPlayerItem(
      {required this.index, required this.source, required this.song});
}

class MusicPlayerManager extends ChangeNotifier {
  /// 推荐新音乐对应的歌单id
  static int perNewSongSoleId = 1;

  /// 排行榜中 赞赏歌曲
  static int rewardSoleId = 2;

  AudioPlayer _audioPlayer = AudioPlayer();

  /// 播放模式
  MusicPlayMode _playMode = MusicPlayMode.sequence;
  MusicPlayMode get playMode => _playMode;

  /// 手动处理歌词
  MusicLyricContent? _lyricContent;
  String _lyricMessage = '暂无歌词';
  String get lyricMessage => _lyricMessage;
  MusicLyricContent? get lyric => _lyricContent;

  /// 外部标记使用
  String? previouLyric;

  /// 是否有歌词
  bool get hasLyric => lyric != null && (lyric?.size ?? 0) > 0;

  /// 当前播放列表
  List<MusicSong> _currentPlaySongs = [];

  /// 当前播放的歌曲
  MusicSong get currentSong => _currentPlaySongs[_currentIndex];
  List<MusicSong> get currentPlaySongs => _currentPlaySongs;

  /// 当前播放位置
  int _currentIndex = kUndefinedValue;

  /// 当前歌曲所处位置
  int get currentIndex => _currentIndex;

  /// source改变的通知
  ValueNotifier<MusicPlayingSource>? onPlayingSourceChangedNotifier =
      ValueNotifier(unknownSoleSource);

  /// 当前播放来源 需要等待初始化
  late MusicPlayingSource _playingSource;
  MusicPlayingSource get playingSource => _playingSource;

  /// 设置source 如旧
  void setPlayingSource(MusicPlayingSource source) {
    _playingSource = source;
    onPlayingSourceChangedNotifier?.value = source;
  }

  /// 当前播放歌曲id
  int _currentSongId = kUndefinedValue;

  /// 歌曲总时长
  Duration _duration = Duration.zero;

  /// 歌曲总时长

  Duration get duration => _duration;

  /// 当前播放进度
  Duration _position = Duration.zero;

  /// 当前播放进度
  Duration get position => _position;

  /// 歌曲总时长
  var _durationText = "00:00";

  /// 歌曲总时长
  get durationText => _durationText;

  /// 当前播放时长
  var _positionText = "00:00";

  /// 当前播放时长
  get positionText => _positionText;

  /// 是否完成初始化
  bool _isInitialize = false;
  String get playModeImage {
    if (_playMode == MusicPlayMode.sequence) {
      return ImageHelper.wrapMusicPng(
            'music_playing_loop',
          );
    } else if (_playMode == MusicPlayMode.single) {
      return ImageHelper.wrapMusicPng(
            'music_playing_one',
          );
    } else {
      return ImageHelper.wrapMusicPng('music_playing_shuffle');
    }
  }

  /// 数据源改变时通知
  ValueNotifier<bool>? onDataSourceChangedNotifier = ValueNotifier(false);

  /// 播放进度
  double _playProgress = 0.0;

  /// 播放进度
  double get playProgress => _playProgress;

  /// 播放状态
  PlayerState _playerState = PlayerState.STOPPED;

  /// 播放状态
  PlayerState get playerState => _playerState;

  /// 是否处于缓冲状态
  bool get isBuffering {
    if (_hasPlayingOperation) return playerState == PlayerState.STOPPED;
    return (playerState == PlayerState.STOPPED && _hasPlayingOperation);
  }

  /// 是否已经有过播放的操作
  bool _hasPlayingOperation = false;

  /// 准备阶段 播放状态
  bool get isPrepare =>
      (playerState == PlayerState.PAUSED || playerState == PlayerState.STOPPED);

  /// 播放阶段 播放状态
  bool get isPlaying => playerState == PlayerState.PLAYING;

  /// item 改变监听
  Stream<MusicPlayerItem> get onPlayerItemChanged =>
      _playerItemController.stream;

  /// item 改变监听
  final StreamController<MusicPlayerItem> _playerItemController =
      StreamController<MusicPlayerItem>.broadcast();

  /// 状态监听
  Stream<PlayerState> get onPlayerStateChanged =>
      _playerStateController.stream.distinct();

  /// 播放状态监听
  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();

  /// 当前播放总时长监听
  Stream<Duration> get onPlayerDurationChanged =>
      _playerDurationController.stream;

  /// 当前播放总时长监听
  final StreamController<Duration> _playerDurationController =
      StreamController<Duration>.broadcast();

  /// 当前播放进度监听
  Stream<Duration> get onPlayerPositionChanged =>
      _playerPositionController.stream;

  /// 当前播放进度监听
  final StreamController<Duration> _playerPositionController =
      StreamController<Duration>.broadcast();

  final TargetPlatform platform;

  /// 初始化
  MusicPlayerManager({required this.platform}) {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      var durationResult = _duration.toString().split('.').first;
      List<String> durationList = durationResult.split(":");
      _durationText = durationList[1] + ":" + durationList[2];
      _playerDurationController.add(duration);
    });
    _audioPlayer.onAudioPositionChanged.listen((position) {
      _position = position;
      var positionResult = _position.toString().split('.').first;
      List<String> durationList = positionResult.split(":");
      _positionText = durationList[1] + ":" + durationList[2];
      if (_duration.inMilliseconds != 0) {
        _playProgress = _position.inMilliseconds / _duration.inMilliseconds;
        _playProgress = _playProgress > 1.0 ? 1.0 : playProgress;
      }
      _playerPositionController.add(position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      _playerStateController.add(state);
      if (state == PlayerState.COMPLETED) {
        skipToNext();
      }
    });
  }

  static MusicPlayerManager of(BuildContext context, {bool listen = false}) {
    return Provider.of<MusicPlayerManager>(context, listen: listen);
  }

  @override
  void dispose() {
    _playerStateController.close();
    _playerItemController.close();
    _playerPositionController.close();
    _playerDurationController.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 是否有数据源
  bool get hasData {
    assert(_isInitialize, '必须调用入口启动函数 initialize()');
    return _currentPlaySongs.isNotEmpty;
  }

  /// 初始化数据 入口函数
  Future<bool> initialize() async {
    if (_isInitialize) return _currentPlaySongs.isNotEmpty;
    _currentPlaySongs = await LocalDb.instance.currentPlayingDb.queryAll();
    setPlayingSource(LocalDb.instance.dbHelper.currentSource);
    _currentIndex = LocalDb.instance.dbHelper.currentPlayingIndex;
    if (_currentPlaySongs.isNotEmpty) {
      _currentSongId = currentSong.id;
    }
    _isInitialize = true;
    onDataSourceChangedNotifier?.value = _currentPlaySongs.isNotEmpty;
    return _currentPlaySongs.isNotEmpty;
  }

  /// 当前是否播放
  bool isPlayingFor(MusicSong song, {int? soleId, MusicPlayingListType? type}) {
    var result = isPlaying &&
        _currentSongId == song.id &&
        playingSource.soleId == (soleId ?? playingSource.soleId) &&
        MusicPlayingListType.current == (type ?? MusicPlayingListType.current);
    return result;
  }

  /// 是否相同
  bool equalWith(MusicSong song, {int? soleId, MusicPlayingListType? type}) {
    var result = (_currentSongId == song.id) &&
        playingSource.soleId == (soleId ?? playingSource.soleId) &&
        MusicPlayingListType.current == (type ?? MusicPlayingListType.current);

    return result;
  }

  /// 获取全部播放列表
  Future<Map<MusicPlayingListType, List<MusicSong>>> getPlayingList() async {
    Map<MusicPlayingListType, List<MusicSong>> _map = {};
    _map[MusicPlayingListType.current] = _currentPlaySongs;
    var previous = await LocalDb.instance.previousPlayingDb.queryAll();
    if (previous.isNotEmpty) {
      _map[MusicPlayingListType.previous] = previous;
    }

    var history = await LocalDb.instance.historyPlayingDb.queryAll();

    if (history.isNotEmpty) {
      _map[MusicPlayingListType.history] = history;
    }
    return _map;
  }

  /// 从当前播放列表中移除
  Future<void> removeCurrentPlayingAt(int index) async {
    /// 判断
    if (index == _currentIndex) {
      _currentIndex = index;
    } else if (index < _currentIndex) {
      _currentIndex -= 1;
    }
    _currentPlaySongs.removeAt(index);

    /// 更新数据库
    await LocalDb.instance.currentPlayingDb.updateAll(_currentPlaySongs);
    await playWithSongs(playingSource, _currentPlaySongs, _currentIndex);
    if (_currentSongId == currentSong.id) {
      notifyListeners();
    }
  }

  /// 移除列表
  Future<void> removePlaylist(MusicPlayingListType type) async {
    switch (type) {
      case MusicPlayingListType.current:
        // 先暂停播放吧停止播放
        await _pause();
        var dbSongs = await LocalDb.instance.currentPlayingDb.reset();
        setPlayingSource(LocalDb.instance.dbHelper.currentSource);
        _currentIndex = 0;
        if (ListOptionalHelper.hasValue(dbSongs)) {
          _currentPlaySongs = dbSongs!;

          /// 更新歌单
          playWithSongs(playingSource, _currentPlaySongs, _currentIndex);
        } else {
          /// 更新底部
          _currentPlaySongs = [];
          onDataSourceChangedNotifier?.value = _currentPlaySongs.isNotEmpty;
          notifyListeners();
        }

        break;
      case MusicPlayingListType.previous:
        await LocalDb.instance.previousPlayingDb.clearAll();
        LocalDb.instance.dbHelper.resetPreviousSource();

        break;
      case MusicPlayingListType.history:
        await LocalDb.instance.historyPlayingDb.clearAll();
        LocalDb.instance.dbHelper.resetHistorySource();
        break;
    }
  }

  void setPlayMode(MusicPlayMode playMode) {
    _playMode = playMode;
    notifyListeners();
  }

  /// 获取来源
  MusicPlayingSource sourceFor(MusicPlayingListType type) {
    switch (type) {
      case MusicPlayingListType.current:
        return LocalDb.instance.dbHelper.currentSource;
      case MusicPlayingListType.previous:
        return LocalDb.instance.dbHelper.previousSource;
      case MusicPlayingListType.history:
        return LocalDb.instance.dbHelper.historySource;
    }
  }

  /// 获取播放列表
  Future<List<MusicSong>> playingSongsFor(MusicPlayingListType type) async {
    switch (type) {
      case MusicPlayingListType.current:
        return _currentPlaySongs;
      case MusicPlayingListType.previous:
        return await LocalDb.instance.previousPlayingDb.queryAll();
      case MusicPlayingListType.history:
        return await LocalDb.instance.historyPlayingDb.queryAll();
    }
  }

  /// 从本地开始播放
  Future<void> localPlay() async {
    if (hasData) {
      _currentPlaySongs = await LocalDb.instance.currentPlayingDb.queryAll();
      _currentIndex = LocalDb.instance.dbHelper.currentPlayingIndex;
      _play();
    }
  }

  

  /// 播放列表
  /// 需要手动移除不可播放的音乐
  Future<void> playWithSongs(
      MusicPlayingSource source, List<MusicSong> songs, int index) async {
    /// 系统的 listEquals(a, b)
    bool isEquals = IterableEquality().equals(songs, _currentPlaySongs);
    if (playingSource != source || !isEquals) {
      LogUtil.v('更新数据库');
      await LocalDb.instance.currentPlayingDb.insert(source, songs);
      setPlayingSource(source);
    }
    if (index < 0) index = songs.length - 1;
    if (index >= songs.length) index = 0;
    _currentPlaySongs = songs;
    _currentIndex = index;
    LocalDb.instance.dbHelper.updatePlayingIndex(index);
    onDataSourceChangedNotifier?.value = _currentPlaySongs.isNotEmpty;
    await _play();
  }

  /// 更新播放位置
  Future<void> playWithListType(MusicPlayingListType type,
      {int index = 0}) async {
    if (type == MusicPlayingListType.current) {
      playIndex(index);
    } else {
      var songs = await playingSongsFor(type);
      playWithSongs(sourceFor(type), songs, index);
    }
  }

  /// 播放当前source指定位置的歌曲
  /// 可以在完成之后更新数据
  Future<void> playIndex(int index) async {
    if (index < 0) index = _currentPlaySongs.length - 1;
    if (index >= _currentPlaySongs.length) index = 0;
    LocalDb.instance.dbHelper.updatePlayingIndex(index);
    _currentIndex = index;
    await _play();
  }

  /// 播放
  void play() {
    _play();
  }

  /// 上一首
  void skipToPrevious() {
    _previousIndex();
    _play();
  }

  /// 下一首
  void skipToNext() {
    _nextIndex();
    _play();
  }

  /// 暂停歌曲
  void pause() {
    _pause();
  }

  /// 继续歌曲
  void resume() {
    _resume();
  }

  /// 更新播放进度
  void seek(double value) {
    final position = value * _duration.inMilliseconds;
    _seek(position);
  }

  void _nextIndex() {
    int index = _currentIndex + 1;
    index = index == _currentPlaySongs.length ? 0 : index;
    LocalDb.instance.dbHelper.updatePlayingIndex(index);
    _currentIndex = index;
  }

  void _previousIndex() {
    int index = _currentIndex - 1;
    index = index < 0 ? _currentPlaySongs.length - 1 : index;
    LocalDb.instance.dbHelper.updatePlayingIndex(index);
    _currentIndex = index;
  }

  Future<int> _resume() async {
    return await _audioPlayer.resume();
  }

  Future<int> _pause() async {
    return await _audioPlayer.pause();
  }

  Future<int> _seek(double position) async {
    return _audioPlayer.seek(Duration(milliseconds: position.round()));
  }

  Future<int> _play() async {
    _hasPlayingOperation = true;
    if (_currentSongId == currentSong.id &&
        playerState == PlayerState.PLAYING) {
      LogUtil.v('同一首歌曲不做任何操作');
      return -1;
    }

    /// 清空下歌词
    currentSong.lyric = null;
    _lyricContent = null;
    previouLyric = null;
    _lyricMessage = '加载歌词中...';
    await _audioPlayer.stop();
    _currentSongId = currentSong.id;

    var item = MusicPlayerItem(
        index: _currentIndex, source: playingSource, song: currentSong);
    _playerItemController.add(item);

    /// 请求歌曲URL
    List<MusicMetadata> metadatas =
        await MusicApi.loadSongUrlData(currentSong.id);
    currentSong.metadata = metadatas.first;

    /// 更新
    LocalDb.instance.currentPlayingDb.update(currentSong);

    /// 请求歌曲歌词
    if (currentSong.lyric == null) {
      MusicLyric lyricItem = await MusicApi.loadSongLyricData(currentSong.id);
      String? lyric = lyricItem.lrc?.lyric;
      if (lyric != null && lyric.isNotEmpty) {
        _lyricContent = MusicLyricContent.from(lyric);
      } else {
        _lyricContent = null;
      }
      if (_lyricContent?.size == 0) {
        _lyricContent = null;
      }
      if (_lyricContent == null) {
        _lyricMessage = '暂无歌词';
      }
      currentSong.lyric = lyricItem;
      await LocalDb.instance.currentPlayingDb.update(currentSong);
    }
    var audioUrl = currentSong.metadata?.url;
    if (audioUrl != null) {
      return await _audioPlayer.play(audioUrl, isLocal: false);
    } else {
      LogUtil.v('播放失误');
      return -1;
    }
  }
}
