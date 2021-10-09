import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/config/qy_icon.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/model/comment/comment_container.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/clear_ink_well.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

const double userWidth = 40;

class CommentItem extends StatefulWidget {
  final Comment comment;
  final Color? color;

  const CommentItem({Key? key, required this.comment, this.color})
      : super(key: key);
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late TapGestureRecognizer _repliedUserRecognizer;
  late TapGestureRecognizer _repliedMoreRecognizer;

  @override
  void initState() {
    _repliedUserRecognizer = TapGestureRecognizer();
    _repliedMoreRecognizer = TapGestureRecognizer();
    super.initState();
  }

  @override
  void dispose() {
    _repliedUserRecognizer.dispose();
    _repliedMoreRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var comment = widget.comment;
    List<Widget> children = [];
    var user = comment.user;
    if (user != null) {
      Widget userWidget = ClearInkWell(
        onTap: () {
          LogUtil.v('点击头像');
        },
        child: Container(
          child: Row(
            children: [
              ImageLoadView(
                imagePath:
                    ImageCompressHelper.musicCompress(user.avatarUrl, 50, 50),
                width: userWidth,
                height: userWidth,
                radius: userWidth / 2,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nickname ?? '',
                    style: AppTheme.titleCopyStyle(context,
                        fontSize: 15, color: widget.color),
                  ),
                  Text(
                    TimeHelper.formatDateMs(comment.time),
                    style: AppTheme.subtitleCopyStyle(context,
                        color: widget.color),
                  ),
                ],
              )),
              ClearInkWell(
                  onTap: () {
                    LogUtil.v('点赞');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 3),
                          child: Text(
                              StringHelper.formateNumber(comment.likedCount),
                              style: AppTheme.subtitleCopyStyle(context,
                                  color: widget.color)),
                        ),
                        QYSpacing(
                          width: 4,
                        ),
                        Icon(
                          QyIcon.icon_praise,
                          size: 20,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
      children.add(userWidget);
    }

    Widget contentWidget = Container(
      padding: EdgeInsets.only(left: userWidth, top: Inchs.sp10),
      child: Text(comment.content,style: AppTheme.subtitleCopyStyle(context,color: widget.color),),
    );
    children.add(contentWidget);
    if (ListOptionalHelper.hasValue(comment.beReplied)) {
      var replied = comment.beReplied!.first;
      Widget repliedWidget = Container(
          color: AppTheme.cardColor(context),
          margin: EdgeInsets.only(left: userWidth, top: 4, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: replied.user?.nickname ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                      recognizer: _repliedUserRecognizer
                        ..onTap = () {
                          LogUtil.v('点击回复作者');
                        }),
                  TextSpan(text: '  '),
                  TextSpan(text: ': ${replied.content}')
                ]),
              ),
              if (comment.beReplied!.length > 1)
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '${comment.beReplied!.length}条回复',
                          style:
                              TextStyle(fontSize: 13, color: Colors.blueAccent),
                          recognizer: _repliedMoreRecognizer
                            ..onTap = () {
                              LogUtil.v('查看更多');
                            }),
                    ]),
                  ),
                ),
            ],
          ));
      children.add(repliedWidget);
    }
    var floorComment = comment.showFloorComment;
    if (floorComment != null && floorComment.replyCount != 0) {
      Widget floorWidget = Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        margin: EdgeInsets.only(left: userWidth, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: '${floorComment.replyCount}条回复',
                    style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                    recognizer: _repliedMoreRecognizer
                      ..onTap = () {
                        LogUtil.v('查看更多');
                      }),
              ]),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.blueAccent,
              size: 20,
            )
          ],
        ),
      );

      children.add(floorWidget);
    }
    return ClearInkWell(
      onTap: () {
        LogUtil.v('点击全部');
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
