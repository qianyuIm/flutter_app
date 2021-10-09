import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/music/music_user_manager.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _countdownController;
  @override
  void initState() {
    
    /// 刷新用户状态
    var userManager = MusicUserManager.of(context);
    Future.wait([userManager.initialize()])
        .then((value) => {LogUtil.v('刷新完成')});
     _countdownController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _countdownController.forward();
    super.initState();
  }
@override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child:  Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor(context),
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 100,
              child: Image.asset(
                ImageHelper.wrapAssets('launch_logo'),
                width: 100,
              ),
            ),
            Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                openTabPage(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(100),
                  borderRadius: BorderRadius.circular(40)
                ),
                child: SplashAnimatedCountdown(
                  context: context,
                  animation: StepTween(begin: 4, end: 0).animate(_countdownController),
                ),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    ));
  }
}
/// 打开tab页面
void openTabPage(context) {
  ///  pushReplacementNamed 将当前页面替换，当前页面被销毁
  Navigator.of(context).pushReplacementNamed(MyRouterName.tab);
}
/// 倒计时按钮
class SplashAnimatedCountdown extends AnimatedWidget {
  final Animation<int> animation;
  SplashAnimatedCountdown({key, required this.animation, context})
      : super(key: key, listenable: animation) {
    this.animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        openTabPage(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var value = animation.value + 1;
    return Text(
      (value == 0 ? '' : '$value s ') + S.of(context).splashSkip,
      style: TextStyle(color: Colors.white),
    );
  }
}