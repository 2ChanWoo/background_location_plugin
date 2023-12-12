import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:navillela_background_location/navillela_background_location.dart';

void main() {
  runApp(const MyApp());
}

bool on = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _navillelaBackgroundLocationPlugin = NavillelaBackgroundLocation();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // platformVersion =
      //     await _navillelaBackgroundLocationPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
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
          child: ElevatedButton(child: Text('UpdateLocation'), onPressed: () {
            if(!on) {
              on = true;
                NavillelaBackgroundLocation.startLocationService();
                NavillelaBackgroundLocation.getLocationUpdates(callback: (location) {
                  print("location data >> ${location!.toMap()}");
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text("title >> ${location.toMap()}"),
                      duration: const Duration(seconds: 2),
                    ));
                });
              } else {
              NavillelaBackgroundLocation.stopLocationService();
              on = false;
            }
            },),
        ),
      ),
    );
  }
}
