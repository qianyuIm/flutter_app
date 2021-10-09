import 'package:flutter/material.dart';
import 'package:flutter_app/model/music/music_playlist_categorie.dart';

class MusicHighqualityPlaylistPage extends StatefulWidget {
  final MusicPlaylistCategorie category;

  const MusicHighqualityPlaylistPage({Key? key, required this.category}) : super(key: key);

  @override
  _MusicHighqualityPlaylistPageState createState() => _MusicHighqualityPlaylistPageState();
}

class _MusicHighqualityPlaylistPageState extends State<MusicHighqualityPlaylistPage> with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      
    );
  }
}