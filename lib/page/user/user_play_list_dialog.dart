
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/page/user/user_create_play_list.dart';
import 'package:flutter_app/page/user/user_play_list_section.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/qy_toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserPlaylistDialog extends StatelessWidget {
  final List<int> tracks;

  const UserPlaylistDialog({Key? key, required this.tracks}) : super(key: key);

  static Future show(BuildContext context, List<int> tracks) async {
    final result = await showCustomModalBottomSheet(
      expand: false,
      context: context,
      builder: (context) {
        return UserPlaylistDialog(tracks: tracks);
      },
      containerWidget: (_, animation, child) => Container(
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var userManager = MusicUserManager.of(context);
    if (!userManager.isLogin) {
      return _buildNeedLogin(context);
    }
    return Material(
        color: Colors.transparent,
        child: ProviderWidget<UserPlaylistViewModel>(
          viewModel: UserPlaylistViewModel(userManager),
          onModelReady: (viewModel) => viewModel.initData(),
          builder: (context, viewModel, child) {
            return _buildLogin(context, viewModel);
          },
        ));
  }

  Widget _buildNeedLogin(BuildContext context) {
    var primaryColor = AppTheme.of(context).primaryColor;
    return Material(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: Container(
        child: SafeArea(
          top: false,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QYSpacing(
                  height: 20,
                ),
                Text(
                  '需要登录',
                  style: AppTheme.titleStyle(context),
                ),
                QYSpacing(
                  height: 10,
                ),
                QYButtom(
                  width: 170,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  title: Text(
                    '前往登陆页面',
                    style: AppTheme.subtitleStyle(context)
                        .copyWith(color: primaryColor),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor),
                  onPressed: (state) {
                    Navigator.of(context).pushNamed(MyRouterName.music_login);
                  },
                ),
                QYSpacing(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogin(BuildContext context, UserPlaylistViewModel viewModel) {
    return Material(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: Container(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right),
        child: SafeArea(
          top: false,
          child: Container(
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QYSpacing(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '收藏到歌单',
                      style:
                          AppTheme.titleStyle(context).copyWith(fontSize: 16),
                    ),
                    QYButtom(
                      absorbOnMove: true,
                      width: 90,
                      height: 30,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      title: Text(
                        '+ 新建歌单',
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: AppTheme.subtitleColor(context)),
                      onPressed: (state) {
                        Navigator.of(context).pop();
                        UserCreatePlaylist.show(context);
                      },
                    ),
                  ],
                ),
                QYSpacing(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: ModalScrollController.of(context),
                  itemCount: viewModel.createdPlayList.length,
                  itemBuilder: (context, index) {
                    var playList = viewModel.createdPlayList[index];
                    return PlaylistTile(
                      playList: playList,
                      enableBottomRadius: false,
                      enableNickName: false,
                      onPressed: () {
                        viewModel
                            .handlePlaylistTracks(
                                targetId: playList.id, tracks: tracks)
                            .then((value) {
                          Navigator.of(context).pop();
                          var message = value ? '加入完成' : '歌单歌曲重复';
                          QYToast.showSuccess(context, message);
                        }, onError: (Object error, s) {
                          ViewStateModel model = ViewStateModel();
                          model.setError(error, s);
                          QYToast.showError(
                              context, model.viewStateError?.message);
                        });
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
