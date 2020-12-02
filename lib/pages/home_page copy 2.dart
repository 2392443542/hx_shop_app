// import 'dart:html';

// import 'dart:js';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';
import '../config/service_method.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print(this.widget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            // color: Colors.red,
            width: ScreenUtil().setWidth(90),
            alignment: Alignment.centerLeft,
            child: Text(
              '我的课程',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setWidth(20),
                color: Color(0xff726E6B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print('我的课程');
            },
            child: Container(
              width: ScreenUtil().setWidth(50),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(18), 0, ScreenUtil().setWidth(20), 0),
              color: Colors.blue,
              child: Image.asset(
                'assets/appbar/lx_light_class_top_arrow.png',
              ),
            ),
          )
        ],
        title: Text(
          '轻课堂',
          style: TextStyle(color: Colors.black),
        ),
      ),
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
          HomePageRecommend(),
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
        autoplay: true,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: Colors.white,
          ),
        ),
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

class HomePageRecommend extends StatefulWidget {
  HomePageRecommend({Key key}) : super(key: key);
  // final List<Widget> recommendList = List();
  @override
  _HomePageRecommendState createState() => _HomePageRecommendState();
}

class _HomePageRecommendState extends State<HomePageRecommend> {
  List recommendList = List();
  List<Widget> recommendCellList = List();
  _HomePageRecommendState({this.recommendList});

  void _getRecommend() {
    getHomeRecommendList().then((value) {
      var data = value["data"] as Map;
      setState(() {
        recommendList = data["Items"] as List;

        _getRecommendCellList();
        // print("数据请求完成 ${recommendList}");
      });
    });
  }

  Widget _recommendCell(value) {
    String imageUrl;
    String title;
    List<Widget> tag;
    setState(() {
      imageUrl = value["cover"] as String;
      title = value["title"] as String;
      tag = ((value['flag'] as List).cast()).map((e) {
        return Text('$e');
      }).toList();
    });

    return InkWell(
      child: Container(
        child: Column(
          children: [
            Image.network(
              imageUrl,
              width: ScreenUtil().setWidth(375),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
            ),
            Row(
              children: tag,
            )
          ],
        ),
      ),
    );
  }

  void _getRecommendCellList() {
    recommendCellList = recommendList.map((e) {
      return _recommendCell(e);
    }).toList();
    print("数据请求完成 ${recommendCellList}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getRecommend();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 2,
        children: recommendCellList,
      ),
    );
  }
}
