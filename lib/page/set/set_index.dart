import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/component/divider_dart.dart';
import 'package:flutter_otp/component/util_fun.dart';
import 'package:flutter_otp/model/models.dart';
import 'package:flutter_otp/model/otp_prefs.dart';

import 'set_about.dart';

class SetIndex extends StatefulWidget {
  @override
  _SetIndexState createState() => _SetIndexState();
}

class _SetIndexState extends State<SetIndex> {
  String version = Models.packageInfo.version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('用户中心'),
      ),
      body: Container(
        child: Column(children: <Widget>[
          Container(
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text('令牌数量'),
              trailing: Text(OtpPrefs.getAllOtp().length.toString()),
            ),
          ),
          DividerWidget(10),
//          Container(
//            color: Colors.white,
//            child: ListTile(
//              contentPadding: EdgeInsets.symmetric(horizontal: 16),
//              title: Text('用户协议'),
//              trailing: Icon(Icons.chevron_right),
//            ),
//          ),
          Divider(height: 1),
          Container(
            color: Colors.white,
            child: ListTile(
              onTap: () {
                showSnackBar(context, '当前已经是最新版本');
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text('检查更新'),
              trailing: SizedBox(
                width: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('v$version'),
                      Icon(Icons.chevron_right)
                    ]),
              ),
            ),
          ),
          Divider(height: 1),
          Container(
            color: Colors.white,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (BuildContext context) => SetAbout()),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text('关于'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ]),
      ),
    );
  }
}
