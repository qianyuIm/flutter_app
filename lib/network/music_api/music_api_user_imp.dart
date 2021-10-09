import 'package:flutter_app/config/qy_config.dart';
import 'package:flutter_app/helper/local_json_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'dart:convert';

/// music 用户相关接口
class MusicApiUserImp {
  /// 验证手机号
  static String kCheckPhoneUrl = '/cellphone/existence/check';

  /// 手机号密码登录
  static String kLoginCellphoneUrl = '/login/cellphone';

  /// 刷新登录
  static String kLoginRefreshUrl = 'login/refresh';

  /// 获取用户详情
  static String kUserDetailUrl = 'user/detail';

  /// 获取用户歌单
  static String kUserPlaylistUrl = 'user/playlist';

  /// 新建歌单
  static String kPlaylistCreateUrl = 'playlist/create';

  /// 调整歌单顺序
  static String kPlaylistOrderUpdateUrl = 'playlist/order/update';

  /// 删除歌单
  static String kPlaylistDeleteUrl = 'playlist/delete';

  /// 退出登录
  static String kLogoutUrl = '/logout';

  /// 验证手机号
  static Future<String> checkCellPhone(String phone) async {
    var response =
        await musicApi.get(kCheckPhoneUrl, queryParameters: {'phone': phone});
    int exist = response.data["exist"];
    return exist == 1 ? response.data["nickname"] : null;
  }

  /// 手机号密码登录
  static Future<MusicUser> phonePasswordLogin(
      String phone, String password) async {
    var response = await musicApi.get(kLoginCellphoneUrl,
        queryParameters: {'phone': phone, 'password': password});
    MusicUser user = MusicUser.fromJson(response.data);
    return user;
  }

  /// 刷新登录状态
  static Future loginRefresh() async {
    var response = await musicApi.get(kLoginRefreshUrl);
    return response;
  }

  /// 获取用户详细信息
  static Future<MusicUserDetail> loadUserDetailData(int uid) async {
    var response =
        await musicApi.get(kUserDetailUrl, queryParameters: {'uid': uid});

    return MusicUserDetail.fromJson(response.data);
  }

  /// 获取用户歌单限制1000条数据chao超出后需要在详情中查看
  /// 本地需要缓存
  /// limit和offset失效 需要去除cookie
  static Future<List<MusicPlayList>> loadUserPlaylistData(int uid,
      {int limit = 1000, int offset = 0}) async {
    if (QYConfig.isLocalJson) {
      await Future.delayed(QYConfig.localJsonDelayed);

      /// 本地数据
      var response =
          await LocalJsonHelper.localJson(LocalJsonType.music_user_playlist);

      var object = json.decode(response);
      return object['playlist']
          .map<MusicPlayList>((playlist) => MusicPlayList.fromJson(playlist))
          .toList();
    }
    var response = await musicApi.get(kUserPlaylistUrl, queryParameters: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });

    return response.data['playlist']
        .map<MusicPlayList>((playlist) => MusicPlayList.fromJson(playlist))
        .toList();
  }

  /// 新建歌单  type : 歌单类型,默认'NORMAL',传 'VIDEO'则为视频歌单
  static Future<MusicPlayList> loadPlaylistCreateData(String name,
      {bool privacy = false, String type = 'NORMAL'}) async {
    Map<String, dynamic> queryParameter = {'name': name, 'type': type};
    if (privacy) {
      queryParameter['privacy'] = 10;
    }
    var response =
        await musicApi.get(kPlaylistCreateUrl, queryParameters: queryParameter);

    return MusicPlayList.fromJson(response.data['playlist']);
  }

  /// 删除歌单
  static Future<bool> loadPlaylistDeleteData(List<int> ids) async {
    var query = ids.map((e) => e).join(',');
    var response = await musicApi.get(kPlaylistDeleteUrl, queryParameters: {
      'id': query,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    return response.data['code'] == 200;
  }

  /// 调整歌单顺序
  static Future<bool> loadPlaylistOrderUpdateData(List<int> ids) async {
    var query = ids.map((e) => e).join(',');
    query = '[' + query + ']';
    var response = await musicApi.get(kPlaylistOrderUpdateUrl,
        queryParameters: {
          'ids': query,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });

    return response.data['code'] == 200;
  }

  /// 退出登录
  static Future<bool> logout() async {
    var response = await musicApi.get(kLogoutUrl);
    return response.data['code'] == 200;
  }
}
