import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import "category_page.dart";
import 'member_page.dart';
import 'home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: '首页'),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: '分类'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), label: '购物车'),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.memories), label: '我11的'),
  ];

  final List tabs = [HomePage(), CategoryPage(), CartPage(), MemberPage()];
  int _currentIndex = 0;
  // var

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      appBar: AppBar(
          //
          ),
      backgroundColor: Color.fromARGB(1, 244, 245, 245),
      body: this.tabs[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: this.bottomTabs,
        type: BottomNavigationBarType.fixed,
        currentIndex: this._currentIndex,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
      ),
    );
  }
}
