import 'package:chewie/chewie.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/image_load_view.dart';
import 'package:flutter_app/widget/video/chewie_single_icon_controls.dart';
import 'package:video_player/video_player.dart';

class MusicArtistEventVideo extends StatefulWidget {
  final int currentIndex;
  final String placeholderUrl;
  final String videoUrl;
  final int playCount;
  final int duration;
  final double width;
  final double height;
  final double aspectRatio;
  /// 屏幕中第一行监听
  final ValueNotifier<int> headNotifier;
  /// 屏幕中最后行监听
  final ValueNotifier<int> tailNotifier;
  
  const MusicArtistEventVideo(
      {Key? key,
      required this.placeholderUrl,
      required this.playCount,
      required this.duration,
      required this.videoUrl,
      required this.width,
      required this.height,
       this.aspectRatio = 16 / 9,
      required this.headNotifier, 
      required this.tailNotifier,
      required  this.currentIndex})
      : super(key: key);

  @override
  _MusicArtistEventVideoState createState() => _MusicArtistEventVideoState();
}

class _MusicArtistEventVideoState extends State<MusicArtistEventVideo> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    /// 初始化
    _initializePlayer();
    widget.headNotifier.addListener(pause);
    widget.tailNotifier.addListener(startPlay);
    LogUtil.v('初始化');
  }

  @override
  void dispose() {
    widget.headNotifier.removeListener(pause);
    widget.tailNotifier.removeListener(startPlay);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  /// 开始播放
  void startPlay() {
    LogUtil.v('1--------->开始播放');
    if (!mounted) return;
    LogUtil.v('2--------->开始播放');
    if (widget.tailNotifier.value == widget.currentIndex) {
      _chewieController.play();
    }
  }
  /// 暂停播放
  void pause() {
    LogUtil.v('1--------->暂停播放');
    if (!mounted) return;
    LogUtil.v('2--------->暂停播放');
    if (widget.headNotifier.value == widget.currentIndex) {
      _chewieController.pause();
    }
  }

  _initializePlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRatio,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      placeholder: ImageLoadView(
        imagePath: widget.placeholderUrl,
        width: widget.width,
        height: widget.height,
        radius: 5,
      ),
      customControls: ChewieSingleIconControls(
          backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
          iconColor: Color.fromARGB(255, 200, 200, 200),
          playPauseStatus: (isPlaying) {
            if (isPlaying) {
              _chewieController.play();
            } else {
              _chewieController.pause();
            }
          },
        )
    );
    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width + 4,
      height: widget.height,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
