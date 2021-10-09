import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class RichTextHelper {
  static List<InlineSpan> multiInlineSpan(
      BuildContext context, String data, String target) {
    if (data.contains(target)) {
      var index = data.indexOf(target);
      if (index == 0) {
        var title = data.substring(index, target.length);
        var subTitle = data.substring(target.length);
        return [
          TextSpan(
              text: title,
              style: AppTheme.subtitleStyle(context)
                  .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
          TextSpan(text: subTitle, style: AppTheme.subtitleStyle(context))
        ];
      }
      var prefixTitle = data.substring(0, index);
      var middleTitle = data.substring(index, target.length + index);
      var suffixTitle = data.substring(target.length + index);
      return [
        TextSpan(text: prefixTitle, style: AppTheme.subtitleStyle(context)),
        TextSpan(
            text: middleTitle,
            style: AppTheme.subtitleStyle(context)
                .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
        TextSpan(text: suffixTitle, style: AppTheme.subtitleStyle(context))
      ];
    }
    return [TextSpan(text: data, style: AppTheme.subtitleStyle(context))];
  }
}
