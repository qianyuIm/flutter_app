import 'package:colour/colour.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/inch.dart';
import 'package:flutter_app/helper/image_helper.dart';
import 'package:flutter_app/helper/optional_helper.dart';
import 'package:flutter_app/helper/time_helper.dart';
import 'package:flutter_app/layout/music_event_pic_layout.dart';
import 'package:flutter_app/model/music/music_mv.dart';
import 'package:flutter_app/model/music/music_user_box_event.dart';
import 'package:flutter_app/network/music_api/music_api.dart';
import 'package:flutter_app/page/music/artist/music_artist_event_children_delegate.dart';
import 'package:flutter_app/page/music/artist/music_artist_event_video.dart';
import 'package:flutter_app/provider/provider_widget.dart';
import 'package:flutter_app/provider/view_state_widget.dart';
import 'package:flutter_app/view_model/music/music_user_event_view_model.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';
import 'package:flutter_app/widget/button/qy_button.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/qy_spacing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MusicArtistEventPage extends StatefulWidget {
  final int uid;

  const MusicArtistEventPage(
      {Key? key, required this.uid})
      : super(key: key);

  @override
  _MusicArtistEventPageState createState() => _MusicArtistEventPageState();
}

double kPadding = Inchs.left;
const double kContentLeft = 44;
double kMaxWidth = Inchs.screenWidth - 2 * kPadding - kContentLeft - 1;

class _MusicArtistEventPageState extends State<MusicArtistEventPage>
    with AutomaticKeepAliveClientMixin {
  /// 屏幕中第一行监听
  final ValueNotifier<int> _headNotifier = ValueNotifier(-1);

  /// 屏幕中最后行监听
  final ValueNotifier<int> _tailNotifier = ValueNotifier(-1);

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<MusicUserEventViewModel>(
      viewModel: MusicUserEventViewModel(widget.uid),
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

        return SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          controller: viewModel.refreshController,
          onLoading: viewModel.loadMore,
          child: ListView.custom(
            padding: EdgeInsets.all(kPadding),
            cacheExtent: 1,
            childrenDelegate: MusicArtistEventChildrenDelegate(
              (context, index) {
                return _buildItem(viewModel.events[index], index);
              },
              childCount: viewModel.events.length,
              findHeadAndTailLocationCallback: (headIndex, tailIndex) {
                _headNotifier.value = headIndex;
                _tailNotifier.value = tailIndex;
              },
            ),
          ),
        );
      },
    );
  }

  /// 每个item,index作为唯一标识吧
  Widget _buildItem(MusicUserEvent event, int index) {
    return MusicArtistEventItem(
      event: event,
      index: index,
      headNotifier: _headNotifier,
      tailNotifier: _tailNotifier,
    );
  }
}

class MusicArtistEventItem extends StatelessWidget {
  final MusicUserEvent event;
  final int index;
  /// 屏幕中第一行监听
  final ValueNotifier<int> headNotifier;

  /// 屏幕中最后行监听
  final ValueNotifier<int> tailNotifier;


  const MusicArtistEventItem(
      {Key? key,
       required this.event, 
       required this.index, 
       required this.headNotifier, 
       required this.tailNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (event.user != null) {
      var header = MusicArtistEventItemHeader(event: event);
      children.add(header);
    }
    if (event.json != null) {
      var content = MusicArtistEventItemContent(event: event);
      children.add(content);
    }

    if (ListOptionalHelper.hasValue(event.pics)) {
      /// 图片
      var pic = MusicArtistEventPic(pics: event.pics!);
      children.add(pic);
    }

    /// 视频 mv  mlog 相关
    if (event.json != null) {
      if (event.json?.subType == MusicUserEventSubType.mlog) {
        /// mlog
        var mlog = MusicArtistEventMlog(
          resource: event.json!.resource!,
        );
        children.add(mlog);
      } else if (event.json?.subType == MusicUserEventSubType.mlogVideo) {
        /// mlog
        var mlogVideo = Container(
          width: 100,
          height: 100,
          color: Colors.white,
          child: Center(
            child: Text(
              'mlogVideo',
              style: AppTheme.titleStyle(context),
            ),
          ),
        );
        children.add(mlogVideo);
      } else if (event.json?.subType == MusicUserEventSubType.video) {
        /// video
        var video = Container(
          width: 100,
          height: 100,
          color: Colors.white,
          child: Center(
            child: Text(
              '我是video',
              style: AppTheme.titleStyle(context),
            ),
          ),
        );
        children.add(video);
      } else if (event.json?.subType == MusicUserEventSubType.mv) {
        var width = Inchs.adapter(230);
        var height = width * 300 / 230;
        var aspectRatio = 16 / 9;
        if (event.json?.mv?.width != 0 && event.json?.mv?.height != 0) {
          /// 宽高比来做
          width = kMaxWidth;
          height = kMaxWidth * event.json!.mv!.height / event.json!.mv!.width;
          aspectRatio = width / height;
        }
        var placeholderUrl = event.json?.mv?.imgurl ?? '';
        var mv = FutureBuilder<MusicMVUrl?>(
          future: mvUrlNeedRequest(event.json),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              /// 构造数据
              var videoUrl = snapshot.data?.url ?? '';
              var playCount = event.json?.mv?.playCount ?? 0;

              return Container(
                  margin: EdgeInsets.only(left: kContentLeft, top: 10),
                  child: MusicArtistEventVideo(
                    videoUrl: videoUrl,
                    playCount: playCount,
                    duration: 0,
                    placeholderUrl: placeholderUrl,
                    width: width,
                    height: height,
                    aspectRatio: aspectRatio,
                    currentIndex: index,
                    headNotifier: headNotifier,
                    tailNotifier: tailNotifier,
                  ));
            } else {
              return Container(
                margin: EdgeInsets.only(left: kContentLeft, top: 10),
                child: ImageLoadView(
                  imagePath: placeholderUrl,
                  width: width,
                  height: height,
                  radius: 5,
                ),
              );
            }
          },
        );

        children.add(mv);
      }
    }

    if (event.tailMark != null) {
      var tail = MusicArtistEvntTail(
        tail: event.tailMark!,
      );
      children.add(tail);
    }
    var toolBar = MusicArtistEventToolBar(event: event);
    children.add(toolBar);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 判断mv是否需要重新请求数据
  Future<MusicMVUrl?> mvUrlNeedRequest(MusicUserEventJson? json) async {
    /// 首先判断是否有mvurl
    if (json?.mvUrl == null) {
      /// 判断是否有链接
      var musicMVUrl = await MusicApi.loadMVUrlData(event.json!.mv!.id, r: 240);
      json?.mvUrl = musicMVUrl;
    }
    return json?.mvUrl;
  }
}

class MusicArtistEventItemHeader extends StatelessWidget {
  final MusicUserEvent event;

  const MusicArtistEventItemHeader({Key? key, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Stack(
            children: [
              ImageLoadView(
                imagePath: ImageCompressHelper.musicCompress(
                    event.user?.avatarUrl, 40, 40),
                width: 40,
                height: 40,
                radius: 20,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ImageLoadView(
                  imagePath: event.user?.avatarDetail?.identityIconUrl ?? '',
                  width: 15,
                  height: 15,
                ),
              ),
            ],
          ),
          QYSpacing(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(event.user!.nickname ?? ''),
                  QYSpacing(width: 10),
                  Text(event.type?.title ?? ''),
                ],
              ),
              Text(
                '${TimeHelper.formatDateMs(event.showTime,format: 'yyyy年MM月dd日')}',
                style: AppTheme.subtitleStyle(context).copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MusicArtistEventItemContent extends StatelessWidget {
  final MusicUserEvent event;

  const MusicArtistEventItemContent({Key? key, required this.event})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: kContentLeft),
      child: Text(event.json?.msg ?? ''),
    );
  }
}

/// pic
class MusicArtistEventPic extends StatelessWidget {
  final List<MusicUserEventPic> pics;

  const MusicArtistEventPic({Key? key, required this.pics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double singleWidth = (kMaxWidth - 2 * 4) / 3;
    double singleHeight = singleWidth;
    if (pics.length == 1) {
      var first = pics[0];
      singleWidth = Inchs.adapter(170);
      singleHeight = singleWidth * first.height / first.width;
    }
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(left: kContentLeft, top: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: MusicEventPicLayout(
        maxWidth: kMaxWidth,
        count: pics.length,
        axisSpacing: 4.0,
        singleWidth: singleWidth,
        singleHeight: singleHeight,
        children: pics.map((pic) {
          return ImageLoadView(
            fit: BoxFit.cover,
            imagePath: ImageCompressHelper.musicCompress(
              pic.originUrl,
              singleWidth,
              singleHeight,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MusicArtistEventMlog extends StatelessWidget {
  final MusicUserEventResource resource;

  const MusicArtistEventMlog({Key? key, required this.resource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int width = resource.mlogBaseData?.coverWidth ?? 100;
    int height = resource.mlogBaseData?.coverHeight ?? 100;

    final double picWidth = Inchs.adapter(167);
    final double picHeight = picWidth * height / width;
    return Container(
      margin: EdgeInsets.only(left: kContentLeft, top: 10),
      child: InkWell(
        onTap: () {
          LogUtil.v('object');
        },
        child: Stack(
          children: [
            ImageLoadView(
              imagePath: ImageCompressHelper.musicCompress(
                  resource.mlogBaseData?.coverUrl, picWidth, picHeight),
              width: picWidth,
              height: picHeight + 40,
              radius: 10,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Image.asset(
                ImageHelper.wrapMusicPng('music_artist_event_mlog',
                    ),
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MusicArtistEvntTail extends StatelessWidget {
  final MusicUserEventTail tail;

  const MusicArtistEvntTail({Key? key, required this.tail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: kContentLeft, top: 10),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(40),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageHelper.wrapMusicPng('music_artist_circle_event_entrance',
                ),
            width: 16,
            height: 16,
          ),
          Text(
            tail.markTitle ?? '',
            style: AppTheme.subtitleStyle(context)
                .copyWith(color: Colour('507DAF'), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class MusicArtistEventToolBar extends StatelessWidget {
  final MusicUserEvent event;

  const MusicArtistEventToolBar({Key? key, required this.event})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: kContentLeft),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            'music_artist_event_toolBar_repost',
            count: event.insiteForwardCount,
            onPressed: () {
              LogUtil.v('点击转发');
            },
          ),
          _buildButton(
            'music_artist_event_toolBar_comment',
            count: event.info?.commentCount,
            onPressed: () {
              LogUtil.v('点击评论');
            },
          ),
          _buildButton(
            'music_artist_event_toolBar_unlike',
            count: event.info?.likedCount,
            onPressed: () {
              LogUtil.v('点击喜欢');
            },
          ),
          _buildButton(
            'music_artist_event_toolBar_more',
            onPressed: () {
              LogUtil.v('点击更多');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String image, {int? count, void Function()? onPressed}) {
    var title = '';
    if (count != null) {
      title = '$count';
    }

    return QYButtom(
      title: Text(title),
      image: Image.asset(
        ImageHelper.wrapMusicPng(image),
        width: 15,
        height: 15,
      ),
      onPressed: (state) {
        onPressed?.call();
      },
      // onPressed: ,
    );
  }
}
