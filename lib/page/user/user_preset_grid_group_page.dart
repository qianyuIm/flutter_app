import 'package:collection/collection.dart';
import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/locale_helper.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/view_model/user/user_view_model.dart';
import 'package:flutter_app/widget/category_edit_button.dart';
import 'package:flutter_app/widget/clear_ink_well.dart';

import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:flutter_app/widget/qy_toast.dart';

class UserPresetGridGroupPage extends StatefulWidget {
  @override
  _UserPresetGridGroupPageState createState() =>
      _UserPresetGridGroupPageState();
}

class _UserPresetGridGroupPageState extends State<UserPresetGridGroupPage> {
  final ValueNotifier<bool> _editChange = ValueNotifier(false);
  final _selectedkey =
      GlobalKey<DraggableContainerState<UserPresetGridSelectedItem>>();
  final _unSelectedkey =
      GlobalKey<DraggableContainerState<UserPresetGridUnSelectedItem>>();
  late double _maxCrossAxisExtent;

  List<UserPresetGridSelectedItem>? _reorderSelectedItem;
  List<UserPresetGridUnSelectedItem>? _reorderUnSelectedItem;

  @override
  void initState() {
    _maxCrossAxisExtent =
        (Inchs.screenWidth - Inchs.left - Inchs.right - 16) / 4;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐应用'),
      ),
      body: ProviderWidget<UserPresetGridGroupViewModel>(
        viewModel: UserPresetGridGroupViewModel(),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError && viewModel.unSelectedItem.isEmpty) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: viewModel.initData());
          } else if (viewModel.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }
          if (_reorderSelectedItem == null) {
            _reorderSelectedItem = viewModel.selectedItem;
          }
          if (_reorderUnSelectedItem == null) {
            _reorderUnSelectedItem = viewModel.unSelectedItem;
          }
          return WillPopScope(
            onWillPop: () async {
              if (_selectedkey.currentState?.editMode == true) {
                _selectedkey.currentState?.editMode = false;
              }
              bool isEquals = const IterableEquality()
                  .equals(_reorderSelectedItem, viewModel.selectedItem);
              if (_reorderSelectedItem != null && !isEquals) {
                await LocalDb.instance.userPresetGridDb
                    .insertAll(_reorderSelectedItem!);
              }
              Navigator.of(context).pop(!isEquals);
              return false;
            },
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildTitle(false),
                    _buildSelected(
                        _reorderSelectedItem!,
                        AppTheme.cardColor(context),
                        AppTheme.primaryColor(context)),
                    _buildTitle(true),
                    _buildUnSelected(
                        _reorderUnSelectedItem!,
                        AppTheme.cardColor(context),
                        AppTheme.primaryColor(context)),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _buildTitle(bool isUnSelected) {
    return Padding(
        padding: EdgeInsets.fromLTRB(Inchs.left, 10.0, Inchs.right, 10.0),
        child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Text(isUnSelected ? '更多应用' : '我的应用',
              style: AppTheme.titleStyle(context)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(isUnSelected ? '点击添加应用' : '点击进入应用',
                      style: AppTheme.subtitleStyle(context))),
              flex: 1),
          _buildTitleRigh(isUnSelected)
        ]));
  }

  Widget _buildTitleRigh(bool isUnSelected) {
    if (isUnSelected)
      return Container();
    else
      return CategoryEditButton(
        editChange: _editChange,
        onTap: (isEdit) {
          _selectedkey.currentState?.editMode = !isEdit;
        },
      );
  }

  Widget _buildSelected(List<UserPresetGridSelectedItem> selectedItem,
      Color cardColor, Color imageColor) {
    return Padding(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 5),
        child: DraggableContainer<UserPresetGridSelectedItem>(
          key: _selectedkey,
          tapOutSideExitEditMode: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _maxCrossAxisExtent,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              mainAxisExtent: 80),
          items: selectedItem,
          onEditModeChanged: (editting) {
            _editChange.value = editting;
          },
          onChanged: (items) {
            _reorderSelectedItem = items.cast<UserPresetGridSelectedItem>();
            // setState(() {});
          },
          beforeRemove: (item, slotIndex) async {
            _selectedkey.currentState?.removeSlot(slotIndex);
            if (item != null) {
              var unAdd = UserPresetGridUnSelectedItem(
                categoryItem: item.categoryItem,
              );
              _unSelectedkey.currentState?.insertSlot(0, unAdd);
            }
            return false;
          },
          beforeDrop: ({fromItem, fromSlotIndex = 0, toItem, toSlotIndex = 0}) {
            return Future.value(!toItem!.fixed);
          },
          slotBuilder: (context, item) {
            return Container();
          },
          itemBuilder: (context, categoryItem) {
            return Material(
              elevation: 0,
              color: cardColor,
              borderOnForeground: false,
              borderRadius: BorderRadius.circular(5),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageHelper.wrapMusicPng(
                          categoryItem!.categoryItem.imageName!),
                      width: 30,
                      color: imageColor,
                    ),
                    QYSpacing(
                      height: 4,
                    ),
                    Text(
                      LocaleHelper.localeString(
                          categoryItem.categoryItem.titleValue!,
                          categoryItem.categoryItem.titleKey!),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildUnSelected(List<UserPresetGridUnSelectedItem> unSelectedItem,
      Color cardColor, Color imageColor) {
    if (unSelectedItem.length == 0) return SizedBox.shrink();
    return Padding(
        padding: EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 5),
        child: DraggableContainer<UserPresetGridUnSelectedItem>(
          key: _unSelectedkey,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _maxCrossAxisExtent,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              mainAxisExtent: 80),
          items: unSelectedItem,
          onChanged: (items) {
            _reorderUnSelectedItem = items.cast<UserPresetGridUnSelectedItem>();
          },
          slotBuilder: (context, item) {
            return Container();
          },
          itemBuilder: (context, categoryItem) {
            return ClearInkWell(
                onTap: () {
                  if (categoryItem == null) return;
                  if ((_reorderSelectedItem?.length ?? 0) >= 12) {
                    QYToast.showError(context, '最多添加12个');
                  } else {
                    int? index =
                        _unSelectedkey.currentState?.removeItem(categoryItem);
                    if (index != null) {
                      _unSelectedkey.currentState?.removeSlot(index);
                    }
                    var add = UserPresetGridSelectedItem(
                        categoryItem: categoryItem.categoryItem,
                        location: _reorderSelectedItem?.length ?? 1);
                    _selectedkey.currentState?.addSlot(add);
                  }
                },
                child: Material(
                  color: cardColor,
                  elevation: 0,
                  borderOnForeground: false,
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageHelper.wrapMusicPng(
                              categoryItem!.categoryItem.imageName!),
                          width: 30,
                          color: imageColor,
                        ),
                        QYSpacing(
                          height: 4,
                        ),
                        Text(LocaleHelper.localeString(
                            categoryItem.categoryItem.titleValue!,
                            categoryItem.categoryItem.titleKey!))
                      ],
                    ),
                  ),
                ));
          },
        ));
  }
}
