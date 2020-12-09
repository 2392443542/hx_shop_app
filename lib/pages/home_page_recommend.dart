// import 'dart:html';

// import 'dart:js';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../config/service_url.dart';
import '../config/service_method.dart';

class HomePageRecommend extends StatefulWidget {
  final List recommendLists = List();
  HomePageRecommend({Key key}) : super(key: key);
  _HomePageRecommendState state;
  @override
  _HomePageRecommendState createState() {
    state = _HomePageRecommendState();
    return state;
  }

  void getRecommend(List data) {
    recommendLists.addAll(data);
    state.getRecommend(recommendLists);
  }
}

class _HomePageRecommendState extends State<HomePageRecommend> {
  List recommendList = List();
  List<Widget> recommendCellList = List();
  Map datas = {};
  List dataList;
  int userId;
  // _HomePageRecommendState({this.recommendList});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getRecommend(0);
  }

  void getRecommend(List data) {
    setState(() {
      print("刷新3");
      recommendList = data;
    });
    //   getHomeRecommendList(pageIndex).then((value) {
    //     var data = value["data"] as Map;
    //     // print("数据请求完成 ${data}");
    //     setState(() {
    //       // recommendList = data["Items"] as List;
    //     });
    //   });
  }

  Widget _recommendCell(value) {
    String imageUrl;
    String title;
    List tag;
    // List<Widget> tagUI;

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

  @override
  Widget build(BuildContext context) {
    void getRecommend(List list) {
      setState(() {
        recommendList = list;
      });
    }

    return _getRecommendUI();
  }
}
