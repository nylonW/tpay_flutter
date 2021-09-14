import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

enum TpayResult { success, failure }

class TpayFlutter {
  static const String RETURN_TO_APP = 'https://tpay.com/';

  static const MethodChannel _channel = const MethodChannel('tpay_flutter');

  static Future<TpayResult> requestPayment(
      {required String id,
      required String amount,
      required String crc,
      required String securityCode,
      required String description,
      required String clientEmail,
      required String clientName,
      required String returnErrorUrl,
      required String returnUrl}) async {
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