import 'package:collection/collection.dart';
import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_db.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/category_edit_button.dart';
import 'package:flutter_app/widget/qy_toast.dart';


class MusicPlaylistCategoryPage extends StatefulWidget {
  @override
  _MusicPlaylistCategoryPageState createState() => _MusicPlaylistCategoryPageState();
}

class _MusicPlaylistCategoryPageState extends State<MusicPlaylistCategoryPage> {
  final ValueNotifier<bool> _editChange = ValueNotifier(false);
  final _selectedkey =
      GlobalKey<DraggableContainerState<MusicPlaylistSelectedItem>>();
  final _unSelectedkey =
      GlobalKey<DraggableContainerState<MusicPlaylistUnSelectedItem>>();
  late double _maxCrossAxisExtent;

  List<MusicPlaylistSelectedItem>? _reorderSelectedItem;
  List<MusicPlaylistUnSelectedItem>? _reorderUnSelectedItem;

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
        title: Text(S.of(context).classification_management),
      ),
      body: ProviderWidget<MusicPlaylistCategoryViewModel>(
        viewModel: MusicPlaylistCategoryViewModel(),
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
          var color = AppTheme.primaryColor(context);
          return WillPopScope(
            onWillPop: () async {
              if (_selectedkey.currentState?.editMode == true) {
                _selectedkey.currentState?.editMode = false;
              }
              bool isEquals = const IterableEquality()
                  .equals(_reorderSelectedItem, viewModel.selectedItem);
              if (_reorderSelectedItem != null && !isEquals) {
                await LocalDb.instance.playlistCategoryDb
                    .insertAll(_reorderSelectedItem!);
              }
              Navigator.of(context).pop(!isEquals);
              return false;
            },
            child: SafeArea(child: SingleChildScrollView(
                child: Column(
              children: [
                _buildTitle(false),
                _buildSelected(_reorderSelectedItem!,color),
                _buildTitle(true),
                _buildUnSelected(_reorderUnSelectedItem!,color),
              ],
            )),)
          );
        },
      ),
    );
  }

  Widget _buildTitle(bool isUnSelected) {
    return Padding(
        padding: EdgeInsets.fromLTRB(Inchs.left, 10.0, Inchs.right, 10.0),
        child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Text(isUnSelected ? '更多栏目' : '我的栏目',
              style: AppTheme.titleStyle(context)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(isUnSelected ? '点击添加栏目' : '点击进入栏目',
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

  Widget _buildSelected(List<MusicPlaylistSelectedItem> selectedItem,Color color) {
    return Padding(
        padding:
            EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 5),
        child: DraggableContainer<MusicPlaylistSelectedItem>(
          key: _selectedkey,
          tapOutSideExitEditMode: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _maxCrossAxisExtent,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1 / 2.6),
          items: selectedItem,
          onEditModeChanged: (editting) {
            _editChange.value = editting;
          },
          onChanged: (items) {
            _reorderSelectedItem = items.cast<MusicPlaylistSelectedItem>();
            // setState(() {});
          },
          beforeRemove: (item, slotIndex) async {
            _selectedkey.currentState?.removeSlot(slotIndex);
            if (item != null) {
              var unAdd = MusicPlaylistUnSelectedItem(
                category: item.category,
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
          itemBuilder: (context, item) {
            return Material(
              elevation: 0,
              borderOnForeground: false,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: color, width: 1.0),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Center(
                  child: Text(item?.category.name ?? ''),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildUnSelected(List<MusicPlaylistUnSelectedItem> unSelectedItem, Color color) {
    if (unSelectedItem.length == 0) return SizedBox.shrink();
    return Padding(
        padding:
            EdgeInsets.only(left: Inchs.left, right: Inchs.right, top: 5),
        child: DraggableContainer<MusicPlaylistUnSelectedItem>(
          key: _unSelectedkey,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _maxCrossAxisExtent,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1 / 2.6),
          items: unSelectedItem,
          onChanged: (items) {
            _reorderUnSelectedItem = items.cast<MusicPlaylistUnSelectedItem>();
          },
          slotBuilder: (context, item) {
            return Container();
          },
          itemBuilder: (context, item) {
            return InkWell(
                onTap: () {
                  if (item == null) return;
                  if ((_reorderSelectedItem?.length ?? 0) >= 20) {
                    QYToast.showError(context, '最多添加20个');
                  } else {
                    int? index = _unSelectedkey.currentState?.removeItem(item);
                    if (index != null) {
                      _unSelectedkey.currentState?.removeSlot(index);
                    }
                    var add = MusicPlaylistSelectedItem(
                        category: item.category,
                        location: _reorderSelectedItem?.length ?? 1);
                    _selectedkey.currentState?.addSlot(add);
                  }
                },
                child: Material(
                  elevation: 0,
                  borderOnForeground: false,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: color, width: 1.0),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Center(
                      child: Text(item?.category.name ?? ''),
                    ),
                  ),
                ));
          },
        ));
  }
}