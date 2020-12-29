import "package:dio/dio.dart";
import 'package:flutter/material.dart';
// import 'package:flutter_shop/config/httpHeaders.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';
// import '../config/httpHeaders.dart';

/*
     * 请求code列表及说明
     * 错误代码   代码描述
     * 20000    正确
     * 20001    正确, 需要返回微信信息
     * 20002    正确, 重定向
     * 30001    拼团已满
     * 40003    需要登录
     * 40013    拒绝操作
     * 40023    参数不规范或者缺少参数
     * 40033    权限不够拒绝操作
     */

Future requestPost(url, formData) async {
  String successCode = "20000,20001,20002";
  Response response;
  Dio dio = new Dio();

  try {
    dio.options.contentType = 'application/json;charset=UTF-8';
    // var formData = {
    //   'platform': 0,
    //   'uid': 3987158,
    //   'query_param': [
    //     {'page_size': 30, 'banner_zone_id': 2, 'type': 2, 'page': 1}
    //   ]
    // };
    // // final path = servicePath['homeBannerPageContext'];
    // final path = 'https://apitest.hexiaoxiang.com/advertisement/ad/list';
    // print('请求路径  $path');
    response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data as Map<String, dynamic>;

      int code = result['code'] as int;
      if (code == 20000 || code == 20001 || code == 20002) {
        return result['data'];
      } else {
        print('path:$url \n error:${result}');
      }
      // return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    print('ERROR:======>${e}');
  }
}

Future requestGet(url, {params}) async {
  try {
    Response response = Response();
    if (params == null) {
      response = await Dio().get(url);
    } else {
      response = await Dio().get(url, queryParameters: params);
      // return response.data;
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data as Map<String, dynamic>;

      int code = result['code'] as int;
      if (code == 20000 || code == 20001 || code == 20002) {
        return result['data'];
      } else {
        print('path:$url \n error:${result}');
      }
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (err) {
    print("网络请求错误 $err");
  }
}

Future homeBannerPageContext() async {
  var formData = {
    'platform': 0,
    'uid': 3987158,
    'query_param': [
      {'page_size': 30, 'banner_zone_id': 2, 'type': 2, 'page': 1}
    ]
  };
  final path = servicePath['homeBannerPageContext'];
  return await requestPost(path, formData);
}

Future homeCategoryPageContext() async {
  final path = servicePath['homeCategoryPageContext'];
  var data = await requestGet(path);
  if (data != null) {
    return data;
  }
}

//获得商城首页信息的方法
Future getHomePageContent() async {
  return Future.wait([homeBannerPageContext(), homeCategoryPageContext()]);
}

Future getHomeRecommendList(int last_index) async {
  String path =
      "https://apitest.hexiaoxiang.com/coursequality/api/v1/information/flow/recommend?last_index=${last_index}&platform=0";
  // print('开始获取首页推荐数据...............${path}');
  return await requestGet(path);
}
