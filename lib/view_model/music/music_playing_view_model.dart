import 'package:flutter_app/database/local_cache.dart';
import 'package:flutter_app/database/local_db_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/network/music_api/music_api_song_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';

/// 相似歌曲
class MusicPlayingSimiSongViewModel extends ViewStateModel {
  late List<MusicSong> songs;

  initData(MusicPlayingSource source,int songId) async {
    setBusy();
    try {
      /// 从数据库获取
      var local = await appLocalCache.getSimiSongs(songId);
      if (local == null) {
        songs = await MusicApiSongImp.loadSimiSongData(songId);
        /// 存入数据库
        appLocalCache.updateSimiSongs(source,songId, songs);
      } else {
        songs = local;
      }
      if (songs.isEmpty) {
        setEmpty();
      } else {
        setIdle();
      }
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 相似歌单
class MusicPlayingSimiPlaylistViewModel extends ViewStateModel {
  late List<MusicPlayList> playlists;

  initData(MusicPlayingSource source,int songId) async {
    setBusy();
    try {
      /// 从数据库获取
      var local = await appLocalCache.getSimiPlaylists(songId);
      if (local == null) {
        playlists = await MusicApiSongImp.loadSimiPlaylistData(songId);

        /// 存入数据库
        appLocalCache.updateSimiPlaylists(source,songId, playlists);
      } else {
        playlists = local;
      }
      if (playlists.isEmpty) {
        setEmpty();
      } else {
        setIdle();
      }
    } catch (e, s) {
      setError(e, s);
    }
  }
}
