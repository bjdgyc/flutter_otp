import 'package:flutter/material.dart';

//显示SnackBar
showSnackBar(BuildContext context, String data) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 3000),
      content: Text(
        data,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
