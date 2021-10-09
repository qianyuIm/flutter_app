import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/comment/comment_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/video/comment/comment_container_page.dart';
import 'package:flutter_app/widget/video/comment/comment_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 最新评论
class CommentPage extends StatefulWidget {
  final String resourceId;
  final double maxHeight;
  final CommentType commentType;
  const CommentPage(
      {Key? key,
      required this.resourceId,
      required this.commentType,
      
      required this.maxHeight})
      : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  // @override
  // bool get wantKeepAlive => true;
  /// 初始化之后需要根据返回数据判定
  int _sortType = 2;
  final List<String> _sortItems = ['推荐', '最热', '最新'];
  @override
  void initState() {
    super.initState();
  }

  Widget _buildContent(int index, Function(int index) selectedCall) {
    return Container(
      color: Colors.yellow,
      child: Row(
        children: List.generate(_sortItems.length, (index) {
          return CommentSortItem(
            isSelected: index == _sortType,
            text: _sortItems[index],
            index: index,
            onSelected: (index) {
              _sortType = index;
              selectedCall.call(index);
              // setState(() {});
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderWidget<CommentViewModel>(
        viewModel: CommentViewModel(),
        onModelReady: (viewModel) => viewModel.initData(_sortType + 1,widget.resourceId,widget.commentType.value),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: () {
                  var sortType = _sortType;
                  if (ListOptionalHelper.hasValue(viewModel.sortTypeList)) {
                    sortType = viewModel.sortTypeList[_sortType].sortType;
                  }
                  viewModel.initData(sortType,widget.resourceId,widget.commentType.value);
                });
          } else if (viewModel.isEmpty) {
            return ViewStateEmptyWidget(
              message: '暂无评论',onPressed: () {
              var sortType = _sortType;
              if (ListOptionalHelper.hasValue(viewModel.sortTypeList)) {
                sortType = viewModel.sortTypeList[_sortType].sortType;
              }
              viewModel.initData(sortType,widget.resourceId,widget.commentType.value);
            });
          }
          return Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: Inchs.left, right: Inchs.right),
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '评论区 (${viewModel.totalCount})',
                      style: AppTheme.titleStyle(context),
                    ),
                    _buildContent(_sortType, (index) {
                      var sortType = _sortType;
                      if (ListOptionalHelper.hasValue(viewModel.sortTypeList)) {
                        sortType = viewModel.sortTypeList[_sortType].sortType;
                      }
                      viewModel.initData(sortType,widget.resourceId,widget.commentType.value);
                    }),
                  ],
                ),
              ),
              Expanded(
                  child: SmartRefresher(
                physics: ClampingScrollPhysics(),
                enablePullDown: false,
                enablePullUp: true,
                controller: viewModel.refreshController,
                onLoading: () {
                  viewModel.loadMore(widget.resourceId,widget.commentType.value);
                },
                child: ListView.builder(
                  controller: ModalScrollController.of(context),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.left, vertical: 10),
                  itemCount: viewModel.comments.length,
                  itemBuilder: (context, index) {
                    var comment = viewModel.comments[index];
                    return CommentItem(comment: comment);
                  },
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}

class CommentSortItem extends StatelessWidget {
  final bool isSelected;
  final String text;
  final int index;
  final void Function(int index)? onSelected;

  const CommentSortItem({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.index,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = isSelected
        ? AppTheme.titleColor(context)
        : AppTheme.subtitleColor(context);
    return InkWell(
        onTap: () {
          onSelected?.call(index);
        },
        child: Container(
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Text(
            text,
            style: AppTheme.subtitleCopyStyle(context,color: color),
          ),
        ));
  }
}
