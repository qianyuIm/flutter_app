import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/music/dj/music_dj_personalized.dart';
import 'package:flutter_app/model/music/home/music_banner.dart';
import 'package:flutter_app/model/music/home/music_calendar.dart';
import 'package:flutter_app/model/music/home/music_per_new_song.dart';
import 'package:flutter_app/model/music/home/music_personalized.dart';
import 'package:flutter_app/model/music/home/music_privatecontent.dart';
import 'package:flutter_app/model/music/music_daily_recommend.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/network/music_api/music_api_home_imp.dart';
import 'package:flutter_app/provider/view_state_model.dart';

/// banner
class MusicBannerViewModel extends ViewStateModel {
  List<MusicBanner> banners = [];
  initData() async {
    setBusy();
    try {
      banners = await MusicApiHomeImp.loadBannerData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class MusicDailyRecommendViewModel extends ViewStateModel {
  late MusicDailyRecommend dailyRecommendItem;

  initData() async {
    setBusy();
    try {
      dailyRecommendItem = await MusicApi.loadkDailyRecommendSongsData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 推荐歌单  未登录
class MusicPersonalizedViewModel extends ViewStateModel {
  List<MusicPersonalized> personalizeds = [];

  initData() async {
    setBusy();
    try {
      personalizeds = await MusicApiHomeImp.loadPersonalizedData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

class MusicPersonalizedNewSongViewModel extends ViewStateModel {
  List<MusicPerNewSong> perNewSongs = [];

  initData() async {
    setBusy();
    try {
      perNewSongs = await MusicApiHomeImp.loadPersonalizedNewSongData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 独家放送
class MusicPrivateViewModel extends ViewStateModel {
  List<MusicPrivateContent> privateContents = [];

  initData() async {
    setBusy();
    try {
      privateContents = await MusicApiHomeImp.loadPrivatecontentData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 推荐MV
class MusicPersonalizedMVViewModel extends ViewStateModel {
  List<MusicMV> perMVs = [];

  initData() async {
    setBusy();
    try {
      perMVs = await MusicApiHomeImp.loadPersonalizedMvData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 推荐电台
class MusicPerDjProgramViewModel extends ViewStateModel {
  List<MusicDjPersonalized> djPersonalizeds = [];

  initData() async {
    setBusy();
    try {
      djPersonalizeds = await MusicApiHomeImp.loadPersonalizedDjProgramData();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}

/// 音乐日历
class MusicCalendarViewModel extends ViewStateModel {
  List<MusicCalendar> calendars = [];

  /// 时间间隔
  final Duration _interval = Duration(seconds: 6);

  /// 定时器
  late Stream clock;
  StreamSubscription? streamSubscription;
  bool destroy = false;

  double aboveRightMax = 20;
  double aboveBottomMax = 20;
  double opacity = 0.0;
  AnimationController? fadeController;
  Animation<double>? fadeAnimation;

  initData() async {
    setBusy();
    try {
      var startTime = TimeHelper.dayBegin();
      var endTime = TimeHelper.dayEnd();
      calendars = await MusicApiHomeImp.loadCalendarUrlData(
          startTime: startTime, endTime: endTime);
      if (calendars.isNotEmpty) {
        clock = Stream.periodic(_interval, (index) {});
        streamSubscription = clock.listen((event) {
          if (destroy) return;
          if (fadeController?.status == AnimationStatus.completed ||
              fadeController?.status == AnimationStatus.dismissed) {
            ///title和 above 渐隐，同时fake上移
            fadeController?.forward().whenComplete(() {
              right = aboveRightMax;
              bottom = aboveBottomMax;
              notifyListeners();

              ///更新index
              incrementIndex();

              ///插入新的below
              showBelow();
            });
          }
        });
        streamSubscription?.pause();
      }

      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }

  /// 定时器开始
  void resumeClock() {
    if (streamSubscription != null) {
      if (streamSubscription!.isPaused) streamSubscription!.resume();
    }
  }

  /// 定时器暂停
  void pauseClock() {
    if (streamSubscription != null) {
      if (!streamSubscription!.isPaused) streamSubscription!.pause();
    }
  }

  void showBelow() {
    Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (opacity >= 1.0) {
        timer.cancel();

        ///渐显above和title
        fadeController?.reverse().whenComplete(() {
          ///隐藏fake
          visible = false;
          notifyListeners();

          ///重置fake位置,显示fake
          right = 0;
          bottom = 0;
          visibleIndex =
              currentIndex <= calendars.length - 2 ? currentIndex + 1 : 0;
          visible = true;
          opacity = 0;
          notifyListeners();
        });
        return;
      }
      opacity = (opacity + 0.1).clamp(0.0, 1.0);
      notifyListeners();
    });
  }

  bool visible = true;
  int visibleIndex = 0;
  void animationListener() {
    if (fadeController?.status == AnimationStatus.forward) {
      if (!visible) visible = true;
      updatePosition();
    }
  }

  double right = 0;
  double bottom = 0;

  void updatePosition() {
    if (fadeAnimation == null) return;
    right = aboveRightMax * (1 - fadeAnimation!.value);
    bottom = aboveBottomMax * (1 - fadeAnimation!.value);
    notifyListeners();
  }

  int currentIndex = 0;
  void incrementIndex() {
    if (currentIndex == calendars.length - 1) {
      currentIndex = 0;
    } else {
      currentIndex++;
    }
    notifyListeners();
  }
}
