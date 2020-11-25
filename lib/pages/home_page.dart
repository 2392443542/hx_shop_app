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
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(272),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List swiperDateList = getBannerData(snapshot.data);
                  return SwiperDiy(swiperDateList: swiperDateList);
                } else {
                  return Text('加载中');
                }
              },
              future: homeBannerPageContext(),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(300),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List navigatorList = getNavigationData(snapshot.data);
                  return TopNavigator(navigationList: navigatorList);
                } else {
                  return Text('加载中');
                }
              },
              future: homeCategoryPageContext(),
            ),
          ),
        ],
      ),
    );
  }

  List getNavigationData(Map data) {
    Map items_first = (data['data']['Items'] as List).first;
    List<Map<String, dynamic>> navigatorList =
        (items_first['category_list'] as List).cast(); // 顶部轮播组件数
    Map items_last = (data['data']['Items'] as List).last;

    List<Map<String, dynamic>> categotory =
        (items_last['category_list'] as List).cast();
    navigatorList.addAll(categotory);
    return navigatorList;
  }

  List getBannerData(Map data) {
    Map dataFirst = (data['data'] as List).first;

    Map ad_zone_list = (dataFirst['ad_zone_list'] as List).first;
    List bannerList = ad_zone_list['ad_list'];
    return bannerList;
  }
}

class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  const SwiperDiy({Key key, this.swiperDateList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(272),
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          Map bannerData = this.swiperDateList[index];
          var imageStr = bannerData["image_url"];
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageStr,
              fit: BoxFit.cover,
            ),
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
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(40),
          ),
          Container(
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
      child: GridView.count(
          crossAxisCount: 4,
          padding: EdgeInsets.all(5.0),
          crossAxisSpacing: 1.0,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 1.0,
          childAspectRatio: 1.5,
          children: this.navigationList.map((item) {
            return _girdViewItemUI(context, item);
          }).toList()),
    );
  }
}
