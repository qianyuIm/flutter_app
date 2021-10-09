
/// 页面状态类型
enum ViewState {
  idle,
  busy, //加载中
  empty, //无数据
  error, //加载失败
}

/// 错误类型
enum ViewStateErrorType {
  defaultError,
  networkTimeOutError, //网络错误
  unauthorizedError, // 未登录
}

class ViewStateError {
  late ViewStateErrorType _errorType;
  String? message;
  String errorMessage;
  ViewStateError(ViewStateErrorType? errorType,
      {this.message, required this.errorMessage}) {
    _errorType = errorType ?? ViewStateErrorType.defaultError;
    message ??= errorMessage;
  }
  ViewStateErrorType get errorType => _errorType;
  /// 是否为未授权
  bool get isUnauthorizedError => errorType == ViewStateErrorType.unauthorizedError;
}
