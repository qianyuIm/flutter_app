import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_song.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_secondary_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/qy_spacing.dart';

class MusicArtistSongPage extends StatefulWidget {
  final int artistId;

  const MusicArtistSongPage({Key? key, required this.artistId})
      : super(key: key);
  @override
  _MusicArtistSongPageState createState() => _MusicArtistSongPageState();
}

class _MusicArtistSongPageState extends State<MusicArtistSongPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicArtistTopSongViewModel>(
      viewModel: MusicArtistTopSongViewModel(widget.artistId),
      onModelReady: (viewModel) => viewModel.initData(),
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return ViewStateBusyWidget();
        } else if (viewModel.isError) {
          return ViewStateErrorWidget(
              error: viewModel.viewStateError!, onPressed: viewModel.initData);
        } else if (viewModel.isEmpty) {
          return ViewStateEmptyWidget(onPressed: viewModel.initData);
        }
        return CustomScrollView(
          slivers: [
            _buildHeader(viewModel.songs.length),
            _buildBody(viewModel.songs)
          ],
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: AppTheme.primaryColor(context),
                ),
                QYSpacing(
                  width: 4,
                ),
                Text('播放全部', style: AppTheme.titleStyle(context)),
                QYSpacing(
                  width: 4,
                ),
                Text('$count'),
              ],
            ),
            Image.asset(
              ImageHelper.wrapMusicPng('music_play_list_download',
                  ),
              width: 22,
              color: AppTheme.subtitleColor(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<MusicSong> songs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        // MusicSong song = songs[index];
        return Container();
        // return MusicPlaylistTile(
        //   soleId: widget.artistId,
        //   songs: songs,
        //   song: song,
        //   index: index,
        //   tap: () {
        //     // setState(() {});
        //   },
        // );
      }, childCount: songs.length),
    );
  }
}
