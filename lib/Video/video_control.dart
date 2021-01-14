import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_Controller_widget.dart';
import 'video_slider.dart';
import 'dart:async';
import 'package:common_utils/common_utils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

class VideoControlPage extends StatefulWidget {
  VideoControlPage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  VideoControlPageState createState() => VideoControlPageState();
}

class VideoControlPageState extends State<VideoControlPage> {
  VideoPlayerController get controller =>
      VideoControllerWidget.of(context).controller;
  // 记录video播放进度
  Duration _position = Duration(seconds: 0);
  Duration _totalDuration = Duration(seconds: 0);
  bool get isPlaying => controller.value.isPlaying;
  bool _isFullScreen = false;
  MethodChannel _channel = const MethodChannel('flutter_ios_device');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlatformState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]).then((_) {
    //   if (Platform.isIOS) {
    //     this.changeScreenOrientation(DeviceOrientation.landscapeRight);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _bottomControl(context),
      ],
    );
  }

  Widget _topControl() {
    return Positioned(
      left: 0,
      top: 0,
      child: Offstage(
        offstage: false,
        child: Container(
          // color: Colors.orange,
          child: InkWell(
            child: Image.asset("assets/video/navigationBar-back.png"),
          ),
        ),
      ),
    );
  }

  Widget _bottomControl(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Offstage(
        offstage: false,
        child: Container(
          height: 50,
          margin: EdgeInsets.only(left: 6, right: 6),
          // color: Colors.black87,
          child: Row(
            children: [
              InkWell(
                child: Image.asset(isPlaying
                    ? "assets/video/video_pause.png"
                    : "assets/video/video_play.png"),
                onTap: playorPause,
              ),
              Container(
                margin: EdgeInsets.only(left: 13, right: 7),
                child: Text(
                  updateValue(),
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    // color: Colors.redAccent,
                    child: VideoSlidePage()),
              ),
              Container(
                margin: EdgeInsets.only(left: 7, right: 7),
                child: Text(
                  totalValue(),
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6),
                child: InkWell(
                  child: Image.asset("assets/video/video_orientition.png"),
                  onTap: changeOrientation,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void playorPause() {
    controller.value.isPlaying ? pause() : play();
  }

  void play() {
    controller.play();
  }

  void pause() {
    controller.pause();
  }

  // 供父组件调用刷新页面，减少父组件的build
  void setPositionAndTotalDuration(Duration position, Duration totalDuration) {
    setState(() {
      // print('播放进度${position}');
      setState(() {
        _position = position;
        _totalDuration = totalDuration;
      });
    });
  }

  String updateValue() {
    return DateUtil.formatDateMs(
      _position?.inMilliseconds,
      format: 'mm:ss',
    );
  }

  String totalValue() {
    return DateUtil.formatDateMs(
      _totalDuration?.inMilliseconds,
      format: 'mm:ss',
    );
  }

  Future<void> changeScreenOrientation(DeviceOrientation orientation) {
    String o;
    switch (orientation) {
      case DeviceOrientation.portraitUp:
        o = 'portraitUp';
        break;
      case DeviceOrientation.portraitDown:
        o = 'portraitDown';
        break;
      case DeviceOrientation.landscapeLeft:
        o = 'landscapeLeft';
        break;
      case DeviceOrientation.landscapeRight:
        o = 'landscapeRight';
        break;
    }
    return _channel.invokeMethod('change_screen_orientation', [o]);
  }

  void changeOrientation() {
    if (_isFullScreen) {
      _isFullScreen = false;

      /// 如果是全屏就切换竖屏
      AutoOrientation.portraitAutoMode();

      ///显示状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    } else {
      _isFullScreen = true;
      AutoOrientation.landscapeAutoMode();

      ///关闭状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }
}
