/// 可选值安全解包
class StringOptionalHelper {
  /// 可选值 安全解包
  static bool hasValue(String? optional) {
    if (optional == null) {
      return false;
    }
    if (optional.isEmpty) {
      return false;
    }
    return true;
  }
}
class IntOptionalHelper {
  /// 可选值 安全解包
  static bool hasValue(int? optional) {
    if (optional == null) {
      return false;
    }
    return true;
  }
}
class ListOptionalHelper {
/// 可选值 安全解包
  static bool hasValue(List? optional) {
    if (optional == null) {
      return false;
    }
    if (optional.isEmpty) {
      return false;
    }
    return true;
  }
}