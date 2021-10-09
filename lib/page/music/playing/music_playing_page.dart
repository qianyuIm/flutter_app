import 'package:flutter/material.dart';
import 'package:flutter_app/page/music/playing/music_playing_comment_page.dart';
import 'package:flutter_app/page/music/playing/music_playing_operation_page.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

import 'music_playing_blue.dart';
import 'music_playing_detail_page.dart';
import 'music_playing_title.dart';

class MusicPlayingPage extends StatefulWidget {
  @override
  _MusicPlayingPageState createState() => _MusicPlayingPageState();
}

class _MusicPlayingPageState extends State<MusicPlayingPage> {

  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                MusicPlayingBlue(),
                Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      MusicPlayingTitle(),
                      QYSpacing(height: 10,),
                      Expanded(child: PageView(
                        controller: _pageController,
                        children: [
                          MusicPlayingDetailPage(),
                          MusicPlayingOperationPage(),
                          MusicPlayingCommentPage(),
                        ],
                      ))
                    ],
                  ),
                )
              ],
            )));
  }
}

