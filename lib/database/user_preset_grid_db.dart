import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:sqflite/sqflite.dart';

/// user  预设网格db
class UserPresetGridDb {
  static const String table_name = "user_preset_grid_table";

  static const String create_table_sql = '''
CREATE TABLE $table_name (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	categoryItem TEXT,
	deletable INTEGER,
  fixed INTEGER,
  location INTEGER
);
''';
  final Database database;
  UserPresetGridDb(this.database);

  /// 插入
  Future<int> insert(UserPresetGridSelectedItem selectedItem) async {
    return await database.insert(table_name, selectedItem.toDBMap());
  }

  /// 插入全部
  Future<void> insertAll(List<UserPresetGridSelectedItem> selectedItems) async {
    /// 删除当前
    await clearAll();
    /// 加入
    var batch = database.batch();
    selectedItems.forEach((element) {
      batch.insert(table_name, element.toDBMap());
    });
    await batch.commit(noResult: true);
  }

  /// 查询全部
  Future<List<UserPresetGridSelectedItem>> queryAll() async {
    var map = await database.rawQuery("SELECT * "
        "FROM $table_name");
    return map.map((e) => UserPresetGridSelectedItem.fromDBMap(e)).toList();
  }

  Future<void> clearAll() async {
    return await database.execute("DELETE FROM $table_name");
  }
}
