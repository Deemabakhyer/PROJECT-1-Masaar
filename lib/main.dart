import 'package:flutter/material.dart';
// import 'package:masaar/views/assigning_driver.dart';
// import 'package:masaar/views/map.dart';
import 'package:masaar/views/newmap.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Newmap());
  }
}
