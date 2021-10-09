import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// 本地缓存
LocalCache appLocalCache = LocalCache.instance;

Database? _db;

/// application local cache database
Future<Database> getLocalCacheDatabase() async {
  if (_db == null) {
    _db = await databaseFactoryIo.openDatabase(
      join(
          (await getTemporaryDirectory()).path, 'LocalCache', 'local_cache.db'),
    );
  }
  return _db!;
}

const String _dbCurrentSimiSongsSourceKey =
    'db_playing_current_simi_songs_source_key';
const String _dbCurrentSimiPlaylistsSourceKey =
    'db_playing_current_simi_playlists_source_key';

const String _dbCurrentSimiPlaylistKey = 'db_playing_current_simi_playlist_key';
const String _dbCurrentSimiSongKey = 'db_playing_current_simi_song_key';

final _unknownSource = MusicPlayingSource(kUndefinedValue);

class _LocalCacheHelper {
  /// 来源
  late MusicPlayingSource _currentSimiSongsSource;
  late MusicPlayingSource _currentSimiPlaylistsSource;

  List<String> currentSimiPlaylistKeys = [];
  List<String> currentSimiSongKeys = [];

  MusicPlayingSource get currentSimiSongsSource => _currentSimiSongsSource;
  MusicPlayingSource get currentSimiPlaylistsSource =>
      _currentSimiPlaylistsSource;

  _LocalCacheHelper() {
    _currentSimiSongsSource = SpUtil.getObj<MusicPlayingSource>(
        _dbCurrentSimiSongsSourceKey,
        (srcJson) =>
            MusicPlayingSource.fromJson(srcJson as Map<String, dynamic>),
        defValue: _unknownSource)!;
    _currentSimiPlaylistsSource = SpUtil.getObj<MusicPlayingSource>(
        _dbCurrentSimiPlaylistsSourceKey,
        (srcJson) =>
            MusicPlayingSource.fromJson(srcJson as Map<String, dynamic>),
        defValue: _unknownSource)!;
    currentSimiPlaylistKeys =
        SpUtil.getStringList(_dbCurrentSimiPlaylistKey, defValue: [])!;
    currentSimiSongKeys =
        SpUtil.getStringList(_dbCurrentSimiSongKey, defValue: [])!;
  }

  /// 更新
  void updateSimiPlaylistsSource(MusicPlayingSource source) {
    if (_currentSimiPlaylistsSource != source) {
      _currentSimiPlaylistsSource = source;
      SpUtil.putObject(
          _dbCurrentSimiPlaylistsSourceKey, _currentSimiPlaylistsSource);
    }
  }

  /// 更新
  void updateSimiSongsSource(MusicPlayingSource source) {
    if (_currentSimiSongsSource != source) {
      _currentSimiSongsSource = source;
      SpUtil.putObject(_dbCurrentSimiSongsSourceKey, _currentSimiSongsSource);
    }
  }

  /// 更新
  void updateSimiPlaylistKeys(List<String> keys) {
    currentSimiPlaylistKeys = keys;
    SpUtil.putStringList(_dbCurrentSimiPlaylistKey, currentSimiPlaylistKeys);
  }

  /// 更新
  void updateSimiSongKeys(List<String> keys) {
    currentSimiSongKeys = keys;
    SpUtil.putStringList(_dbCurrentSimiSongKey, currentSimiSongKeys);
  }
}

/// 本地存储  不需要建表
/// dynamic 原因是数组格式不兼容导致的
class LocalCache {
  late _LocalCacheHelper _helper;
  LocalCache() {
    _helper = _LocalCacheHelper();
  }

  static LocalCache instance = LocalCache();

  Future get(dynamic key) async {
    final Database db = await getLocalCacheDatabase();
    return await StoreRef.main().record(key).get(db);
  }

  Future put(dynamic key, dynamic value) async {
    final Database db = await getLocalCacheDatabase();
    var result = StoreRef.main().record(key).put(db, value);
    return result;
  }

  /// 删除对应key的记录
  Future deleteSingle(dynamic key) async {
    final Database db = await getLocalCacheDatabase();
    var result = await StoreRef.main().record(key).delete(db);
    LogUtil.v('result => $result');
    return result;
  }

  /// 删除对应key的记录
  Future deleteList(List keys) async {
    if (keys.isEmpty) return null;
    final Database db = await getLocalCacheDatabase();
    var results = await StoreRef.main().records(keys).delete(db);
    LogUtil.v('results => $results');
    return results;
  }
}

extension PlayingSimiPlaylistLocal on LocalCache {
  /// 更新对应的相似歌曲
  Future updateSimiPlaylists(MusicPlayingSource source, int songId,
      List<MusicPlayList> playlists) async {
    var key = 'simiPlaylists_$songId';
    /// 判断是否应该移除
    if (_helper.currentSimiPlaylistsSource != source) {
      _helper.updateSimiPlaylistsSource(source);
      /// 移除
      var listKey = _helper.currentSimiPlaylistKeys;
      await deleteList(listKey);
      _helper.updateSimiPlaylistKeys([]);
    }

    /// 加入到记录中
    if (!_helper.currentSimiPlaylistKeys.contains(key)) {
      _helper.currentSimiPlaylistKeys.add(key);
      _helper.updateSimiPlaylistKeys(_helper.currentSimiPlaylistKeys);
    }
    var value = playlists.map((p) => p.toDBMap()).toList();
    put(key, value);
  }

  /// 获取对应的相似歌曲
  Future<List<MusicPlayList>?> getSimiPlaylists(int songId) async {
    var key = 'simiPlaylists_$songId';
    var result = await get(key);
    if (result == null) {
      return null;
    }
    return (result as List)
        .cast<Map>()
        .map((json) => MusicPlayList.fromDBMap(json))
        .toList();
  }
}

extension PlayingSimiSongsLocal on LocalCache {
  /// 更新对应的相似歌曲
  Future updateSimiSongs(
      MusicPlayingSource source, int songId, List<MusicSong> songs) async {
    var key = 'simiSongs_$songId';

    /// 判断是否应该移除
    if (_helper.currentSimiSongsSource != source) {
      _helper.updateSimiSongsSource(source);

      /// 移除
      var listKey = _helper.currentSimiSongKeys;
      await deleteList(listKey);
      _helper.updateSimiSongKeys([]);
    }

    /// 加入到记录中
    if (!_helper.currentSimiSongKeys.contains(key)) {
      _helper.currentSimiSongKeys.add(key);
      _helper.updateSimiSongKeys(_helper.currentSimiSongKeys);
    }
    var value = songs.map((p) => p.toDBMap()).toList();
    put(key, value);
  }

  /// 获取对应的相似歌曲
  Future<List<MusicSong>?> getSimiSongs(int songId) async {
    var key = 'simiSongs_$songId';
    var result = await get(key);
    if (result == null) {
      return null;
    }
    return (result as List)
        .cast<Map>()
        .map((json) => MusicSong.fromDBMap(json))
        .toList();
  }
}
