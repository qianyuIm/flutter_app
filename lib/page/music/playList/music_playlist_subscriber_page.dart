import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_play_list_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicPlaylistSubscriberPage extends StatefulWidget {
  final int playlistId;

  const MusicPlaylistSubscriberPage({Key? key, required this.playlistId})
      : super(key: key);

  @override
  _MusicPlaylistSubscriberPageState createState() =>
      _MusicPlaylistSubscriberPageState();
}

class _MusicPlaylistSubscriberPageState
    extends State<MusicPlaylistSubscriberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏者'),
      ),
      body: ProviderWidget<MusicPlaylistSubscriberViewModel>(
        viewModel: MusicPlaylistSubscriberViewModel(widget.playlistId),
        onModelReady: (viewModel) => viewModel.initData(),
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return ViewStateBusyWidget();
          } else if (viewModel.isError) {
            return ViewStateErrorWidget(
                error: viewModel.viewStateError!,
                onPressed: viewModel.initData);
          } else if (viewModel.isEmpty || viewModel.subscribers.isEmpty) {
            return ViewStateEmptyWidget(onPressed: viewModel.initData);
          }
          return SmartRefresher(
            enablePullUp: true,
            enablePullDown: false,
            controller: viewModel.refreshController,
            onLoading: viewModel.loadMore,
            child: ListView.builder(
              padding:
                  EdgeInsets.symmetric(horizontal: Inchs.left, vertical: 10),
              itemCount: viewModel.subscribers.length,
              itemBuilder: (context, index) {
                return _buildUserprofileItem(viewModel.subscribers[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserprofileItem(MusicUserProfile userProfile) {
    
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        LogUtil.v('点击用户');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageLoadView(
                radius: 25,
                width: 50,
                height: 50,
                imagePath: ImageCompressHelper.musicCompress(
                    userProfile.avatarUrl, 50, 50)),
            Expanded(child: _buildMidle(userProfile)),
          ],
        ),
      ),
    );
  }

  Widget _buildMidle(MusicUserProfile userProfile) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${userProfile.nickname}',
                style: AppTheme.titleStyle(context).copyWith(fontSize: 16),
              ),
              userProfile.gender.image
            ],
          ),
          if (userProfile.signature.isNotEmpty)
            QYSpacing(
              height: 4,
            ),
          if (userProfile.signature.isNotEmpty)
            Text(
              userProfile.signature,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
        ],
      ),
    );
  }
}
