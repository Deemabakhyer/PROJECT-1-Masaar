import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:masaar/views/Home_views/active_cards.dart';
import 'package:masaar/views/Home_views/addcard.dart';
import 'package:masaar/views/Home_views/destinationconfirmation.dart';
import 'package:masaar/views/Home_views/home_page.dart';
import 'package:masaar/views/Home_views/package_types_page.dart';
import 'package:masaar/views/Home_views/payment_type_page.dart';
import 'package:masaar/views/Home_views/route_page.dart';
import 'package:masaar/views/Home_views/routeconfirmation.dart';
import 'package:masaar/widgets/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://vrsczitnkvjsterzxqpr.supabase.co',

    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyc2N6aXRua3Zqc3Rlcnp4cXByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMzk0MDEsImV4cCI6MjA2MjYxNTQwMX0.e9JkJnDntFXaW5zgCcS-A1ebMuZOfmFW59AADrB3OM4',
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
      getPages: [
        GetPage(name: '/Home', page: () => HomePage()),
        GetPage(name: '/route', page: () => RoutePage()),
        GetPage(name: '/pickup', page: () => Routeconfirmation()),
        GetPage(name: '/Destination', page: () => Destinationconfirmation()),
        GetPage(name: '/package_type', page: () => PackageTypesPage()),
        GetPage(name: '/payment', page: () => PaymentTypePage()),
        GetPage(name: '/card', page: () => AddCard()),
        GetPage(name: '/Actcard', page: () => ActiveCards()),
      ],
    ),
  );
}
