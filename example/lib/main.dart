import 'package:bz_map/bz_map.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const AMapApiKey _apiKey = AMapApiKey(
    androidKey: 'your-android-key',
    iosKey: 'your-ios-key',
  );

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('bz_map example'),
        ),
        body: const AMapWidget(
          apiKey: _apiKey,
          privacyStatement: AMapPrivacyStatement(
            hasContains: true,
            hasShow: true,
            hasAgree: true,
          ),
          initialCameraPosition: _initialPosition,
        ),
      ),
    );
  }
}
