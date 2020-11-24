// import 'dart:html';

// import 'dart:js';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getHttp();
    List swiperDateList = [
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2583035764,1571388243&fm=26&gp=0.jpg",
      "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2771978851,2906984932&fm=26&gp=0.jpg",
      'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1546500353,2204894501&fm=26&gp=0.jpg'
    ];
    return Scaffold(
        body: FutureBuilder(
      future: getHttp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = json.decode(snapshot.data.toString());
          List<Map> navigatorList = ((data['data']['Items'] as List).first
              as Map)['category_list']; // 顶部轮播组件数
          List<Map> secondCategory =
              ((data['data']['Items'] as List).last as Map)['category_list'];
          navigatorList.addAll(secondCategory);
          // var data=jso.decode(snapshot.data.toString());
          //
          //      List<Map> navigatorList =(data['data']['category'] as List).cast(); //类别列表
          //      String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
          //      String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
          //      String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话
          //      List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐
          //      String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
          //      String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
          //      String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
          //      List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
          //      List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
          //      List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片

          return Column(
            children: [
              SwiperDiy(swiperDateList: swiperDateList),
              TopNavigator()
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

  Future getHttp() async {
    try {
      Response response;
      final path =
          "https://apitest.hexiaoxiang.com/coursequality/api/v1/category/list?layer=1&platform=0";
      // servicePath['homePageContext'];

      // "https://apitest.hexiaoxiang.com/coursequality/api/v1/information/flow/recommend?last_index=0&platform=0";
      response = await Dio().get(path);
      print('结果--${response.data}');
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
  final List navigationDateList;
  const TopNavigator({Key key, this.navigationDateList}) : super(key: key);

  Widget _girdViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击分类');
      },
      child: Column(
        children: [
          Image.network(
            item["image"],
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['text']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List navigationList = [
      {
        "image":
            "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2583035764,1571388243&fm=26&gp=0.jpg",
        "text": "标题1"
      },
      {
        "image":
            "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2583035764,1571388243&fm=26&gp=0.jpg",
        "text": "标题2"
      },
      {
        "image":
            "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2583035764,1571388243&fm=26&gp=0.jpg",
        "text": "标题3"
      },
      {
        "image":
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1546500353,2204894501&fm=26&gp=0.jpg",
        "text": "标题4"
      },
      {
        "image":
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1546500353,2204894501&fm=26&gp=0.jpg",
        "text": "标题5"
      },
      {
        "image":
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1546500353,2204894501&fm=26&gp=0.jpg",
        "text": "标题6"
      }
    ];
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigationList.map((item) {
            return _girdViewItemUI(context, item);
          }).toList()),
    );
  }
}
