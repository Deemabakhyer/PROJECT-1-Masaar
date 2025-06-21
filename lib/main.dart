import 'package:flutter/material.dart';
import 'package:masaar/views/ride%20booking%20views/active_cards.dart';
import 'package:masaar/views/ride%20booking%20views/addcard.dart';
import 'package:masaar/views/ride%20booking%20views/destinationconfirmation.dart';
import 'package:masaar/views/ride%20booking%20views/home_page.dart';
import 'package:masaar/views/ride%20booking%20views/package_types_page.dart';
import 'package:masaar/views/ride%20booking%20views/payment_type_page.dart';
import 'package:masaar/views/ride%20booking%20views/route_page.dart';
import 'package:masaar/views/ride%20booking%20views/routeconfirmation.dart';
import 'package:masaar/views/ride%20booking%20views/assigning_driver.dart';
import 'package:masaar/views/ride%20booking%20views/my_chat.dart';
import 'package:masaar/views/ride%20booking%20views/my_map.dart';
import 'package:masaar/widgets/custom%20widgets/bottom_nav_bar.dart';
import 'package:masaar/views/ride%20booking%20views/ride_simulation.dart';
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

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
      initialRoute: '/ride_simulation',
      getPages: [
        GetPage(name: '/Home', page: () => HomePage()),
        GetPage(name: '/route', page: () => RoutePage()),
        GetPage(name: '/pickup', page: () => Routeconfirmation()),
        GetPage(name: '/Destination', page: () => Destinationconfirmation()),
        GetPage(name: '/package_type', page: () => PackageTypesPage()),
        GetPage(name: '/payment', page: () => PaymentTypePage()),
        GetPage(name: '/card', page: () => AddCard()),
        GetPage(name: '/Actcard', page: () => ActiveCards()),
        GetPage(name: '/assigning_driver', page: () => AssigningDriver()),
        GetPage(name: '/ride_simulation', page: () => RideSimulation()),
        GetPage(name: '/submit_rating', page: () => SubmitRating()),
        GetPage(name: '/my_map', page: () => MyMap()),
        GetPage(name: '/my_chat', page: () => MyChat()),
      ],
    ),
  );
}
