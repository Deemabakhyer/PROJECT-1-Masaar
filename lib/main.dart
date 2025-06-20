import 'package:flutter/material.dart';
import 'package:masaar/views/assigning_driver.dart';
import 'package:masaar/views/my_chat.dart';
import 'package:masaar/views/my_map.dart';
import 'package:masaar/views/ride_simulation.dart';
import 'package:masaar/views/test.dart';
import 'package:masaar/widgets/popups/submit_rating_popup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  await Supabase.initialize(
    url: 'https://vrsczitnkvjsterzxqpr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyc2N6aXRua3Zqc3Rlcnp4cXByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzk0MDEsImV4cCI6MjA2MjYxNTQwMX0.e9JkJnDntFXaW5zgCcS-A1ebMuZOfmFW59AADrB3OM4',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/test',
      getPages: [
        GetPage(name: '/assigning_driver', page: () => AssigningDriver()),
        GetPage(name: '/ride_simulation', page: () => RideSimulation()),
        GetPage(name: '/submit_rating', page: () => SubmitRating()),
        GetPage(name: '/test', page: () => Test()),
        GetPage(name: '/my_map', page: () => MyMap()),
        GetPage(name: '/my_chat', page: () => MyChat()),
      ],
    );
  }
}
