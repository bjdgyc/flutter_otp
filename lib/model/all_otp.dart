import 'package:flutter/material.dart';

import 'otp_detail.dart';
import 'otp_prefs.dart';

class AllOtp with ChangeNotifier {
  //所有otp信息
  List<OtpDetail> _allOtp;

  List<OtpDetail> get allOtp {
    return _allOtp ?? OtpPrefs.getAllOtp();
  }

  //当前显示的索引
  int _disIndex = 0;

  int get disIndex {
    return _disIndex;
  }

  void update() {
    int oriLen = allOtp.length;
    _allOtp = OtpPrefs.getAllOtp();
    if (_allOtp.length != oriLen) {
      //每次更新后重置index
      _disIndex = 0;
    }

    notifyListeners();
  }

  void upIndex(int inx) {
    _disIndex = inx;
    notifyListeners();
  }
}
