import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/video/comment/comment_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum CommentType {
  /// 歌曲
  song,

  /// mv
  mv,

  /// 歌单
  playlist,

  /// 专辑
  album,

  /// 电台
  radio,

  /// 视频
  video,

  /// 动态
  event
}

extension CommentTypeGetValue on CommentType {
  int get value {
    if (this == CommentType.song) {
      return 0;
    } else if (this == CommentType.mv) {
      return 1;
    } else if (this == CommentType.playlist) {
      return 2;
    } else if (this == CommentType.album) {
      return 3;
    } else if (this == CommentType.radio) {
      return 4;
    } else if (this == CommentType.video) {
      return 5;
    } else if (this == CommentType.event) {
      return 6;
    }
    return -1;
  }
}

/// 展示评论
Future<T?> showCommentModalBottomSheet<T>({
  required BuildContext context,
  required double maxHeighgt,
  required String resourceId,
  required CommentType commentType,
  Color? backgroundColor,
  ShapeBorder? shape,
  Color barrierColor = Colors.transparent,
  AnimationController? secondAnimationController,
  Duration? duration,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  var bottomSheet = ModalBottomSheetRoute<T>(
    builder: (context) {
      return CommentContainerPage(
          maxHeighgt: maxHeighgt,
          resourceId: resourceId,
          commentType: commentType);
    },
    bounce: true,
    secondAnimationController: secondAnimationController,
    expanded: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: true,
    modalBarrierColor: barrierColor,
    enableDrag: true,
    duration: duration,
  );

  final result =
      await Navigator.of(context, rootNavigator: false).push(bottomSheet);
  return result;
}

class CommentContainerPage extends StatefulWidget {
  final double maxHeighgt;
  final String resourceId;
  final CommentType commentType;
  const CommentContainerPage(
      {Key? key,
      required this.maxHeighgt,
      required this.resourceId,
      required this.commentType})
      : super(key: key);

  @override
  _CommentContainerPageState createState() => _CommentContainerPageState();
}

class _CommentContainerPageState extends State<CommentContainerPage>
    with TickerProviderStateMixin {
  late double _maxHeight;
  @override
  void initState() {
    _maxHeight = widget.maxHeighgt;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              // color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          height: _maxHeight,
          child: Column(
            children: [
              Container(
                height: 44,
                color: AppTheme.scaffoldBackgroundColor(context),
                child: Center(
                  child: Text(
                    '评论',
                    style: AppTheme.titleCopyStyle(context,fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                  child: CommentPage(
                maxHeight: _maxHeight,
                resourceId: widget.resourceId,
                commentType: widget.commentType,
              ))
            ],
          )),
    );
  }
}
