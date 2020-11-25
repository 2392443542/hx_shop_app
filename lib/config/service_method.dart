import "package:dio/dio.dart";
// import 'package:flutter_shop/config/httpHeaders.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';
// import '../config/httpHeaders.dart';

Future request(url, {formData}) async {
  try {
    //print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded") as String;
    // dio.options = httpHeaders;
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future homeBannerPageContext() async {
  try {
    print('开始获取首页数据...............');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = 'application/json;charset=UTF-8';
    var formData = {
      'platform': 0,
      'uid': 3987158,
      'query_param': [
        {'page_size': 30, 'banner_zone_id': 2, 'type': 2, 'page': 1}
      ]
    };
    // final path = servicePath['homeBannerPageContext'];
    final path = 'https://apitest.hexiaoxiang.com/advertisement/ad/list';
    print('请求路径  $path');
    response = await dio.post(path, data: formData);

    if (response.statusCode == 200) {
      // print(response);
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    return print('ERROR:======>${e}');
  }
}

Future homeCategoryPageContext() async {
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

//获得商城首页信息的方法
Future getHomePageContent() async {
  return Future.wait([
    homeCategoryPageContext(),
    homeBannerPageContext(),
  ]);
}
