import 'package:package_info/package_info.dart';

class Models {
  static PackageInfo packageInfo;

  static init() async {
    await _initPackage();
  }

  static _initPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
//    String appName = packageInfo.appName;
//    String version = packageInfo.version;
//    String packageName = packageInfo.packageName;
//    String buildNumber = packageInfo.buildNumber;
//    print(appName);
//    print(version);
//    print(packageName);
//    print(buildNumber);
  }
}
