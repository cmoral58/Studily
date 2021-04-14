import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      "457849596697-cpjr29ppcdgct89g5ct8c1lv0vcfkfb6.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = null;
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}
