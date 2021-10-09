import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/qy_icon.dart';
import 'package:flutter_app/page/home/home_page.dart';
import 'package:flutter_app/page/music/home/music_page.dart';
import 'package:flutter_app/page/music/bottom/bottom_player_box_controller.dart';
import 'package:flutter_app/page/novel/novel_page.dart';
import 'package:flutter_app/page/user/user_page.dart';
import 'package:flutter_app/page/video/video_page.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

final List<Widget> _pages = <Widget>[
  HomePage(),
  MusicPage(),
  NovelPage(),
  VideoPage(),
  UserPage()
];

class TabNavigatorPage extends StatefulWidget {
  @override
  _TabNavigatorPageState createState() => _TabNavigatorPageState();
}

class _TabNavigatorPageState extends State<TabNavigatorPage> {
  late PageController _pageController;
  DateTime? _lastPressed;
  int _currentIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            _lastPressed = _lastPressed ?? DateTime.now();
            if (DateTime.now().difference(_lastPressed!) >
                Duration(seconds: 1)) {
              return false;
            }
            return true;
          },
          child:
           BottomPlayerBoxController(
             bottomPadding: false,
            child:
             PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pages.length,
              controller: _pageController,
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          ),
      // extendBody: true,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CustomNavigationBar(
      iconSize: 26.0,
      selectedColor: AppTheme.bottomNavigationBarThemeData(context).selectedItemColor!,
      strokeColor: AppTheme.bottomNavigationBarThemeData(context).selectedItemColor!,
      unSelectedColor: AppTheme.bottomNavigationBarThemeData(context).unselectedItemColor!,
      backgroundColor: AppTheme.bottomNavigationBarThemeData(context).backgroundColor!,
      items: [
        CustomNavigationBarItem(icon: Icon(QyIcon.tab_home)),
        CustomNavigationBarItem(icon: Icon(QyIcon.tab_music)),
        CustomNavigationBarItem(icon: Icon(QyIcon.tab_bookshelf)),
        CustomNavigationBarItem(icon: Icon(QyIcon.tab_video)),
        CustomNavigationBarItem(icon: Icon(QyIcon.tab_user))
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        _pageController.jumpToPage(index);
      },
    );
  }
}
