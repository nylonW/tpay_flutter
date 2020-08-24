import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpay_flutter/tpay_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = 'version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Builder(builder: (context) {
                return MaterialButton(
                  child: Text(
                    "Open payment",
                  ),
                  onPressed: () async {
                    final result = await TpayFlutter.requestPayment(
                        id: '1010',
                        amount: '313.40',
                        crc: 'CRC',
                        securityCode: 'demo',
                        description: 'Zakupy',
                        clientEmail: 'email@email.com',
                        returnErrorUrl: "https://tpay.com/",
                        returnUrl: "https://tpay.com/",
                        clientName: 'Marcel');

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(result == TpayResult.success
                          ? 'Płatność przebiegła pomyślnie'
                          : "Nie udało się zrealizować zamówienia"),
                    ));
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
