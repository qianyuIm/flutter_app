import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/network/music_api/music_api.dart';

/// music song 相关接口
class MusicApiSongImp {
  ///  新歌速递
  static String kTopSongUrl = 'top/song';

  ///  全部新碟
  static String kAlbumNewUrl = 'album/new';

  /// 相似歌曲
  static String kSimiSongUrl = 'simi/song';
  /// 相似歌单 <=> 包含这首歌的歌单
  static String kSimiPlaylistUrl = '/simi/playlist';
  
  /// 专辑内容
  static String kAlbumUrl = 'album';


  /// 新歌速递
  /// 0: 全部
  /// 7: 华语
  /// 96: 欧美
  /// 8: 日本
  /// 16: 韩国
  static Future<List<MusicSong>> loadTopSongData({int type = 0}) async {
    var response =
        await musicApi.get(kTopSongUrl, queryParameters: {'type': type});
    return response.data['data']
        .map<MusicSong>((song) => MusicSong.fromJson(song))
        .toList();
  }

  /// 全部新碟
  /// area: ALL:全部,ZH:华语,EA:欧美,KR:韩国,JP:日本
  /// limit:
  /// offset:
  static Future loadAlbumNewData(String area, int limit, int offset) async {
    var response = await musicApi.get(kAlbumNewUrl,
        queryParameters: {'area': area, 'limit': limit, 'offset': offset});
    return response.data;
  }
  /// 相似歌曲 传入歌曲id
  static Future<List<MusicSong>> loadSimiSongData(int songId) async {
    var response = await musicApi.get(kSimiSongUrl,
        queryParameters: {'id': songId});
    return response.data['songs']
        .map<MusicSong>((song) => MusicSong.fromJson(song))
        .toList();
  }
  /// 相似歌单 <=> 包含这首歌的歌单 传入歌曲id
  static Future<List<MusicPlayList>> loadSimiPlaylistData(int songId) async {
    var response = await musicApi.get(kSimiPlaylistUrl,
        queryParameters: {'id': songId});
    return response.data['playlists']
        .map<MusicPlayList>((song) => MusicPlayList.fromJson(song))
        .toList();
  }
}
