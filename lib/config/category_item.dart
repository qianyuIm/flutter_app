class CategoryItem {
  /// 图片名称
  String? imageName;

  /// 多语言对应value值
  String? titleValue;

  /// 多语言对应key值
  String? titleKey;

  /// 路由名称
  String? routeName;

  CategoryItem(
      {this.imageName, this.titleValue, this.routeName, this.titleKey});

  factory CategoryItem.fromJson(Map<String, dynamic> srcJson) {
    var categoryItem = CategoryItem()
      ..imageName = srcJson['imageName'] as String?
      ..titleValue = srcJson['titleValue'] as String?
      ..routeName = srcJson['routeName'] as String?
      ..titleKey = srcJson['titleKey'] as String?;
    return categoryItem;
  }
  Map<String, dynamic> toJson() {
    return {
      "imageName": imageName,
      "titleValue": titleValue,
      "routeName": routeName,
      "titleKey": titleKey
    };
  }
}
