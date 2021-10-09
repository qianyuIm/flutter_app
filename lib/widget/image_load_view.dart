import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageLoadType { network, assets, localFile }

class ImageLoadView extends StatelessWidget {
  ImageLoadView({
    Key? key,
    required this.imagePath,
    this.radius: 0.0,
    this.width,
    this.height,
    this.margin: EdgeInsets.zero,
    this.fit: BoxFit.cover,
    this.placeholder: "assets/images/loading.png",
    this.imageType: ImageLoadType.network,
   
    this.child,
    this.alignment: Alignment.center,
    this.padding: EdgeInsets.zero,
    this.elevation: 0.0,
    this.shape: BoxShape.rectangle,
    this.borderColor,
    this.borderWidth: 0.0,
    this.imageBuilder,
  }) : super(key: key);

  /// 图片URL
  final String imagePath;

  /// 圆角半径
  final double radius;

  /// 宽
  final double? width;

  /// 高
  final double? height;

  /// 填充效果
  final BoxFit? fit;

  /// 加载中图片
  final String placeholder;

  /// 网络 or assets or file
  final ImageLoadType imageType;

  

  

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  /// 图片外边框
  final EdgeInsetsGeometry? margin;

  /// 子控件位置
  final AlignmentGeometry? alignment;

  final double? elevation;

  final BoxShape shape;

  final Color? borderColor;

  final double borderWidth;

  final ImageWidgetBuilder? imageBuilder;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    switch (imageType) {
      case ImageLoadType.network:
        imageWidget = CachedNetworkImage(
          imageUrl: imagePath,
          imageBuilder: imageBuilder,
          placeholder: (context, url) => Image.asset(placeholder),
          fit: fit,
          errorWidget: (context, url, error) => Image.asset(placeholder),
        );
        break;
      case ImageLoadType.assets:
        imageWidget = FadeInImage(
            placeholder: AssetImage(placeholder),
            image: AssetImage(imagePath),
            fit: fit);
        break;
      case ImageLoadType.localFile:
        imageWidget = FadeInImage(
            placeholder: AssetImage(placeholder),
            image: FileImage(File(imagePath)),
            fit: fit);
        break;
    }
    return Card(
        color: Colors.transparent,
        shape: shape == BoxShape.circle
            ? CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
        clipBehavior: Clip.antiAlias,
        elevation: elevation,
        margin: margin,
        child: Container(
            height: height ?? double.infinity,
            width: width ?? double.infinity,
            child: Stack(children: <Widget>[
              Positioned.fill(child: imageWidget),
              Positioned.fill(
                  child: Container(
                      decoration: BoxDecoration(
                          shape: shape,
                          borderRadius: shape == BoxShape.circle
                              ? null
                              : BorderRadius.circular(radius),
                          border: Border.all(
                              color:
                                  borderColor ?? Theme.of(context).primaryColor,
                              width: borderWidth,
                              style: borderWidth == 0.0
                                  ? BorderStyle.none
                                  : BorderStyle.solid)))),
              
            ])));
  }
}
