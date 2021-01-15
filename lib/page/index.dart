import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/component/util_fun.dart';
import 'package:flutter_otp/model/models.dart';
import 'package:flutter_otp/model/otp_prefs.dart';
import 'package:flutter_otp/page/test/index.dart';
import 'package:flutter_otp/page/set/set_index.dart';
import 'package:flutter_otp/screenutil/screenutil.dart';

import 'otp/otp_index.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<Widget> indexPage = [OtpIndex(), SetIndex(), A()];

  //统一执行初始化操作
  Future<bool> _initAsync() async {
    //Models初始化
    await Models.init();
    //shared_preferences
    var res = await OtpPrefs.init();
    print("OtpPrefs init: $res");
    return true;
  }

  final tabBars = [
    BottomNavigationBarItem(
      label: "首页",
      icon: Icon(Icons.home),
      activeIcon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: "设置",
      icon: Icon(Icons.settings),
      activeIcon: Icon(Icons.settings),
    ),
    BottomNavigationBarItem(
      label: "测试",
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //模拟器 750 x 1334 dpi:320
    //ScreenUtil.init(context, width: 750, height: 1334);
    ScreenUtil.initDp(context, wdp: 375, hdp: 667);

    var data = MediaQuery.of(context);
    print("textScaleFactor ${data.textScaleFactor}");

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: tabBars,
        currentIndex: _currentIndex,
        onTap: (inx) {
          setState(() {
            _currentIndex = inx;
            _pageController.jumpToPage(inx);
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
      body: FutureBuilder(
        future: _initAsync(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }

          return HoldPage(indexPage: indexPage, pageController: _pageController);
        },
      ),
    );
  }
}

//添加返回拦截
class HoldPage extends StatefulWidget {
  final List<Widget> indexPage;
  final PageController pageController;

  HoldPage({Key key, this.indexPage, this.pageController}) : super(key: key);

  @override
  _HoldPageState createState() => _HoldPageState();
}

class _HoldPageState extends State<HoldPage> {
  DateTime _lastPressedAt;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 2)) {
          //两次点击间隔超过2秒则重新计时
          _lastPressedAt = DateTime.now();
          print('2');
          showSnackBar(context, '再按一次返回键退出');
          return false;
        }
        print('1');
        return true;
      },
      child: PageView(
          children: widget.indexPage,
          controller: widget.pageController,
          physics: NeverScrollableScrollPhysics()),
    );
  }
}
