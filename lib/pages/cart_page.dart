import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:screen/screen.dart';
import '../common/video/video_player_UI.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);
  Size get _window => MediaQueryData.fromWindow(window).size;
  // bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  Widget build(BuildContext context) {
    // 记录当前设备是否横屏，后续用到
    bool _isFullScreen =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;

    // ScreenUtil.
    return Scaffold(
      body: Container(
        child:VideoPlayerUI.asset(dataSource: "/assets/MP4/video.mp4",
          width: _isFullScreen ? vh : vw,
          height: _isFullScreen ? vw : vw / 16 * 9, // 竖屏时容器为16：9
        ),
        
        // VideoPlayerUI.network(
        //   // 这个是等会儿要编写的组件
        //   url:
        //       'https://glb-vod.hexiaoxiang.com/f3b4e9eaa3f44b93ada39a0a797209f4/74b1619bdda44b86919811b9c8fcc69f-9cbe865ed7c1709df5a29082b97f02a1-fd.mp4',
        //   title: '示例视频',
        //   // 这个vw是MediaQueryData.fromWindow(window).size.width屏幕宽度
        //   width: _isFullScreen ? vh : vw,
        //   height: _isFullScreen ? vw : vw / 16 * 9, // 竖屏时容器为16：9
        // ),
      ),
    );
  }
}
