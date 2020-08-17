import 'dart:async';

import 'package:flutter/services.dart';

enum TpayResult { success, failure }

class TpayFlutter {
  static const MethodChannel _channel = const MethodChannel('tpay_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<TpayResult> requestPayment({String id,
    String amount,
    String crc,
    String securityCode,
    String description,
    String clientEmail,
    String clientName}) async {
    final int result = await _channel.invokeMethod('requestPayment', {
      "id": id,
      "amount": amount,
      'crc': crc,
      'securityCode': securityCode,
      'description': description,
      'clientEmail': clientEmail,
      'clientName': clientName
    });

    if (result == 0) {
      return TpayResult.failure;
    } else {
      return TpayResult.success;
    }
  }
}
