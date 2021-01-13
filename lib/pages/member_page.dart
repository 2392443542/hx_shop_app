import 'package:flutter/material.dart';
import '../Video/video_play.dart';
import 'dart:ui';

class MemberPage extends StatelessWidget {
  const MemberPage({Key key}) : super(key: key);
  Size get _window => MediaQueryData.fromWindow(window).size;
  // bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  Widget build(BuildContext context) {
    // 记录当前设备是否横屏，后续用到
    bool _isFullScreen =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        // width: 300,
        // height: 300,
        child: VideoPlayerPage(
          width: _window.width,
          height: _window.width * 9 / 16.0,
        ),
      ),
    );
  }
}

// class MemberPage extends StatefulWidget {
//   MemberPage({Key key}) : super(key: key);

//   @override
//   _MemberPageState createState() => _MemberPageState();

// }

// class _MemberPageState extends State<MemberPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // width: 300,
//         // height: 300,
//         child: VideoPlayerPage(
//           width: 300.0,
//           height: 400.0,
//         ),
//       ),
//     );
//   }
// }
