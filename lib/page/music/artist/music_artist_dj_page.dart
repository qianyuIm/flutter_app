import 'package:flutter/material.dart';
import 'package:flutter_app/helper/color_helper.dart';


class MusicArtistDJPage extends StatefulWidget {
  @override
  _MusicArtistDJPageState createState() => _MusicArtistDJPageState();
}

class _MusicArtistDJPageState extends State<MusicArtistDJPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: ColorHelper.random(),
    );
  }
}