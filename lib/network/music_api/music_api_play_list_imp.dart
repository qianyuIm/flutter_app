import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_play_list_container.dart';
import 'package:flutter_app/model/music/music_playlist_categorie.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'dart:convert';

/// 歌单相关数据
class MusicApiPlaylistImp {
  /// 歌单分类
  static String kPlaylistCatlistUrl = '/playlist/catlist';

  ///  热门歌单分类
  static String kPlaylistHotUrl = 'playlist/hot';

  /// 分类歌单
  static String kTopPlaylistUrl = '/top/playlist';

  /// 歌单详情
  static String kPlayListDetailUrl = '/playlist/detail';

  /// 歌单收藏者
  static String kPlaylistSubscribersUrl = 'playlist/subscribers';

  /// 对歌单进行增加或者删除(需要登录)
  static String kPlaylistTracksUrl = 'playlist/tracks';

  /// 歌曲详情
  static String kSongsDetailUrl = '/song/detail';

  /// 歌单全部分类数据
  static Future<MusicPlaylistCategorieContainer>
      loadPlaylistCatlistData() async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response = await LocalJsonHelper.localJson(
          LocalJsonType.music_play_list_categorys);
      var object = json.decode(response);
      return MusicPlaylistCategorieContainer.fromJson(object);
    }

    var response = await musicApi.get(kPlaylistCatlistUrl);
    return MusicPlaylistCategorieContainer.fromJson(response.data);
  }

  /// 热门歌单分类
  static Future<List<MusicPlaylistCategorie>> loadPlaylistHotData() async {
    var response = await musicApi.get(kPlaylistHotUrl);
    return response.data['tags']
        .map<MusicPlaylistCategorie>(
            (hot) => MusicPlaylistCategorie.fromJson(hot))
        .toList();
  }

  /// 分类歌单 cat -> kPlaylistCatlist
  static Future<MusicPlaylistContainer> loadTopPlaylistData(
      {String cat = '全部', int limit = 30, int offset = 0}) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_top_play_list);
      var object = json.decode(response);
      return MusicPlaylistContainer.fromJson(object);
    }

    var response = await musicApi.get(kTopPlaylistUrl,
        queryParameters: {'cat': cat, 'limit': limit, 'offset': offset});
    return MusicPlaylistContainer.fromJson(response.data);
  }

  /// 歌单详情数据
  static Future<MusicPlayList> loadPlayListData(int id, int s) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_play_list_detail);
      var object = json.decode(response);
      return MusicPlayList.fromJson(object['playlist']);
    }
    var response = await musicApi
        .get(kPlayListDetailUrl, queryParameters: {'id': '$id', 's': '$s'});
    return MusicPlayList.fromJson(response.data['playlist']);
  }

  /// 歌单收藏者数据
  static Future loadPlaylistSubscribersData(int playlistId, int offset,
      {int limit = 30}) async {
    var response = await musicApi.get(kPlaylistSubscribersUrl,
        queryParameters: {
          'id': '$playlistId',
          'offset': '$offset',
          'limit': '$limit'
        });
    return response.data;
  }

  /// 对自己的歌单进行增加或删除
  /// op: add 增加， del 删除
  /// targetId: 目标歌单 id
  /// tracks: 歌曲 id,可多个,用逗号隔开
  static Future loadPlaylistTracksData(
      {String op = 'add', required int targetId, required List<int> tracks}) async {
    var query = tracks.map((e) => e).join(',');
    var response = await musicApi.get(kPlaylistTracksUrl,
        queryParameters: {'op': op, 'pid': targetId, 'tracks': query});
    return response.data;
  }

  /// 歌单详情 items 数据
  static Future<List<MusicSong>> loadPlayListSongsData(List<int> ids) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_play_list_songs);
      var object = json.decode(response);
      var privileges = object['privileges']
          .map<MusicPrivilege>(
              (privilege) => MusicPrivilege.fromJson(privilege))
          .toList() as List<MusicPrivilege>;
      var map = object['songs'] as List<dynamic>;
      return map.asMap().keys.map<MusicSong>((index) {
        var song = map[index];
        var songItem = MusicSong.fromJson(song);
        songItem.privilege = privileges[index];
        return songItem;
      }).toList();
    }
    var query = ids.map((e) => e).join(',');
    var response =
        await musicApi.get(kSongsDetailUrl, queryParameters: {'ids': query});
    var privileges = response.data['privileges']
        .map<MusicPrivilege>((privilege) => MusicPrivilege.fromJson(privilege))
        .toList() as List<MusicPrivilege>;
    var map = response.data['songs'] as List<dynamic>;
    return map.asMap().keys.map<MusicSong>((index) {
      var song = map[index];
      var songItem = MusicSong.fromJson(song);
      songItem.privilege = privileges[index];
      return songItem;
    }).toList();
  }
}
