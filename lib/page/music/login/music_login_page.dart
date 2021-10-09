import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/network/music_api/music_api_user_imp.dart';
import 'package:flutter_app/page/music/login/login_navigator.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';


class MusicLoginPage extends StatefulWidget {
  
  @override
  _MusicLoginPageState createState() => _MusicLoginPageState();
}

class _MusicLoginPageState extends State<MusicLoginPage> {
  late TextEditingController _editingController;
  bool _isEnable = false;
  @override
  void initState() {
    _editingController = TextEditingController();
    _editingController.addListener(() {
      _verifyMobile(_editingController.text);
    });
    MusicUserManager manager = MusicUserManager.of(context);
    manager.clear();
    super.initState();
  }

  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _verifyMobile(String mobile) {
    if (mobile.length == 0) return;
    if (mobile.substring(0, 1) == "1" && mobile.length == 11) {
      setState(() {
        _isEnable = true;
      });
    } else {
      setState(() {
        _isEnable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('手机号登录'),
        leading: CloseButton(onPressed: (){
          Navigator.of(context,rootNavigator: true).pop();
        },),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "请使用网易云音乐注册的手机号进行登录",
              style: AppTheme.subtitleStyle(context).copyWith(color: AppTheme.primaryColor(context)),
            ),
            _buildMobile(context),
            _buildSubmit(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobile(context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: AppTheme.subtitleColor(context)))),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              '+86',
              style: AppTheme.titleStyle(context),
            ),
          ),
          Expanded(
            child: TextField(
                controller: _editingController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "请输入手机号",
                  border: InputBorder.none,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildSubmit() {
    return Center(
      child: Container(
          padding: EdgeInsets.only(top: 40),
          child: QYButtom<String>(
            enable: _isEnable,
            width: Inchs.screenWidth - 50,
            height: Inchs.adapter(44),
            alignment: Alignment.center,
            color: AppTheme.primaryColor(context),
            borderRadius: BorderRadius.all(Radius.circular(Inchs.adapter(44))),
            title: Text(
              '下一步',
              style: AppTheme.titleStyle(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            loadingTitle: Text(
              '正在验证手机号',
              style: AppTheme.titleStyle(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: (state) {
              state.trackFuture(
                  MusicApiUserImp.checkCellPhone(_editingController.text));
            },
            successCallback: (nickName) {
              LogUtil.v('nickName => $nickName');
              Navigator.of(context).pushNamed(pageLoginPassword,
                  arguments: {
                    "nickName": nickName,
                    "mobile": _editingController.text,
                  });
            },
          )),
    );
  }
}
