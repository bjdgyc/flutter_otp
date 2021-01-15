import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/model/all_otp.dart';
import 'package:flutter_otp/screenutil/screenutil.dart';
import 'package:flutter_otp/component/util_fun.dart';
import 'package:provider/provider.dart';

import 'opt_add.dart';
import 'otp_item.dart';
import 'otp_scan.dart';


class OtpIndex extends StatefulWidget {
  @override
  _OtpListState createState() => _OtpListState();
}

class _OtpListState extends State<OtpIndex>
    with AutomaticKeepAliveClientMixin {
  static const double RightPadding = 16;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  //展示弹出菜单
  _showMenu() async {
    var items = <PopupMenuEntry>[
      PopupMenuItem(
        value: "scan",
        //height: kMinInteractiveDimension,
        child: Row(children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.camera_alt),
          ),
          Text('扫码添加')
        ]),
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        value: "hand",
        //height: kMinInteractiveDimension,
        child: Row(children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.add_box),
          ),
          Text('手动填写')
        ]),
      ),
    ];
    
    
    var topH = kToolbarHeight + ScreenUtil.statusBarHeight;
    //print(topH);

    var menu = await showMenu(
      //color: Color.fromRGBO(75, 75, 75, 1.0),
      //color: Colors.grey[800],
      context: context,
      //left > right
      position: RelativeRect.fromLTRB(10, topH, 1, 0),
      items: items,
    );

    var res = '';
    if (menu == 'scan') {
      res = await OtpScan.initScan(context);
    }
    if (menu == 'hand') {
      res = await Navigator.of(context).push(
        CupertinoPageRoute(builder: (BuildContext context) => OtpAdd()),
      );
    }
    if (res == 'ok') {
      //添加成功,刷新数据
      context.read<AllOtp>().update();
      showSnackBar(context, "添加令牌成功");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        //brightness: Brightness.dark,
        centerTitle: true,
        title: Text('FLUTTER_OTP'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: RightPadding),
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              onPressed: _showMenu,
            ),
          )
        ],
      ),
      body: ListView(children: _otpList()),
    );
  }

  _otpList() {
    var lis = <Widget>[];
    var otps = context.watch<AllOtp>().allOtp;
    var n = -1;
    for (var item in otps) {
      n++;
      lis.add(
        OtpItem(
          key: ValueKey(item.key),
          otp: item,
          index: n,
        ),
      );
    }
    return lis;
  }
}
