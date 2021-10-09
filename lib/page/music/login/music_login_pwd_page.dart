import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/qy_toast.dart';

class MusicLoginPwdPage extends StatefulWidget {
  final String nickName;
  final String mobile;

  /// 入口路由
  // final String entranceRouter;
  const MusicLoginPwdPage(
      {Key? key,
      required this.nickName,
      required this.mobile,
      })
      : super(key: key);
  @override
  _MusicLoginPwdPageState createState() => _MusicLoginPwdPageState();
}

class _MusicLoginPwdPageState extends State<MusicLoginPwdPage> {
  late TextEditingController _editingController;

  bool _isEnable = false;
  @override
  void initState() {
    _editingController = TextEditingController();
    _editingController.addListener(() {
      if (_editingController.text.length > 0 && _isEnable == false) {
        setState(() {
          _isEnable = true;
        });
      }
      if (_editingController.text.length == 0) {
        setState(() {
          _isEnable = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('手机号登录'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildPassword(context),
            _buildSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(widget.nickName + ' 您好');
  }

  Widget _buildPassword(context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: AppTheme.subtitleColor(context)))),
      child: TextField(
          controller: _editingController,
          autofocus: true,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "请输入密码",
            border: InputBorder.none,
          )),
    );
  }

  Widget _buildSubmit(context) {
    MusicUserManager manager = MusicUserManager.of(context);
    return Center(
      child: Container(
          padding: EdgeInsets.only(top: 40),
          child: QYButtom<MusicUserDetail>(
            enable: _isEnable,
            width: Inchs.screenWidth - 50,
            height: Inchs.adapter(44),
            alignment: Alignment.center,
            color: AppTheme.primaryColor(context),
            borderRadius: BorderRadius.all(Radius.circular(Inchs.adapter(44))),
            title: Text(
              '登录',
              style: AppTheme.titleStyle(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            loadingTitle: Text(
              '正在登录...',
              style: AppTheme.titleStyle(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: (state) {
              state.trackFuture(
                  manager.phoneLogin(widget.mobile, _editingController.text));
            },
            successCallback: (musicUser) {
              if (musicUser.code != 200) {
                QYToast.showError(context, '服务器异常，请稍后重试');
              } else {
                QYToast.showSuccess(context, "欢迎来到iMusic");
                Navigator.of(context,rootNavigator: true).pop();                
              }
            },
            failureCallback: (error) {
              QYToast.showError(context, error.errorMessage);
            },
          )),
    );
  }

  
}
