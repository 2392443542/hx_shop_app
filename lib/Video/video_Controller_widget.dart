import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_control.dart';

class VideoControllerWidget extends InheritedWidget {
  VideoControllerWidget(
      {this.controlKey,
      this.child,
      this.controller,
      this.videoInit,
      this.title});

  final String title;
  final GlobalKey<VideoControlPageState> controlKey;
  final Widget child;
  final VideoPlayerController controller;
  final bool videoInit;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static VideoControllerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoControllerWidget>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}
