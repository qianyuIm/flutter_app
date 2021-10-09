import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/helper/launch_helper.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/widget/gradient_text.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/rect_indicator.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isLastPage = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    /// 预加载网络图片
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _introItems.forEach((element) {
        precacheImage(NetworkImage(element.imageUrl), context);
      });
    });
    _pageController = PageController();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF485563), Color(0xFF29323C)],
                tileMode: TileMode.clamp,
                begin: Alignment.topCenter,
                stops: [0.0, 1.0],
                end: Alignment.bottomCenter)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                itemCount: _introItems.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        var introItem = _introItems[index];
                        var delta;
                        var y = 1.0;
                        if (_pageController.position.haveDimensions) {
                          delta = _pageController.page! - index;
                          y = 1.0 - delta.abs().clamp(0.0, 1.0);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ImageLoadView(
                                imagePath: introItem.imageUrl,
                                height: 200,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(left: 12.0),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.15,
                                    child: GradientText(
                                      data: introItem.title,
                                      gradient: LinearGradient(
                                        colors: introItem.titleGradient,
                                      ),
                                      style: TextStyle(
                                          fontSize: 100, letterSpacing: 1.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 30.0, left: 22.0),
                                    child: GradientText(
                                      data: introItem.title,
                                      gradient: LinearGradient(
                                        colors: introItem.titleGradient,
                                      ),
                                      style: TextStyle(fontSize: 70),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 34.0, top: 12.0),
                                child: Transform(
                                    transform: Matrix4.translationValues(
                                        0, 50.0 * (1 - y), 0),
                                    child: Text(introItem.body,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFF9B9B9B))))),
                          ],
                        );
                      });
                },
                onPageChanged: (value) {
                  debugPrint('移动到 == $value ');
                  setState(() {
                    _currentPage = value;
                    if (_currentPage == _introItems.length - 1) {
                      _isLastPage = true;
                      _animationController.forward();
                    } else {
                      _isLastPage = false;
                      _animationController.reset();
                    }
                  });
                },
              ),

              /// indicator
              Positioned(
                left: 30.0,
                bottom: 55.0,
                child: RectIndicator(
                  position: _currentPage,
                  count: _introItems.length,
                ),
              ),
              Positioned(
                right: 30,
                bottom: 30,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Visibility(
                    visible: _isLastPage,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_forward, color: Colors.black),
                      onPressed: () {
                        LaunchHelper.storage();
                        Navigator.of(context).pushReplacementNamed(MyRouterName.splash);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


var _introItems = [
  IntroItem(
      imageUrl:
          'https://gitee.com/qianyuIm/public/raw/master/images/intro-music.png',
      title: "MUSIC",
      body: "EXPERIENCE WICKED PLAYLISTS",
      titleGradient: _gradients[0]),
  IntroItem(
      imageUrl:
          'https://gitee.com/qianyuIm/public/raw/master/images/intro-spa.png',
      title: "SPA",
      body: "FEEL THE MAGIC OF WELLNESS",
      titleGradient: _gradients[1]),
  IntroItem(
      imageUrl:
          'https://gitee.com/qianyuIm/public/raw/master/images/intro-travel.png',
      title: "TRAVEL",
      body: "LET'S HIKE UP",
      titleGradient: _gradients[2]),
];

List<List<Color>> _gradients = [
  [Color(0xFF9708CC), Color(0xFF43CBFF)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class IntroItem {
  final String imageUrl;
  final String title;
  final String body;
  List<Color> titleGradient;
  IntroItem(
      {required this.imageUrl,
      required this.title,
      required this.body,
      required this.titleGradient});
}
