import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class BorderContainer extends StatelessWidget {
  final Color color;
  final String data;
  final EdgeInsetsGeometry padding;

  const BorderContainer(
      {Key? key,
      required this.data,
      required this.color,
      this.padding = const EdgeInsets.symmetric(horizontal: 2)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        border: Border.all(width: 0.5,color: color),
      ),
      child: Text(
        data,
        style: AppTheme.subtitleCopyStyle(context, color: color, fontSize: 8),
      ),
    );
  }
}
