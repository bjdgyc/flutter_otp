import 'dart:convert';

import 'package:flutter_otp/dotp/otp.dart';
import 'package:flutter_otp/model/otp_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPrefs {
  static SharedPreferences _prefs;
  static String _testKey = '_otp_test_key';
  static String _otpPre = '_otp_pre_.';

  static Future<bool> init() async {
    _prefs = await SharedPreferences.getInstance();
    //await Future.delayed(Duration(seconds: 10), () {});
    return testDemo();
  }

  static Future<bool> testDemo() async {
    if (!_prefs.containsKey(_testKey)) {
      var otp = OtpDetail(
        scheme: 'otpauth',
        otype: 'TOTP',
        account: 'test@bjdgyc.com',
        issuer: 'flutter_otp-测试',
        secret: OTP.randomSecret(),
        digits: 6,
        period: 30,
        counter: 0,
        algorithm: 'SHA1',
      );
      await addOtp(otp);
    }

    return await _prefs.setString(_testKey, 'ok');
  }

  static Future<bool> setOtp(String key, OtpDetail otpDetail,
      {isAdd = false}) async {
    if (isAdd) {
      otpDetail.ctime = DateTime.now().toIso8601String();
    } else {
      otpDetail.utime = DateTime.now().toIso8601String();
    }
    var otpStr = json.encode(otpDetail);
    return await _prefs.setString(_otpPre + key, otpStr);
  }

  static Future<String> addOtp(OtpDetail otpDetail) async {
    var dnow = DateTime.now();
    var hkey = '${dnow.year}${_twoDigits(dnow.month)}${_twoDigits(dnow.day)}' +
        '${_twoDigits(dnow.hour)}${_twoDigits(dnow.minute)}' +
        '${_twoDigits(dnow.second)}_${dnow.millisecond}';
    otpDetail.key = hkey;
    await setOtp(hkey, otpDetail, isAdd: true);
    return hkey;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static OtpDetail getOtp(String key) {
    String k;
    if (key.startsWith(_otpPre)) {
      k = key;
    } else {
      k = _otpPre + key;
    }
    var res = _prefs.getString(k);
    if (res == null) {
      return null;
    }
    var aa = json.decode(res);
    //print(aa);
    return OtpDetail.fromJson(aa);
  }

  static List<OtpDetail> getAllOtp() {
    var keys = _prefs.getKeys();
    //print(keys);
    var allOtp = List<OtpDetail>();
    for (var key in keys) {
      if (key.startsWith(_otpPre)) {
        allOtp.add(getOtp(key));
      }
    }
    //升序排序
    allOtp.sort((left, right) => left.key.compareTo(right.key));
    //print(allOtp);
    return allOtp;
  }

  static Future<bool> removeOtp(String key) async {
    var k = _otpPre + key;
    return await _prefs.remove(k);
  }
}
