// import 'dart:html';

// import 'dart:js';

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';
import '../config/service_method.dart';
import 'home_page_recommend.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List recommendList = [];
  List swiperDateList = [];
  List navigatorList = [];
  EasyRefreshController _refreshcontroller;
  HomePageRecommend recomendView = HomePageRecommend();
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    _refreshcontroller = EasyRefreshController();

    _getcardList();
    _getCategory();
    _getRecommend(pageIndex);
  }

  _getcardList() {
    homeBannerPageContext().then((value) {
      setState(() {
        swiperDateList = getBannerData(value);
        // print('homeBannerPageContext:${swiperDateList}');
      });
    });
  }

  _getCategory() {
    homeCategoryPageContext().then((value) {
      setState(() {
        // print("哈哈:$value");
        navigatorList = getNavigationData(value);
      });
    });
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
      body: EasyRefresh(
          controller: _refreshcontroller,
          footer: ClassicalFooter(
            // key: _footerKey,
            bgColor: Colors.white,
            textColor: Colors.pink,
            infoColor: Colors.pink,
            showInfo: true,
            noMoreText: '',
            infoText: '加载中',
            loadReadyText: '上拉加载....',
          ),
          child: ListView(
            children: [
              Container(
                height: ScreenUtil().setHeight(272),
                child: swiperDateList.length > 0
                    ? SwiperDiy(swiperDateList: swiperDateList)
                    : Image.asset('assets/placeholder/img_default_16_9.png'),
              ),
              Container(
                  height: ScreenUtil().setHeight(300),
                  child: TopNavigator(navigationList: navigatorList)),
              // _getRecommendUI(),
              recomendView,
            ],
          ),
          onLoad: () async {
            pageIndex = pageIndex + 1;
            _getRecommend(pageIndex);
          }),
    );
  }

  List getNavigationData(Map data) {
    List items = data['Items'];
    Map items_first = items.first;
    // print('navigationList:${items_first}');
    List<Map<String, dynamic>> navigatorList =
        (items_first['category_list'] as List).cast(); // 顶部轮播组件数
    Map items_last = items.last;

    List<Map<String, dynamic>> categotory =
        (items_last['category_list'] as List).cast();
    navigatorList.addAll(categotory);

    return navigatorList;
  }

  List getBannerData(data) {
    Map dataFirst = (data as List).first;

    Map ad_zone_list = (dataFirst['ad_zone_list'] as List).first;
    List bannerList = ad_zone_list['ad_list'];
    return bannerList;
  }

  void _getRecommend(int pageIndex) {
    getHomeRecommendList(pageIndex).then((value) {
      var data = value as Map;
      setState(() {
        recommendList = data["Items"] as List;
        recomendView.getRecommend(recommendList);
      });
    });
  }

  Widget _recommendCell(value) {
    String imageUrl;
    String title;
    List tag;
    imageUrl = value["cover"] as String;
    title = value["title"] as String;
    tag = (value['flag'] as List).cast();

    List<Widget> _getTag() {
      Widget widget;
      List<Widget> tagUI = [];
      if (tag.length > 0) {
        int count = tag.length > 2 ? 2 : tag.length;
        for (var i = 0; i < count; i++) {
          String value = tag[i] as String;
          // if (i == 0) {
          widget = Container(
            height: ScreenUtil().setWidth(40),
            alignment: Alignment.center,
            // margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFFE69256),
                fontSize: ScreenUtil().setWidth(24),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFFF2B4),
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(20)),
              ),
            ),
          );

          tagUI.add(widget);
        }
      }
      return tagUI;
    }

    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(330),
        // height: ScreenUtil().setWidth(498),
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(32), 0, 0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(36)),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder/img_default_1_1.png',
                image: imageUrl,
              ),
              // Image.network(
              //   imageUrl,
              //   fit: BoxFit.contain,
              // ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setWidth(20),
              ),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF726E6B),
                  fontSize: ScreenUtil().setWidth(32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Row(
                children: _getTag(),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _getRecommendCellList() {
    try {
      if (recommendList.length > 0) {
        List<Widget> cellList = recommendList.map((e) {
          if (e != null) {
            return _recommendCell(e);
          }
        }).toList();
        return cellList;
      }
    } catch (e) {
      print('课节error ${e}');
    }
  }

  Widget _getRecommendUI() {
    if (recommendList.length > 0) {
      return Container(
        child: Wrap(
            spacing: ScreenUtil().setWidth(20),
            children: _getRecommendCellList(),
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.start),
      );
    } else {
      return Text('');
    }
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
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder/img_default_16_9.png',
              image: imageStr,
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
          FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder/img_default_1_1.png',
            image: item["icon"],
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
