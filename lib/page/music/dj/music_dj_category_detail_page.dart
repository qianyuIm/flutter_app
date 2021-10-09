import 'package:flutter/material.dart';

/// 分类详情
class MusicDJCategoryDetailPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const MusicDJCategoryDetailPage(
      {Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  _MusicDJCategoryDetailPageState createState() =>
      _MusicDJCategoryDetailPageState();
}

class _MusicDJCategoryDetailPageState extends State<MusicDJCategoryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
    );
  }
}
