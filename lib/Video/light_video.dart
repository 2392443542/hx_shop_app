import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

class LightVideoPage extends StatefulWidget {
  LightVideoPage({Key key}) : super(key: key);

  @override
  _LightVideoPageState createState() => _LightVideoPageState();
}

class _LightVideoPageState extends State<LightVideoPage> {
  String url =
      'https://glb-vod.hexiaoxiang.com/f3b4e9eaa3f44b93ada39a0a797209f4/74b1619bdda44b86919811b9c8fcc69f-9cbe865ed7c1709df5a29082b97f02a1-fd.mp4';
  //
  bool _isPlaying = false;
  VideoPlayerController _controller;
  // VideoPlayerController videoPlayerController;
  // ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.url)
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: new Scaffold(
        body: new Center(
          child: _controller.value.initialized
              // 加载成功
              ? new AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : new Container(),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _controller.value.isPlaying
              ? _controller.pause
              : _controller.play,
          child: new Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /**
     * 页面销毁时，视频播放器也销毁
     */
    _controller.dispose();
    // chewieController.dispose();
    // super.dispose();
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
