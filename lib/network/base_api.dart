import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseApi extends DioForNative {
  BaseApi() {
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    /// 抓包代理
   /* (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      //这一段是解决安卓https抓包的问题
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      client.findProxy = (uri) {
        return "PROXY 192.168.31.184:8888";
      };
    };*/
    interceptors.add(BaseHeaderInterceptor());
    init();
  }
  void init();
}

class BaseHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.connectTimeout = 30 * 1000;
    options.receiveTimeout = 30 * 1000;
    handler.next(options);
  }
  
}
