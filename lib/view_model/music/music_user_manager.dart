import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/sp_config.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/network/music_api/music_api_user_imp.dart';
import 'package:provider/provider.dart';

/// 登录状态
class MusicUserManager extends ChangeNotifier {
  MusicUserDetail? _userDetail;

  static MusicUserManager of(BuildContext context, {bool listen = false}) {
    return Provider.of<MusicUserManager>(context, listen: listen);
  }

  MusicUserManager();

  /// 刷新用户状态，在启动页操作
  Future<void> initialize() async {
    _userDetail = SpUtil.getObj<MusicUserDetail>(SpConfig.currentMusicUserKey,
        (srcJson) => MusicUserDetail.fromJson(srcJson as Map<String, dynamic>));
    if (_userDetail != null) {
      /// 访问api，刷新登录状态
      await MusicApiUserImp.loginRefresh().then((value) async {
        /// 刷新用户
        _userDetail = await MusicApiUserImp.loadUserDetailData(
            _userDetail!.profile!.userId!);
        LogUtil.v('刷新用户状态成功');
      }, onError: (error) {
        logout();
        LogUtil.v('刷新用户状态失败');
      });
    }
  }

  /// 是否登录
  bool get isLogin => _userDetail != null;

  /// 用户信息
  MusicUserDetail? get userDetail => _userDetail;

  /// 手机号密码登录
  Future<MusicUserDetail> phoneLogin(String phone, String password) async {
    final user = await MusicApiUserImp.phonePasswordLogin(phone, password);
    final detail = await MusicApiUserImp.loadUserDetailData(user.account!.id);

    /// 保存
    if (detail.code == 200) {
      _saveUser2Storage(detail);
      notifyListeners();
    }
    return detail;
  }

  /// 退出登录
  Future<bool> logout() async {
    bool result = await MusicApiUserImp.logout();
    if (result) {
      clear();
      notifyListeners();
    }
    return result;
  }

  /// 清空信息
  void clear() {
    _userDetail = null;
    SpUtil.remove(SpConfig.currentMusicUserKey);
  }

  void _saveUser2Storage(MusicUserDetail user) async {
    _userDetail = user;
    SpUtil.putObject(SpConfig.currentMusicUserKey, user);
  }
}
