import 'package:flustars/flustars.dart';
import 'package:flutter_app/helper/http_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as ScreenUtil;

enum ImageMetadataType { png, jpg }
enum ImageFileType { none, music }

class ImageHelper {
  static String wrapAssets(String url,
      {ImageFileType fileType = ImageFileType.none,
      ImageMetadataType metadata = ImageMetadataType.png}) {
    var ext = '.png';
    var file = '';
    switch (fileType) {
      case ImageFileType.music:
        file = 'music/';
        break;
      default:
        file = '';
        break;
    }
    switch (metadata) {
      case ImageMetadataType.jpg:
        ext = '.jpg';
        break;
      default:
        ext = '.png';
        break;
    }
    return "assets/images/" + file + url + ext;
  }
  /// webp 地址
  static String wrapMusicWebp(String url) {
    return "assets/images/music/" + url + '.webp';
  }
  /// png 地址
  static String wrapMusicPng(String url) {
    return "assets/images/music/" + url + '.png';
  }
}

class ImageCompressHelper {
  /// 适用于 eyepetizer 的图片格式处理
  // ignore: non_constant_identifier_names
  static String eyepetizerCompress(String? value) {
    return value?.eyepetizer_compress_value() ?? '';
  }

  /// 适用于 music 的图片格式处理
  // ignore: non_constant_identifier_names
  static String musicCompress(String? value, double width, double height,
      {bool log = false}) {
    if (value == null) {
      return '';
    }
    var scale = ScreenUtil.ScreenUtil().pixelRatio.toInt();
    scale = scale > 3 ? 3 : scale;
    /// 将http 变为https
    value = HttpHelper.transform(value)!;
    // var compressUrl = value + '?param=${width.toInt() * scale}y${scale * height.toInt()}';
    /// 部分链接可能不适用
    /// https://p1.music.126.net/cUgTXrK1YNShD71q9_IP2Q==/109951165408839051.jpg?imageView=1&type=webp&thumbnail=180y180
    // var compressUrl = value +
    //     '?imageView=1&type=webp&thumbnail=${width.toInt() * scale}y${scale * height.toInt()}';
    var compressUrl = value +
        '?param=${width.toInt() * scale}y${scale * height.toInt()}';
    if (log) {
      LogUtil.v('compressUrl => $compressUrl');
    }
    return compressUrl;
  }
  /// 适用于 music 的图片格式处理 单一尺寸
  // ignore: non_constant_identifier_names
  static String musicSingCompress(String? value, double width, double height,
      {bool log = false}) {
    if (value == null) {
      return '';
    }
    var compressUrl = value +
        '?imageView=1&type=webp&thumbnail=${width.toInt()}y${height.toInt()}';
    if (log) {
      LogUtil.v('compressUrl => $compressUrl');
    }
    return compressUrl;
  }
  
}

extension ImageCompress on String {
  /// 适用于 eyepetizer  图片格式处理
  // ignore: non_constant_identifier_names
  String eyepetizer_compress_value() {
    bool isHttpUrl = this.startsWith("http://img.kaiyanapp.com/") ||
        this.startsWith("https://img.kaiyanapp.com/");
    bool isImageRes = this.contains(".png") ||
        this.contains(".jpeg") ||
        this.contains(".jpg") ||
        this.contains(".gif");

    if (isHttpUrl && isImageRes) {
      Uri uri = Uri.parse(this);
      String compressUrl = "http://${uri.host}${uri.path}?imageMogr2/thumbnail";
      if (!this.contains("?imageMogr2/quality")) {
        compressUrl = "$compressUrl/!30p";
      } else {
        compressUrl = "$compressUrl/!50p";
      }
      // LogUtil.v('compressUrl => $compressUrl');
      return compressUrl;
    }
    // LogUtil.v('no compressUrl => $this');
    return this;
  }
}
