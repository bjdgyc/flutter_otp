import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_otp/page/index.dart';

import 'model/all_otp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllOtp(),
      child: MaterialApp(
        title: 'FLUTTER_OTP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //primarySwatch: Colors.red,
          canvasColor: Colors.grey[100],
          //画布颜色
          backgroundColor: Colors.grey[100],
          scaffoldBackgroundColor: Colors.grey[100],
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Index(),
      ),
    );
  }
}
