import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/string_helper.dart';
import 'package:flutter_app/model/music/music_play_list.dart';
import 'package:flutter_app/model/music/music_user.dart';
import 'package:flutter_app/router/router_manger.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_bounce.dart';

class MusicPlaylistSubscriberItem extends StatelessWidget {
  final MusicPlayList playList;

  const MusicPlaylistSubscriberItem({Key? key, required this.playList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!ListOptionalHelper.hasValue(playList.subscribers)) {
      return SizedBox.shrink();
    }
    return QYBounce(
      absorbOnMove: true,
      onPressed: () {
        Navigator.of(context).pushNamed(MyRouterName.play_list_subscriber,
            arguments: playList.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: Inchs.left),
        child: Row(
          children: [
            _buildProfile(playList.subscribers!),
            Spacer(),
            _buildCount(context)
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(List<MusicUserProfile> subscribers) {
    return Row(
      children: List.generate(subscribers.length, (index) {
        var subscriber = subscribers[index];
        return Container(
          margin: EdgeInsets.only(right: 6),
          child: ImageLoadView(
            imagePath:
                ImageCompressHelper.musicCompress(subscriber.avatarUrl, 30, 30),
            width: 30,
            height: 30,
            radius: 15,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCount(BuildContext context) {
    return Row(
      children: [
        Text('${StringHelper.formateNumber(playList.subscribedCount)}人收藏'),
        Icon(
          Icons.chevron_right,
          color: AppTheme.subtitleColor(context),
        )
      ],
    );
  }
}
