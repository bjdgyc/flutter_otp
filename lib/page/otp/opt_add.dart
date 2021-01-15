import 'package:flutter/material.dart';
import 'package:flutter_otp/model/otp_detail.dart';
import 'package:flutter_otp/model/otp_prefs.dart';
import 'package:base32/base32.dart';

class OtpAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('添加令牌'),
      ),
      body: _OtpAdd(),
    );
  }
}

class _OtpAdd extends StatefulWidget {
  @override
  _OtpAddState createState() => _OtpAddState();
}

class _OtpAddState extends State<_OtpAdd> {
  OtpDetail otpDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpDetail = initOtp();
  }

  initOtp() {
    return OtpDetail(
        scheme: 'otpauth',
        otype: 'TOTP',
        digits: 6,
        period: 30,
        algorithm: 'SHA1');
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.people),
                  hintText: '请输入机构名',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (String value) {
                  value = value.trim();
                  otpDetail.issuer = value;
                  return value.length >= 2 ? null : '机构名最少2个字符';
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: '请输入用户名',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (String value) {
                  value = value.trim();
                  otpDetail.account = value;
                  return value.length >= 2 ? null : '用户名最少2个字符';
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  hintText: '请输入base32密钥',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (String value) {
                  value = value.trim();
                  otpDetail.secret = value;
                  try {
                    if (value.length < 2) {
                      throw 'error';
                    }
                    base32.decode(value);
                  } catch (e) {
                    print(e);
                    return 'base32密钥不正确';
                  }
                  return null;
                },
              ),
              RadioItem(
                  title: '令牌类型:',
                  items: ['TOTP', 'HOTP'],
                  onSave: (val) {
                    otpDetail.otype = val;
                  }),
              RadioItem(
                  title: '密码位数:',
                  items: [6, 8],
                  onSave: (val) {
                    otpDetail.digits = val;
                  }),
              RadioItem(
                  title: '时间步数:',
                  items: [30, 60],
                  onSave: (val) {
                    otpDetail.period = val;
                  }),
              RadioItem(
                  title: '令牌算法:',
                  items: ['SHA1', 'SHA256', 'SHA512'],
                  onSave: (val) {
                    otpDetail.algorithm = val;
                  }),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '0',
                decoration: InputDecoration(
                  icon: Text('令牌计数:'),
                ),
                validator: (String value) {
                  value = value.trim();
                  var a = 0;
                  try {
                    a = num.parse(value);
                    if (a < 0) {
                      throw 'error';
                    }
                  } catch (e) {
                    return '请输入正确的数字';
                  }
                  otpDetail.counter = a;
                  return null;
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('重置'),
                        onPressed: () {
                          var _state = _formKey.currentState;
                          _state.reset();
                          otpDetail = initOtp();
                          setState(() {});
                        },
                      ),
                      RaisedButton(
                        child: Text('添加'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          var _state = _formKey.currentState;
                          if (_state.validate()) {
                            await OtpPrefs.addOtp(otpDetail);
                            //添加成功
                            Navigator.of(context).pop('ok');
                          }
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioItem<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Function(T) onSave;

  RadioItem({Key key, this.items, this.onSave, this.title}) : super(key: key);

  @override
  _RadioItemState createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem> {
  dynamic gValue;
  bool isInt = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gValue = widget.items[0];
    if (gValue is int) {
      isInt = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Text(widget.title, textScaleFactor: 1.01),
        ),

        //遍历输出
        for (var item in widget.items)
          Expanded(
            child: InkWell(
              onTap: () {
                widget.onSave(item);
                setState(() {
                  gValue = item;
                  print(gValue);
                });
              },
              child: Row(
                //mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    child: IgnorePointer(
                      child: Radio(
                        value: item,
                        groupValue: gValue,
                        onChanged: (value) {
                          //gValue = value;
                        },
                      ),
                    ),
                  ),
                  Text(isInt ? item.toString() : item),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
