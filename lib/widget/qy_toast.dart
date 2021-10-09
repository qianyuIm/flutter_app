import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class QYToast {
  /// 顶部错误提示
  static showError(BuildContext context, String? message) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 3),
      persistent: true,
      builder: (context, controller) {
        return Flash(
          backgroundColor: AppTheme.of(context).backgroundColor,
          position: FlashPosition.top,
          behavior: FlashBehavior.fixed,
          controller: controller,
          child: FlashBar(
            icon: Icon(Icons.error_outline,color: Colors.red,),
            content: Text(message ?? '请稍后再试',style: AppTheme.titleStyle(context),),
          ),
        );
      },
    );
  }
  /// 成功提示
  static showSuccess(BuildContext context, String? message) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 3),
      persistent: true,
      builder: (context, controller) {
        return Flash(
          backgroundColor: AppTheme.of(context).backgroundColor,
          position: FlashPosition.top,
          behavior: FlashBehavior.fixed,
          controller: controller,
          child: FlashBar(
            icon: Icon(Icons.check_circle_outline,color: Colors.red,),
            content: Text(message ?? '欢迎',style: AppTheme.titleStyle(context),),
          ),
        );
      },
    );
  }
  

}