import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp/component/util_fun.dart';
import 'package:flutter_otp/dotp/otp.dart';
import 'package:flutter_otp/model/all_otp.dart';
import 'package:flutter_otp/model/otp_detail.dart';
import 'package:flutter_otp/model/otp_prefs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_otp/screenutil/screenutil.dart';

class OtpItem extends StatefulWidget {
  final OtpDetail otp;
  final int index;

  const OtpItem({Key key, this.otp, this.index}) : super(key: key);

  @override
  _OtpItemState createState() => _OtpItemState();
}

//otp列表
class _OtpItemState extends State<OtpItem> {
  static double indicatorSize = 60;
  static Color tgreen = Colors.green[600];
  static Color tred = Colors.red[300];

  int remainSeconds = 0;
  double indicatorValue = 0;
  String tcode = '******';
  Color tcolor = Colors.green[600];
  Timer t;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print('initState' + widget.otp.key);

    var inxL = context.read<AllOtp>();
    if (widget.index == inxL.disIndex) {
      //第一次初始化
      _initCode();
    }
    //监听disIndex
    inxL.addListener(() {
      if (inxL.disIndex == widget.index) {
        _initCode();
      } else {
        _cancelCode();
      }
    });
  }

  _initCode() {
    if (t != null && t.isActive) {
      return;
    }
    _getTcode();
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      _getTcode();
    });
  }

  _cancelCode() {
    if (t == null) {
      return;
    }
    t.cancel();
    t = null;
    tcode = '******';
    tcolor = tgreen;
    remainSeconds = 0;
    indicatorValue = 0;
  }

  _getTcode() {
    var algorithm = Algorithm.SHA1;
    switch (widget.otp.algorithm) {
      case 'SHA1':
        algorithm = Algorithm.SHA1;
        break;
      case 'SHA256':
        algorithm = Algorithm.SHA256;
        break;
      case 'SHA512':
        algorithm = Algorithm.SHA512;
        break;
    }
    var milliseconds = DateTime.now().millisecondsSinceEpoch;
    tcode = OTP.generateTOTPCodeString(
      widget.otp.secret,
      milliseconds,
      algorithm: algorithm,
      length: widget.otp.digits,
      interval: widget.otp.period,
      isGoogle: true,
    );

    var seconds = (milliseconds / 1000).floor();
    var step = widget.otp.period;

    if (mounted) {
      setState(() {
        remainSeconds = step - (seconds % step);
        indicatorValue = remainSeconds / step;
        if (remainSeconds < 6) {
          tcolor = tred;
        } else {
          tcolor = tgreen;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 15.0, //设置阴影
      //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))), //设置圆角
      child: InkWell(
        onTap: () {
          //点击令牌行
          context.read<AllOtp>().upIndex(widget.index);
          _getTcode();
          Clipboard.setData(ClipboardData(text: tcode)).then((value) {
            showSnackBar(context, "复制口令成功 " + tcode);
          });
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: <Widget>[
                    //进度显示
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          //限制进度条的高度
                          height: indicatorSize,
                          //限制进度条的宽度
                          width: indicatorSize,
                          child: CircularProgressIndicator(
                              //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                              value: indicatorValue,
                              //背景颜色
                              backgroundColor: Colors.grey[100],
                              strokeWidth: 2.5,
                              //进度颜色
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(tcolor)),
                        ),
                        Container(
                          height: indicatorSize,
                          width: indicatorSize,
                          alignment: Alignment.center,
                          child: Text(
                            '$remainSeconds',
                            textScaleFactor: 1.1,
                            style: TextStyle(color: Colors.green[300]),
                          ),
                        ),
                      ],
                    ),
                    //令牌信息
                    Container(
                      // 230
                      constraints:
                          BoxConstraints(maxWidth: ScreenUtil().uiWdp - 140.0),
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tcode,
                            textScaleFactor: 2.3,
                            style: TextStyle(
                              color: tcolor,
                              fontWeight: FontWeight.w900,
                              //fontSize: 24,
                              letterSpacing: 2,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              widget.otp.issuer,
                              textScaleFactor: 1.1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                //fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            widget.otp.account,
                            textScaleFactor: 0.95,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              //fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //右侧编辑图标
              PopupMenuButton(
                tooltip: '点击操作',
                onSelected: (String menu) {
                  if (menu == 'delete') {
                    _showDelete();
                  }
                  if (menu == 'edit') {
                    _showEdit();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('编辑'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('删除'),
                  ),
                ],
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDelete() async {
    final bcontext = context;
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('确认删除 ${widget.otp.account} 吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () async {
                //TODO 处理删除操作
                await OtpPrefs.removeOtp(widget.otp.key);
                bcontext.read<AllOtp>().update();
                showSnackBar(bcontext, "删除令牌成功");
                Navigator.of(context).pop('ok');
              },
            ),
          ],
        );
      },
    );
  }

  _showEdit() async {
    final bcontext = context;
    final _formKey = GlobalKey<FormState>();

    return await showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: SimpleDialog(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Text('编辑令牌'),
            children: <Widget>[
              TextFormField(
                initialValue: widget.otp.issuer,
                decoration: InputDecoration(
                  icon: Icon(Icons.people),
                ),
                validator: (String value) {
                  value = value.trim();
                  widget.otp.issuer = value;
                  return value.length >= 2 ? null : '机构名最少2个字符';
                },
              ),
              TextFormField(
                initialValue: widget.otp.account,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                ),
                validator: (String value) {
                  value = value.trim();
                  widget.otp.account = value;
                  return value.length >= 2 ? null : '用户名最少2个字符';
                },
              ),
              TextFormField(
                initialValue: widget.otp.secret,
                readOnly: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop('cancel');
                        },
                      ),
                      RaisedButton(
                        child: Text('保存'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          var _state = _formKey.currentState;
                          if (_state.validate()) {
                            await OtpPrefs.setOtp(widget.otp.key, widget.otp);
                            //修改成功
                            bcontext.read<AllOtp>().update();
                            showSnackBar(bcontext, "编辑令牌成功");
                            Navigator.of(context).pop('ok');
                          }
                        },
                      ),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
