import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class LightVideoPage extends StatefulWidget {
  LightVideoPage({Key key}) : super(key: key);

  @override
  _LightVideoPageState createState() => _LightVideoPageState();
}

class _LightVideoPageState extends State<LightVideoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text("data"),
        ),
      ),
    );
  }
}
