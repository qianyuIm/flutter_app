import 'package:flutter_app/model/music/music_lyric.dart';
import 'package:sqflite/sqflite.dart';


/// 歌词 db
class MusicLyricDb {
  
  static const String table_name = "music_lyric_table";
  
  static const String create_table_sql = '''
CREATE TABLE $table_name (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	song_id INTEGER,
  sgc INTEGER,
  sfy INTEGER,
  qfy INTEGER,
  lrc TEXT,  
  klyric TEXT,
  tlyric TEXT
);
''';
  final Database database;
  MusicLyricDb(this.database);

  /// 插入
  Future<int> insert(MusicLyric lyric) async {
    return await database.insert(
        table_name, lyric.toDBMap());
  }

  // ignore: non_constant_identifier_names
  Future<MusicLyric?> queryOne(int song_id) async {
    List<Map<String, dynamic>> maps = await database.rawQuery(
        "select * from $table_name where song_id = $song_id");
    if (maps.isEmpty) return null;
     //插入方法
    var list = maps.map((e) => MusicLyric.fromDBMap(e)).toList();
    
    return list.first;
  }

  Future<void> clearAll() async {
    return await database
        .execute("DELETE FROM $table_name");
  }
}
