import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp/component/w_pop/action_item.dart';
import 'package:flutter_otp/component/w_pop/w_popup_menu.dart';
import 'package:flutter_otp/model/otp_detail.dart';

class A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '弹出菜单演示',
      home: new MenuHomePage(),
    );
  }
}

class MenuHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MenuHomePageState();
  }
}

class MenuHomePageState extends State<MenuHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<ActionItem> actions = [
    ActionItem(value: 'aa', title: '发起群聊', icon: Icon(Icons.cancel)),
    ActionItem(value: 'bb', title: '添加朋友', icon: Icon(Icons.cancel)),
    ActionItem(value: 'cc', title: '扫一扫', icon: Icon(Icons.cancel)),
    ActionItem(value: 'cc', title: '收付款', icon: Icon(Icons.cancel)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('弹出菜单演示'),
        actions: <Widget>[
          WPopupMenu(
            menuWidth: 150,
            menuHeight: 200,
            alignment: Alignment.center,
            onValueChanged: (String value) {
              print(value);
            },
            actions: actions,
            pageMaxChildCount: actions.length,
            child: new Container(
              margin: EdgeInsets.only(right: 16),
              child: Icon(Icons.add_circle_outline),
            ),
          )
        ],
      ),
      //这是屏幕主体包含一个中央空间，里面是一个文本内容以及字体大小
      body: Container(),
    );
  }
}

_otpUri() {
  // var url = 'otpauth://hotp/%E4%B8%AD%E5%9B%BD:bjdgyc%40com?secret=zlddoquewdteptqkopkelah3wgv2vvx65njb3smdu4t3p43texi53dnp&algorithm=SHA256&digits=6&period=30&counter=0';
  var url =
      'otpauth://hotp/%E4%B8%AD%E5%9B%BD:bjdgyc%40163.com?secret=e&counter=12';

  var uri = Uri.parse(url);
  print(uri.scheme);
  print(uri.host);
  print(uri.path);
  print(uri.pathSegments);
  print(uri.queryParameters);

  var scheme = uri.scheme.toLowerCase();
  var otype = uri.host.toUpperCase();
  var param = uri.queryParameters;

  //密钥判断
  var secret = param['secret'] ?? '';
  if (param['secret'] == '') {
    print('secret is nil');
  }
  //算法判断
  var algorithm = (param['algorithm'] ?? 'SHA1').toUpperCase();
  if (!(algorithm == 'SHA1' ||
      algorithm == 'SHA256' ||
      algorithm == 'SHA512')) {
    print('algorithm is err');
  }

  var digits = int.parse(param['digits'] ?? '6');
  var period = int.parse(param['period'] ?? '30');
  var counter = int.parse(param['counter'] ?? '0');

  //机构和用户判断
  var issuer = param['issuer'] ?? 'issuer';
  var account = uri.pathSegments[0];
  if (account.contains(':')) {
    var arr = account.split(':');
    issuer = arr[0];
    account = arr[1];
  }

  var o = OtpDetail(
    //raw: url,
    scheme: scheme,
    //otpauth
    otype: otype,
    account: account,
    issuer: issuer,
    secret: secret,
    digits: digits,
    period: period,
    counter: counter,
    algorithm: algorithm,
  );

  print(json.encode(o));
}
