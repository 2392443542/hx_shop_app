import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_Controller_widget.dart';
import 'dart:io';

class VideoSlidePage extends StatefulWidget {
  VideoSlidePage({Key key}) : super(key: key);

  @override
  _VideoSlidePageState createState() => _VideoSlidePageState();
}

class _VideoSlidePageState extends State<VideoSlidePage> {
// 播放器
  VideoPlayerController get _controller =>
      VideoControllerWidget.of(context).controller;

  bool get videoInit => VideoControllerWidget.of(context).videoInit;
  double progressValue = 0; //进度

  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderThemeData(
          //进度条滑块左边颜色
          inactiveTrackColor: Colors.white,
          overlayShape: RoundSliderOverlayShape(
            //可继承SliderComponentShape自定义形状
            overlayRadius: 10, //滑块外圈大小
          ),
          thumbShape: RoundSliderThumbShape(
            //可继承SliderComponentShape自定义形状
            disabledThumbRadius: 7, //禁用是滑块大小
            enabledThumbRadius: 7, //滑块大小
          ),
        ),
        child: Slider(
          value: progressValue,
          divisions: 100,
          onChanged: (value) {},
        ));
  }

  @override
  void didUpdateWidget(VideoSlidePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (!_controller.value.hasError) {
        int position = _controller.value.position.inMilliseconds;
        int duration = _controller.value.duration.inMilliseconds;
        this.progressValue = position / duration;
      }
    });
  }
}
