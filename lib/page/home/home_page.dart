import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/database/local_cache.dart';

import 'package:flutter_app/widget/border_container.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class HomeModel {
  final String name;
  String? sex;

  HomeModel(this.name);

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;

    return data;
  }
}

/// 首页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              QYBounce(
                onPressed: () async {
                  var num = await appLocalCache.put('intKey', 1000);
                  LogUtil.v('存入 => $num');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('存入 int 1000'),
                ),
              ),
              QYBounce(
                onPressed: () async {
                  var num = await appLocalCache.get('intKey');
                  LogUtil.v('取出 => $num');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('取出 int'),
                ),
              ),
              QYBounce(
                onPressed: () async {
                  var num = await appLocalCache.deleteSingle('intKey');
                  LogUtil.v('删除 => $num');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('删除 int'),
                ),
              ),
              Divider(),
              QYBounce(
                onPressed: () async {
                  var model = HomeModel('name');
                  var model1 = HomeModel('name');
                  var aa = [model, model1].map((e) => e.toJson()).toList();
                  // var value = convert.jsonEncode(aa);
                  var result = await appLocalCache.put('modelKey', aa);
                  LogUtil.v('存入 => $result');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('存入 模型 '),
                ),
              ),
              QYBounce(
                onPressed: () async {
                  var value = await appLocalCache.get('modelKey');
                  LogUtil.v('取出模型 => $value');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('取出 模型'),
                ),
              ),
              QYBounce(
                onPressed: () async {
                  var key = await appLocalCache.deleteSingle('modelKey');
                  LogUtil.v('删除模型 => $key');
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('删除 模型'),
                ),
              ),
              Divider(),
              QYBounce(
                onPressed: () async {
                  
                },
                child: Container(
                  margin: EdgeInsets.only(top: Inchs.sp6),
                  padding: EdgeInsets.symmetric(
                      horizontal: Inchs.sp10, vertical: Inchs.sp10),
                  color: Colors.red.withAlpha(100),
                  child: Text('跳转'),
                ),
              ),
              QYSpacing(height: 10,),
              QYBounce(
                onPressed: () async {
                
                },
                child: BorderContainer(
                  color: Colors.red,
                  data: '123',
                ),
              )
            ],
          ),
        )));
  }
}
