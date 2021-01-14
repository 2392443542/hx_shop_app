import 'package:flutter/material.dart';
import 'pages/index_pages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Video/light_video.dart';
import 'package:flutter/services.dart';

const String LightVideo = '/light/video';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var routes = <String, WidgetBuilder>{
    LightVideo: (BuildContext context) => LightVideoPage(),
  };


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      routes: routes,

      // builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("video"),
        ),
        body: Container(
          child: IndexPage(),
        ),
      ),
    );
  }
}
