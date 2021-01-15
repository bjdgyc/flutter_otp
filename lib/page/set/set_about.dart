import 'package:flutter/material.dart';
import 'package:flutter_otp/model/models.dart';

class SetAbout extends StatelessWidget {
  final version = Models.packageInfo.version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 80,
              child: Image.asset('assets/img/logo.png', fit: BoxFit.fill),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text('FLUTTER_OTP', textScaleFactor: 1.5),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('版本: $version', textScaleFactor: 1.1),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(child: Text('FLUTTER_OTP 版权所有', textScaleFactor: 0.9)),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Copyright © 2020 Bjdgyc.All Rights Reserved.',
                          textScaleFactor: 0.9),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
