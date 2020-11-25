// import 'dart:html';

// import 'dart:js';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';
import '../config/service_method.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List swiperDateList = [
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2583035764,1571388243&fm=26&gp=0.jpg",
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2771978851,2906984932&fm=26&gp=0.jpg",
      'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1546500353,2204894501&fm=26&gp=0.jpg'
    ];
    return Scaffold(
        body: FutureBuilder(
      future: getHomePageContent(),
      builder: (context, snapshot) {
        // print('请求完成${snapshot.connectionState}--->${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List allData = snapshot.data;

          //
          print('序列化----${allData.first.toString()}');
          // print('序列化----${snapshot.data}');

          Map<String, dynamic> navigationData =
              new Map<String, dynamic>.from(allData.first);
          print('序列化--data--${snapshot.data}');
          List navigatorList = getNavigationData(navigationData);
          List swiperDateList = getBannerData(allData.last);

          return Column(
            children: [
              SwiperDiy(swiperDateList: swiperDateList),
              TopNavigator(navigationList: navigatorList)
            ],
          );
        } else {
          return Center(
            child: Text('fdf'),
          );
        }
      },
    ));
  }

  List getNavigationData(Map data) {
    Map items_first = (data['data']['Items'] as List).first;
    List<Map<String, dynamic>> navigatorList =
        (items_first['category_list'] as List).cast(); // 顶部轮播组件数
    Map items_last = (data['data']['Items'] as List).last;
    print('序列化--navigatorList--${navigatorList}\n');
    List<Map<String, dynamic>> categotory =
        (items_last['category_list'] as List).cast();
    navigatorList.addAll(categotory);
    return navigatorList;
  }

  List getBannerData(Map data) {
    Map ad_zone_list = (data['data'] as List).first;
    List bannerList = ad_zone_list['ad_zone_list'] as List;
    return bannerList;
  }
  // Future getHomePageContent() async {
  //   try {
  //     Response response;
  //     final path =
  //         "https://apitest.hexiaoxiang.com/coursequality/api/v1/category/list?layer=1&platform=0";
  //     // servicePath['homePageContext'];
  //     response = await Dio().get(path);
  //     // print('结果--${response.data}');
  //     return response.data;
  //   } catch (err) {
  //     print('错误---$err');
  //   }
  // }

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
}

class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  const SwiperDiy({Key key, this.swiperDateList}) : super(key: key);
  // print('$swiperDateList');
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(300),
      color: Colors.red,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          var imageStr = this.swiperDateList[index];
          return Image.network(
            imageStr,
            fit: BoxFit.cover,
          );
        },
        itemCount: swiperDateList.length,
        // itemHeight: ScreenUtil().setHeight(100),
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigationList;
  const TopNavigator({Key key, this.navigationList}) : super(key: key);

  Widget _girdViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击分类');
      },
      child: Column(
        children: [
          Image.network(
            item["icon"],
            fit: BoxFit.contain,
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(50),
          ),
          Container(
            // height: ScreenUtil().setHeight(17),
            child: Text(
              item['title'],
              style: TextStyle(fontSize: 12, color: const Color(0xff726E6B)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(412),
      // color: Colors.red,
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
          crossAxisCount: 4,
          padding: EdgeInsets.all(5.0),
          children: this.navigationList.map((item) {
            return _girdViewItemUI(context, item);
          }).toList()),
    );
  }
}
