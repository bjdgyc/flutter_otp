import 'dart:convert';

import 'package:barcode_scan/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan/model/scan_options.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp/component/util_fun.dart';
import 'package:flutter_otp/model/otp_detail.dart';
import 'package:flutter_otp/model/otp_prefs.dart';
import 'package:base32/base32.dart';

class OtpScan {
  static Future<String> initScan(BuildContext context) async {
    var url = '';
    try {
      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: [BarcodeFormat.qr],
          strings: {
            "cancel": "返回",
            "flash_on": "打开闪光灯",
            "flash_off": "关闭闪光灯",
          },
        ),
      );
      if (result.type != ResultType.Barcode ||
          result.format != BarcodeFormat.qr) {
        print(result.type);
        print(result.format); // The barcode format (as enum)
        print(result.formatNote);
        //showSnackBar(context, "扫描二维码错误");
        return 'err';
      }
      print(result.rawContent); // The barcode content
      url = result.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        //未授予APP相机权限--打开设置页面去设置
        //bool isOpened = await PermissionHandler().openAppSettings();
        showSnackBar(context, "请先开启摄像头权限");
        return 'err';
      }
      showSnackBar(context, "打开摄像头错误");
      return 'err';
    }

    //url='otpauth://totp/你好VPN:aa@btime.com?issuer=%E5%8C%97%E4%BA%AC%E6%97%B6%E9%97%B4VPN&secret=WXNM7IQOSARJ6HFUC3JLFZXUWA';
    //url='otpauth://hotp/%E4%B8%AD%E5%9B%BD:bjdgyc%40163.com?secret=zlddoquewdteptqkopkelah3wgv2vvx65njb3smdu4t3p43texi53dnp&algorithm=SHA256&digits=6&period=30&counter=0';
    var uri = Uri.parse(url);
    print(uri.scheme);
    print(uri.host);
    print(uri.path);
    print(uri.pathSegments);
    print(uri.queryParameters);

    var scheme = uri.scheme.toLowerCase();
    var host = uri.host.toUpperCase();
    var otype = uri.host.toUpperCase();
    var param = uri.queryParameters;

    if (scheme != 'otpauth' || !(host == 'TOTP' || host == 'HOTP')) {
      showSnackBar(context, "令牌类型错误");
      return 'err';
    }

    //密钥判断
    var secret = param['secret'] ?? '';
    try {
      if (secret.length < 2) {
        throw 'error';
      }
      base32.decode(secret);
    } catch (e) {
      showSnackBar(context, "令牌密钥错误");
      return 'err';
    }

    //算法判断
    var algorithm = (param['algorithm'] ?? 'SHA1').toUpperCase();
    if (!(algorithm == 'SHA1' ||
        algorithm == 'SHA256' ||
        algorithm == 'SHA512')) {
      showSnackBar(context, "令牌算法错误");
      return 'err';
    }

    var digits = int.parse(param['digits'] ?? '6');
    var period = int.parse(param['period'] ?? '30');
    var counter = int.parse(param['counter'] ?? '0');

    //机构和用户判断
    var issuer = param['issuer'] ?? 'issuer';
    var account = uri.pathSegments[0];
    if (account.contains(':')) {
      //freeotp判断方式
      var arr = account.split(':');
      issuer = arr[0];
      account = arr[1];
    }

    var otp = OtpDetail(
      raw: url,
      scheme: 'otpauth',
      otype: otype,
      account: account,
      issuer: issuer,
      secret: secret,
      digits: digits,
      period: period,
      counter: counter,
      algorithm: algorithm,
    );

    print(json.encode(otp));
    await OtpPrefs.addOtp(otp);

    return 'ok';
  }
}
