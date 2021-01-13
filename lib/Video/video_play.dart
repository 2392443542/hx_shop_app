import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_control.dart';
import 'video_Controller_widget.dart';

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
    {
  final GlobalKey<VideoControlPageState> _key =
      GlobalKey<VideoControlPageState>();
  String url =
      'https://glb-vod.hexiaoxiang.com/f3b4e9eaa3f44b93ada39a0a797209f4/74b1619bdda44b86919811b9c8fcc69f-9cbe865ed7c1709df5a29082b97f02a1-fd.mp4';
  //
  bool _isPlaying = false;
  bool _playerError = false;
  VideoPlayerController _controller;
  // VideoPlayerController videoPlayerController;
  // ChewieController chewieController;
  // @override
  // bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("/assets/MP4/video.mp4")
      // 播放状态
      // ..addListener(() async {
      //   if (_controller.value.hasError) {
      //     _playerError = true;
      //   } else {
      //     final bool isPlaying = _controller.value.isPlaying;
      //     if (isPlaying) {
      //       if (isPlaying != _isPlaying) {
      //         setState(() {
      //           _isPlaying = isPlaying;
      //         });
      //       }

      //       //          int position = controller.value.position.inMilliseconds;
      //       // int duration = controller.value.duration.inMilliseconds;
      //       Duration position = await _controller.position;
      //       Duration total = _controller.value.duration;
      //       print("video time ${_controller.position} -- ${_key.currentState}");
      //       if (position >= total) {
      //         await _controller.seekTo(Duration(seconds: 0));
      //         await _controller.pause();
      //       } else {
      //         _key.currentState.setPositionAndTotalDuration(position, total);
      //       }
      //     }
      //   }
      // })

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
    print("播放");
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

      print("播放  ${res}  ${_key.currentState}");
      if (_controller.value.isPlaying && _key.currentState != null) {
        /// 减少build次数
        print("video time ${_controller.position}");
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
          width: widget.width,
          height: widget.height,
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
        // 加载成功
        ? new AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : new Container();
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
