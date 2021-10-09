class StringHelper {
  /// music home 地址
  static String wrapJsonHome(String jsonName) {
    return "assets/json/music_home/" + jsonName + '.json';
  }
  /// music search 地址
  static String wrapJsonSearch(String jsonName) {
    return "assets/json/music_search/" + jsonName + '.json';
  }
  /// music internal 地址
  static String wrapJsonInternal(String jsonName) {
    return "assets/json/music_internal/" + jsonName + '.json';
  }
  /// music comment 地址
  static String wrapJsonComment(String jsonName) {
    return "assets/json/music_comment/" + jsonName + '.json';
  }
  /// music dj 地址
  static String wrapJsonDj(String jsonName) {
    return "assets/json/music_dj/" + jsonName + '.json';
  }
  /// music play list 地址
  static String wrapJsonPlaylist(String jsonName) {
    return "assets/json/music_play_list/" + jsonName + '.json';
  }
  ///format number to local number. 保留一位小数
  ///example 10001 -> 1.0万
  ///        100 -> 100
  ///        11000-> 1.1万
  static String formateNumber(int? number) {
    if (number == null) {
      return '0';
    }
    if (number < 10000) {
      return number.toString();
    }
    var string = (number / 10000).toStringAsFixed(1);
    return "$string万";
  }
  /// 111 => 99+
  static String omit(int? number) {
    if (number == null) {
      return '';
    }
    if (number <= 99) {
      return '$number';
    }
    return '99+';
  }
  static String intString(int? number) {
    return number == null ? '' : '$number';
  }
  /// 换行符格式化为空格
  static String shifterFormateBlank(String? value) {
    if (value == null) {
      return '';
    }
    return value.replaceAll('\n', '  ');
  }
}
