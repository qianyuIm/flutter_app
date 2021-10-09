import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:sqflite/sqflite.dart';

/// 当前播放 db
class MusicCurrentPlayingDb {
  static const String table_name = "music_current_playing_table";

  static const String create_table_sql = '''
CREATE TABLE $table_name (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	song_id INTEGER,
  name TEXT,
  pst INTEGER,
  album TEXT,
  artists TEXT,  
  metadata TEXT,
  privilege TEXT,
  lyric TEXT,
  publishTime INTEGER,
  mvId INTEGER,
  high TEXT,
  normal TEXT,
  low TEXT
);
''';
  final Database database;

  MusicCurrentPlayingDb(this.database);

  /// 插入数据
  Future<void> insert(MusicPlayingSource source, List<MusicSong> songs) async {
    if (songs.isEmpty) {
      return;
    }

    /// 先判断当前是否有播放
    var current = await queryAll();
    /// 当前歌单个数不同时候需要更新
    if (LocalDb.instance.dbHelper.currentSource == source &&
        current.length != songs.length) {
      /// 更新当前
      updateAll(songs);
      return;
    }

    /// 先判断当前是否有播放
    var previous = await queryAll();
    LocalDb.instance.dbHelper.updateSource(source);

    /// 加入到
    if (previous.isEmpty) {
      var batch = database.batch();
      songs.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);
    } else {
      /// 把之前的加入到 musicPreviousPlayingDao
      await LocalDb.instance.previousPlayingDb.insert(previous);

      /// 删除当前
      await _clearAll();

      /// 加入
      var batch = database.batch();
      songs.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);
    }
  }

  /// 更新
  Future<void> updateAll(List<MusicSong> songs) async {
    /// 删除当前
    await _clearAll();
    var batch = database.batch();
    songs.forEach((element) {
      batch.insert(table_name, element.toDBMap());
      
    });
    await batch.commit(noResult: true);
  }

  /// 更新
  Future<int> update(MusicSong song) async {
    return await database.update(table_name, song.toDBMap(),
        where: "song_id = ?", whereArgs: [song.id]);
  }

  /// 查询全部
  Future<List<MusicSong>> queryAll() async {
    var current = await database.rawQuery("SELECT * "
        "FROM $table_name");
    return current.map((e) => MusicSong.fromDBMap(e)).toList();
  }

  // ignore: non_constant_identifier_names
  Future<MusicSong?> queryOne(int song_id) async {
    List<Map<String, dynamic>> maps = await database
        .rawQuery("select * from $table_name where song_id = $song_id");
    if (maps.isEmpty) return null;
    //插入方法
    var list = maps.map((e) => MusicSong.fromDBMap(e)).toList();

    return list.first;
  }

  /// 重置当前还需要将之前的导入
  Future<List<MusicSong>?> reset() async {
    /// 移除当前
    await database.execute("DELETE FROM $table_name");
    LocalDb.instance.dbHelper.resetSource();

    /// 获取之前的数据
    var previous = await LocalDb.instance.previousPlayingDb.queryAll();
    if (previous.isEmpty) {
      /// 获取历史数据
      var history = await LocalDb.instance.historyPlayingDb.queryAll();
      if (history.isEmpty) return null;
      var batch = database.batch();
      history.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);

      /// 删除历史数据
      await LocalDb.instance.historyPlayingDb.clearAll();
      return history;
    } else {
      var batch = database.batch();
      previous.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);

      /// 删除之前的数据
      await LocalDb.instance.previousPlayingDb.clearAll();
      return previous;
    }
  }

  /// 删除当前
  Future<void> _clearAll() async {
    return await database.execute("DELETE FROM $table_name");
  }
}
