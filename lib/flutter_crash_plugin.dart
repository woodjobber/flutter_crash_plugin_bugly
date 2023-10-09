import 'package:flutter/services.dart';

class FlutterCrashPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_crash_plugin');

  static void setAppId(appID) {
    _channel.invokeMethod("setAppId", {'app_id': appID});
  }

  static void postException(error, stack) {
    _channel.invokeMethod("postException",
        {'crash_message': error.toString(), 'crash_detail': stack.toString()});
  }
}
