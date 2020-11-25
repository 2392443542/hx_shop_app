import 'package:flutter/material.dart';
import '../config/service_url.dart';
import '../config/service_method.dart';
import 'package:dio/dio.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // getHomePageContent();
    return Scaffold(
      body: Center(
        child: Text('分类'),
      ),
    );
  }
}

Future getHttp() async {
  try {
    Response response;
    final path =
        "https://apitest.hexiaoxiang.com/coursequality/api/v1/category/list?layer=1&platform=0";
    // servicePath['homePageContext'];

    // "https://apitest.hexiaoxiang.com/coursequality/api/v1/information/flow/recommend?last_index=0&platform=0";
    response = await Dio().get(path);
    // print('结果--${response.data}');
    return response.data;
  } catch (err) {
    print('错误---$err');
  }
}
