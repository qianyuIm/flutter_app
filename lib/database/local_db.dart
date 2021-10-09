import 'package:flustars/flustars.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'local_db_helper.dart';
import 'music_current_playing_db.dart';
import 'music_history_playing_db.dart';
import 'music_lyric_db.dart';
import 'music_play_list_category_db.dart';
import 'music_previous_playing_db.dart';
import 'user_playlist_db.dart';
import 'user_preset_grid_db.dart';
import 'internal_video_category_db.dart';

class LocalDb {
  Database? _database;

  /// 历史播放db
  MusicHistoryPlayingDb? _historyPlayingDb;

  /// 之前播放db
  MusicPreviousPlayingDb? _previousPlayingDb;

  /// 当前播放db
  MusicCurrentPlayingDb? _currentPlayingDb;

  ///internal Video Category db
  InternalVideoCategoryDb? _internalVideoCategoryDb;

  /// 用户预设网格db
  UserPresetGridDb? _userPresetGridDb;

  /// 歌单广场 Category db
  MusicPlaylistCategoryDb? _playlistCategoryDb;

  /// 歌词 db
  MusicLyricDb? _musicLyricDb;

  /// 用户歌单
  UserPlaylistDb? _userPlaylistDb;

  /// 历史播放db
  MusicHistoryPlayingDb get historyPlayingDb => _historyPlayingDb!;

  /// 之前播放db
  MusicPreviousPlayingDb get previousPlayingDb => _previousPlayingDb!;

  /// 当前播放db
  MusicCurrentPlayingDb get currentPlayingDb => _currentPlayingDb!;

  ///internal Video Category db
  InternalVideoCategoryDb get internalVideoCategoryDb =>
      _internalVideoCategoryDb!;

  /// 用户预设网格db
  UserPresetGridDb get userPresetGridDb => _userPresetGridDb!;

  /// 歌单广场 Category db
  MusicPlaylistCategoryDb get playlistCategoryDb => _playlistCategoryDb!;

  /// 歌词 db
  MusicLyricDb get musicLyricDb => _musicLyricDb!;

  /// 用户歌单
  UserPlaylistDb get userPlaylistDb => _userPlaylistDb!;

  late LocalDBPlayingHelper dbHelper;

  LocalDb() {
    dbHelper = LocalDBPlayingHelper();
  }

  static LocalDb instance = LocalDb();

  /// 初始化
  Future<void> initDb({String name = "flutter_app.db"}) async {
    if (_database != null) return;
    var databasesDirectory = await getTemporaryDirectory();
    String dbPath = path.join(databasesDirectory.path, name);
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        LogUtil.v('创建表');
        var batch = db.batch();

        /// 创建表
        batch.execute(MusicCurrentPlayingDb.create_table_sql);
        batch.execute(MusicPreviousPlayingDb.create_table_sql);
        batch.execute(MusicHistoryPlayingDb.create_table_sql);
        batch.execute(MusicLyricDb.create_table_sql);
        batch.execute(UserPresetGridDb.create_table_sql);
        batch.execute(InternalVideoCategoryDb.create_table_sql);
        batch.execute(MusicPlaylistCategoryDb.create_table_sql);
        batch.execute(UserPlaylistDb.create_table_sql);
        await batch.commit(noResult: true);
      },
    );
    _historyPlayingDb = MusicHistoryPlayingDb(_database!);
    _previousPlayingDb = MusicPreviousPlayingDb(_database!);
    _currentPlayingDb = MusicCurrentPlayingDb(_database!);
    _internalVideoCategoryDb = InternalVideoCategoryDb(_database!);
    _userPresetGridDb = UserPresetGridDb(_database!);
    _playlistCategoryDb = MusicPlaylistCategoryDb(_database!);
    _musicLyricDb = MusicLyricDb(_database!);
    _userPlaylistDb = UserPlaylistDb(_database!);
    LogUtil.v('数据库初始化');
  }

  /// 关闭数据库
  Future<void> closeDb() async {
    await _database?.close();
    _database = null;
  }
}
