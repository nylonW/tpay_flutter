import 'dart:async';

import 'package:flutter/services.dart';

class TpayFlutter {
  static const MethodChannel _channel = const MethodChannel('tpay_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get requestPayment async {
    await _channel.invokeMethod('requestPayment');

    return true;
  }
}
