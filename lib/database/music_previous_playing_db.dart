import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:sqflite/sqflite.dart';

/// 之前播放 db
class MusicPreviousPlayingDb {
  static const String table_name = "music_previous_playing_table";
  
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

  MusicPreviousPlayingDb(this.database);

  Future<void> insert(List<MusicSong> songs) async {
    if (songs.isEmpty) {
      return;
    }

    /// 先判断当前是否有播放
    var previous = await queryAll();

    /// 加入到
    if (previous.isEmpty) {
      var batch = database.batch();
      songs.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);
    } else {
      /// 把之前的加入到 musicHistoryPlayingDao
      await LocalDb.instance.historyPlayingDb.insert(previous);

      /// 删除当前
      await clearAll();

      /// 加入
      var batch = database.batch();
      songs.forEach((element) {
        batch.insert(table_name, element.toDBMap());
      });
      await batch.commit(noResult: true);
    }
  }

  /// 查询全部
  Future<List<MusicSong>> queryAll() async {
    var songMaps = await database.rawQuery("SELECT * "
        "FROM $table_name");
    return songMaps.map((e) => MusicSong.fromDBMap(e)).toList();
  }

  Future<void> clearAll() async {
    return await database.execute("DELETE FROM $table_name");
  }
}
