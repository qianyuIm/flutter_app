import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';

class QYSpacing extends StatelessWidget {
  final double? width;
  final double? height;
  const QYSpacing({Key? key, this.width, this.height})
      : assert(
            ((width != null && height == null) ||
                (width == null && height != null)),
            '只能设置宽度或者高度'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (width != null) {
      return SizedBox(
        width: Inchs.adapter(width!),
      );
    }
    return SizedBox(
      height: Inchs.adapter(height!),
    );
  }
}
