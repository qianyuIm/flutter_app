


class HttpHelper {
  static String? transform(String? http) {
    if (http == null) {
      return http;
    }
    if (http.startsWith('http://')) {
      return http.replaceRange(0, 7, 'https://');
    }
    return http;
  }
}