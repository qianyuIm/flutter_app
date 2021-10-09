import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/page/music/secondary/music_top_album_page.dart';
import 'package:flutter_app/page/music/secondary/music_top_song_page.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

class MusicTopContainerPage extends StatefulWidget {
  @override
  _MusicTopContainerPageState createState() => _MusicTopContainerPageState();
}

class _MusicTopContainerPageState extends State<MusicTopContainerPage> with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  @override
  void initState() {
    _tabController =
        TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          MusicTopSongContainerPage(),
          MusicTopAlbumContainerPage(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return _MusicTopContainerTitle(
      onValueChanged: (value) {
        _tabController.animateTo(value);
      },
    );
  }
}

class _MusicTopContainerTitle extends StatefulWidget {
  final ValueChanged<int>? onValueChanged;

  const _MusicTopContainerTitle({Key? key, this.onValueChanged})
      : super(key: key);

  @override
  __MusicTopContainerTitleState createState() =>
      __MusicTopContainerTitleState();
}

class __MusicTopContainerTitleState extends State<_MusicTopContainerTitle> {
  int _currentSegment = 0;

  @override
  Widget build(BuildContext context) {
    var color = AppTheme.primaryColor(context);
    var selectedColor = Colors.white;
    return Container(
      child: CustomSlidingSegmentedControl<int>(
        padding: 4,
        innerPadding: 1,
        fixedWidth: 100,
        backgroundColor: Colors.transparent,
        thumbColor: AppTheme.primaryColor(context),
        elevation: 0,
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryColor(context)),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        children: {
          0: Text(
            S.of(context).top_new_song,
            textAlign: TextAlign.center,
            style: AppTheme.titleStyle(context)
                .copyWith(color: _currentSegment == 0 ? selectedColor : color),
          ),
          1: Text(
            S.of(context).top_new_album,
            textAlign: TextAlign.center,
            style: AppTheme.titleStyle(context)
                .copyWith(color: _currentSegment == 1 ? selectedColor : color),
          ),
        },
        duration: Duration(milliseconds: 200),
        radius: 30.0,
        onValueChanged: (index) {
          setState(() {
            _currentSegment = index;
          });
          widget.onValueChanged?.call(index);
        },
      ),
    );
  }
}
