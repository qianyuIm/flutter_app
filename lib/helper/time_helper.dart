import 'package:flustars/flustars.dart';

const int _MINUTE = 60; // 1分钟
const int _HOUR = 60 * _MINUTE; // 1小时
const int _DAY = 24 * _HOUR; // 1天
const int _MONTH = 31 * _DAY; // 月
const int _YEAR = 12 * _MONTH; // 年

class TimeHelper {
  ///获取今天的开始时间戳
  static int dayBegin(){
    var nowTime = DateTime.now();
    var day = new DateTime(nowTime.year, nowTime.month, nowTime.day, 0,  0, 0);
    return day.millisecondsSinceEpoch;
  }
  ///获取今天的结束时间戳
  static int dayEnd(){
    var nowTime = DateTime.now();
    var day = new DateTime(nowTime.year, nowTime.month, nowTime.day, 23,  59, 59);
    return day.millisecondsSinceEpoch;
  }
  ///获取昨天的开始时间戳
  static int yesterdayBegin(){
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(new Duration(days: -1));
    var day = new DateTime(yesterday.year, yesterday.month, yesterday.day, 0,  0, 0);
    return day.millisecondsSinceEpoch;
  }
  ///获取昨天的结束时间戳
  static int yesterDayEnd(){
    var nowTime = DateTime.now();
    var yesterday = nowTime.add(new Duration(days: -1));
    var day = new DateTime(yesterday.year, yesterday.month, yesterday.day, 23,  59, 59);
    return day.millisecondsSinceEpoch;
  }
  /// 当前时间戳
  static int now() {
    var nowTime = DateTime.now();
    return nowTime.millisecondsSinceEpoch;
  }
  /// 返回当日 天数  dd => 18
  static String day() {
    return DateUtil.formatDate(DateTime.now(), format: 'dd');
  }

  ///  ex: yyyy年MM月dd日
  static String formatDateMs(int? timeMillis, {String? format}) {
    if (timeMillis == null) {
      return '未知时间';
    }
    return DateUtil.formatDateMs(timeMillis, format: format);
  }

  /// 格式化 => 刚刚, xx秒前,
  static String format(int? timeMillis) {
    if (timeMillis == null) {
      return '未知时间';
    }
    if (timeMillis < 0) return '未知时间';
    var currentMills = DateTime.now().millisecondsSinceEpoch;
    int seconds = (currentMills - timeMillis) ~/ 1000;
    if (seconds <= 0) {
      return "刚刚";
    }

    if (seconds < 60) {
      return "${seconds.toString()}秒前";
    }

    int minutes = seconds ~/ _MINUTE;
    if (seconds < 60) {
      return "${minutes.toString()}分钟前";
    }

    int hours = seconds ~/ _HOUR;
    if (hours < 24) {
      return "${hours.toString()}小时前";
    }

    int days = seconds ~/ _DAY;
    if (days < 31) {
      return "${days.toString()}天前";
    }

    int months = seconds ~/ _MONTH;
    if (months < 12) {
      return "${months.toString()}月前";
    }

    int years = seconds ~/ _YEAR;
    return "${years.toString()}年前";
  }

  ///format milliseconds to time stamp like "06:23", which
  ///means 6 minute 23 seconds
  static String getTimeStamp(int? milliseconds) {
    if (milliseconds == null) {
      return '00:00';
    }
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
