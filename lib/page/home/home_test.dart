import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/connectivity_helper.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<ConnectivityResult>? _subscription;
  @override
  void initState() {
    super.initState();
    _subscription = ConnectivityHelper().onConnectivityStatusChanged.listen((event) {
      LogUtil.v('更新页面');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity example app'),
      ),
      body: Center(
          child: Text(
              'Connection Status: ${ConnectivityHelper().connectionStatus.toString()}')),
    );
  }
}
