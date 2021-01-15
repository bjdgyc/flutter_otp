import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double height;

  const DividerWidget(this.height, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('build DividerWidget');
    return Container(
      child: Divider(
        height: height,
        thickness: height,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
