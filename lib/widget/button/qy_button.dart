import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/view_state.dart';
import 'package:flutter_app/provider/view_state_model.dart';
import 'package:flutter_app/widget/qy_bounce.dart';

enum ImageAlignment { left, top, right, bottom }

typedef WaitingCallback<T> = void Function();
typedef SuccessCallback<T> = void Function(T);
typedef FailureCallback<T> = void Function(ViewStateError error);
typedef GestureTapCallback = void Function(_QYButtomState state);

class QYButtom<T> extends StatefulWidget {
  /// 文字
  final Widget? title;
  

  /// 图标
  final Widget? image;
  final Widget? loadingTitle;

  /// 加载中
  final Widget? loadingWidget;

  /// 背景色
  final Color color;

  /// 是否有反弹效果
  final bool isBounce;
  /// 用于移动控件中
  final bool absorbOnMove;
  
  /// 图标文字间距默认 6.0
  final double imageMargin;

  /// 图标位置默认 left
  final ImageAlignment imageAlignment;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;

  /// 抓取的是动画结束的时间点
  final GestureTapCallback? onPressed;
  final double? width;
  final double? height;
  final bool enable;
  final WaitingCallback<T>? waitingCallback;
  final SuccessCallback<T>? successCallback;
  final FailureCallback<T>? failureCallback;

  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;



  const QYButtom({
    Key? key,
    this.title,
    this.image,
    this.color = Colors.transparent,
    this.isBounce = true,
    this.absorbOnMove = false,
    this.imageAlignment = ImageAlignment.left,
    this.imageMargin = 4.0,
    this.margin,
    this.padding = const EdgeInsets.all(4),
    this.onPressed,
    this.loadingWidget,
    this.alignment,
    this.width,
    this.height,
    this.enable = true,
    this.waitingCallback,
    this.successCallback,
    this.failureCallback,
    this.loadingTitle, this.border, this.borderRadius,
  })  : assert((title != null || image != null), 'title和image不能同时为空'),
        super(key: key);

  @override
  _QYButtomState createState() => _QYButtomState<T>();
}

class _QYButtomState<T> extends State<QYButtom<T>> {
  late ConnectionState _connectionState;

  @override
  void initState() {
    _connectionState = ConnectionState.none;
    super.initState();
  }

  /// 监听请求
  void trackFuture(Future<T>? future) {
    if (future != null) {
      setState(() {
        _connectionState = ConnectionState.waiting;
      });
      widget.waitingCallback?.call();
      Future.delayed(Duration(milliseconds: 500), () {
        future.then<void>((T data) {
          widget.successCallback?.call(data);
          setState(() {
            _connectionState = ConnectionState.done;
          });
        }, onError: (Object error,s) {
          ViewStateModel model = ViewStateModel();
          model.setError(error, s);
          widget.failureCallback?.call(model.viewStateError!);
          setState(() {
            _connectionState = ConnectionState.done;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? image = widget.image;
    Widget? title = widget.title;
    Widget contentLayer = _buildNormalContent(title, image);
    Widget container = Container(
        decoration: BoxDecoration(
          color: widget.enable ? widget.color : widget.color.withOpacity(0.5,),
          borderRadius: widget.borderRadius,
          border: widget.border,
        ),
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        alignment: widget.alignment,
        child: Opacity(
          opacity: widget.enable ? 1.0 : 0.5,
          child: _connectionState == ConnectionState.waiting
              ? _buildLoadingContent()
              : contentLayer,
        ),
      );
    if (!widget.isBounce) {
      return InkWell(
        onTap: widget.enable == false
          ? null
          : () {
              if (_connectionState != ConnectionState.waiting) {
                widget.onPressed?.call(this);
              }
            },
        child: container,
      );
    }
    return QYBounce(
      absorbOnMove: widget.absorbOnMove,
      onPressed: widget.enable == false
          ? null
          : () {
              if (_connectionState != ConnectionState.waiting) {
                widget.onPressed?.call(this);
              }
            },
      child: container
    );
  }

  Widget _buildNormalContent(Widget? title, Widget? image) {
    if (title == null) return image!;
    if (image == null) return title;
    switch (widget.imageAlignment) {
      case ImageAlignment.left:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            image,
            SizedBox(width: widget.imageMargin),
            title,
          ],
        );
      case ImageAlignment.top:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            image,
            SizedBox(height: widget.imageMargin),
            title,
          ],
        );
      case ImageAlignment.right:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            title,
            SizedBox(width: widget.imageMargin),
            image,
          ],
        );
      case ImageAlignment.bottom:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            title,
            SizedBox(height: widget.imageMargin),
            image,
          ],
        );
    }
  }

  Widget _buildLoadingContent() {
    assert(widget.width != null || widget.height != null, '需要设置宽高');
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoActivityIndicator(
          radius: 10,
        ),
        Padding(padding: EdgeInsets.only(left: 10), child: widget.loadingTitle)
      ],
    ));
  }
}
