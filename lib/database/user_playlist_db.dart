import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:sqflite/sqflite.dart';

/// 用户歌单db
class UserPlaylistDb {
  static const String table_name = "user_play_list_table";

  static const String create_table_sql = '''
CREATE TABLE $table_name (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	playlist_id INTEGER,
	trackCount INTEGER,
  highQuality INTEGER,
  privacy INTEGER,
  name TEXT,
  coverImgUrl TEXT,
  creator TEXT
);
''';
  final Database database;
  UserPlaylistDb(this.database);

  /// 插入全部
  Future<void> insertAll(List<MusicPlayList> playLists) async {
    /// 删除当前
    await clearAll();

    /// 加入
    var batch = database.batch();
    playLists.forEach((element) {
      batch.insert(table_name, element.toDBMap());
    });
    await batch.commit(noResult: true);
  }

  /// 查询全部
  Future<List<MusicPlayList>> queryAll() async {
    var map = await database.rawQuery("SELECT * "
        "FROM $table_name");
    return map.map((e) => MusicPlayList.fromDBMap(e)).toList();
  }

  Future<void> clearAll() async {
    return await database.execute("DELETE FROM $table_name");
  }
}
