
import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class CategoryEditButton extends StatefulWidget {
  final void Function(bool isEdit) onTap;
  final ValueNotifier<bool> editChange;
  const CategoryEditButton(
      {Key? key, required this.onTap, required this.editChange})
      : super(key: key);

  @override
  _CategoryEditButtonState createState() =>
      _CategoryEditButtonState();
}

class _CategoryEditButtonState
    extends State<CategoryEditButton> {
  bool _isEdit = false;

  @override
  void initState() {
    widget.editChange.addListener(listenerEditChange);
    super.initState();
  }

  listenerEditChange() {
    _isEdit = widget.editChange.value;
    setState(() {});
  }

  @override
  void dispose() {
    widget.editChange.removeListener(listenerEditChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 14.0),
                child: Text(!_isEdit ? S.of(context).editor : S.of(context).done,
                    textAlign: TextAlign.right,
                    style: AppTheme.subtitleCopyStyle(context,color: AppTheme.iconColor(context)))),
            decoration: BoxDecoration(
                border: Border.all(color: AppTheme.iconColor(context), width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(50.0)))),
        onTap: () {
          // _isEdit = !_isEdit;
          widget.onTap.call(_isEdit);
          // setState(() {});
        });
  }
}
