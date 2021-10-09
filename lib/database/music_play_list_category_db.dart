import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:sqflite/sqflite.dart';

/// 歌单 Category db
class MusicPlaylistCategoryDb {
  static const String table_name = "music_play_list_category_table";

  static const String create_table_sql = '''
CREATE TABLE $table_name (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	category TEXT,
  deletable INTEGER,
  fixed INTEGER,
  location INTEGER,
  artists TEXT
);
''';

  final Database database;
  MusicPlaylistCategoryDb(this.database);

  /// 插入
  Future<int> insert(MusicPlaylistSelectedItem selectedItem) async {
    return await database.insert(table_name, selectedItem.toDBMap());
  }

  /// 插入全部
  Future<int> insertAll(List<MusicPlaylistSelectedItem> selectedItems) async {
    /// 删除当前
    await clear();

    /// 加入
    var batch = database.batch();
    selectedItems.forEach((element) {
      batch.insert(table_name, element.toDBMap());
    });
    await batch.commit(noResult: true);
    return selectedItems.length;
  }

  /// 查询全部
  Future<List<MusicPlaylistSelectedItem>> queryAll() async {
    var map = await database.rawQuery("SELECT * "
        "FROM $table_name");
    return map.map((e) => MusicPlaylistSelectedItem.fromDBMap(e)).toList();
  }

  Future<void> clear() async {
    return await database.execute("DELETE FROM $table_name WHERE id > 0");
  }
}
