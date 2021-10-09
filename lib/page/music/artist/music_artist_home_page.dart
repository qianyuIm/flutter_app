import 'package:flutter/material.dart';


class MusicArtistHomePage extends StatefulWidget {
  @override
  _MusicArtistHomePageState createState() => _MusicArtistHomePageState();
}

class _MusicArtistHomePageState extends State<MusicArtistHomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: 40,
      itemBuilder: (context, index) {
        return Container(
         height: 40,
         color: Colors.purple,
         child: Center(
           child: Text('index = > $index'),
         ), 
        );
      },
    );
  }
}