import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

enum TpayResult { success, failure }

class TpayFlutter {
  static const String RETURN_TO_APP = 'https://tpay.com/';

  static const MethodChannel _channel = const MethodChannel('tpay_flutter');

  static Future<TpayResult> requestPayment(
      {String id,
      String amount,
      String crc,
      String securityCode,
      String description,
      String clientEmail,
      String clientName,
      String returnErrorUrl,
      String returnUrl}) async {
    final int result = await _channel.invokeMethod('requestPayment', {
      "id": id,
      "amount": amount,
      'crc': crc,
      'securityCode': securityCode,
      'description': description,
      'clientEmail': clientEmail,
      'clientName': clientName,
      'returnErrorUrl': returnErrorUrl,
      'returnUrl': returnUrl,
      'md5sum':
          md5.convert(utf8.encode('$id&$amount&$crc&$securityCode')).toString(),
    });

    if (result == 0) {
      return TpayResult.failure;
    } else {
      return TpayResult.success;
    }
  }
}
