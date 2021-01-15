import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_control.dart';
import 'video_Controller_widget.dart';
import 'dart:ui';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage(
      {Key key, this.width: double.infinity, this.height: double.infinity})
      : super(key: key);

  final width;
  final height;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<VideoControlPageState> _key =
      GlobalKey<VideoControlPageState>();
  String url =
      'https://glb-vod.hexiaoxiang.com/f3b4e9eaa3f44b93ada39a0a797209f4/74b1619bdda44b86919811b9c8fcc69f-9cbe865ed7c1709df5a29082b97f02a1-fd.mp4';
  //
  bool _isPlaying = false;
  bool _playerError = false;
  VideoPlayerController _controller;

  /// 记录是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("/assets/MP4/video.mp4")
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {
          print("加载完毕");
          // _controller.play();
        });
      });

    _controller.addListener(_videoListener);
  }

  void _videoListener() async {
    if (_controller.value.hasError) {
      setState(() {
        _playerError = true;
      });
    } else {
      Duration res = await _controller.position;

      if (res >= _controller.value.duration) {
        await _controller.seekTo(Duration(seconds: 0));
        await _controller.pause();
      }
      if (_controller.value.isPlaying && _key.currentState != null) {
        /// 减少build次数
        _key.currentState.setPositionAndTotalDuration(
          res,
          _controller.value.duration,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoControllerWidget(
        controlKey: _key,
        controller: _controller,
        child: Container(
          color: Colors.blue,
          width: _isFullScreen ? _window.width : widget.width,
          height: _isFullScreen ? _window.height : widget.height,
          child: VideoControlPage(
            child: initPlayer(),
            key: _key,
          ),
        ),
      ),
    );
  }

  Widget initPlayer() {
    return _controller.value.initialized
        ? Container(
            width: double.infinity,
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : new Container();
  }

  @override
  void dispose() {
    /**
     * 页面销毁时，视频播放器也销毁
     */
    _controller.dispose();
    super.dispose();
  }
//播放器

  Widget videoControl() {
    return Container(
      // height: 100,
      color: Colors.red,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [Text('播放')],
      ),
    );
  }
}
