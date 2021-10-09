import 'package:flutter/material.dart';

/// 用户页面
class MusicUserHomePage extends StatefulWidget {
  final int userId;

  const MusicUserHomePage({Key? key, required this.userId}) : super(key: key);
  
  @override
  _MusicUserHomePageState createState() => _MusicUserHomePageState();
}

class _MusicUserHomePageState extends State<MusicUserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.userId}'),),
    );
  }
}